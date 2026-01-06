-- lpsb-table.lua
-- LPSB Lua module for capturing table structure (TR/TD) in LuaLaTeX.
--
-- Design goals:
-- - Avoid fragile TeX-side tabular cell hooks that can perturb rule drawing.
-- - Use a LuaTeX callback (hpack_filter) to observe packed alignment cells.
-- - Use a lightweight TeX-side row marker (\everycr -> \noalign{\directlua{...}})
--   to delimit rows safely.
--
-- Output:
--   <jobname>.lpsb-table.json  (JSON array)
--
-- NOTE:
-- This is an MVP. It emits TR/TD with row/col/text and box dimensions (w/h/d in sp).
-- It emits absolute bboxes (x0,y0,x1,y1). Coordinates are converted to PDF bp (1/72in).

local M = {}

local output_file = nil
local first_entry = true

local active = false
local in_header_footer = false  -- Flag to skip header/footer cell detection
local hpack_filter_enabled = true  -- Flag to disable hpack_filter entirely (for longtable)
local active_table_id = nil
local row = 0
local col = 0
local row_started = false
local rows = nil -- { {cells={...}}, ... }
local anchor = { page = 0, x = 0, y = 0 }
local row_pos = nil -- { [row]= {page=, x=, y=} }
local dirx = { x = 0, y = 0 } -- anchor + 1pt in local x (page coords)
local dir = { dx = 1.0, dy = 0.0 } -- local x direction in page coords per sp
local container_id = nil
-- Per-table row templates: stores first row cell count for each table
local table_row_templates = {}

-- Debug
local debug = os.getenv("LPSB_TABLE_DEBUG") == "1"
-- Test mode: hpack_filter immediately returns (for Priority 1 investigation)
local test_hpack_immediate_return = os.getenv("LPSB_TABLE_TEST_IMMEDIATE_RETURN") == "1"

-- Unit conversion:
-- TeX stores positions/dimensions in scaled points (sp).
-- 65536 sp = 1 TeX pt, and 1 bp = 72/72.27 TeX pt.
local SP_TO_BP = 72.0 / (72.27 * 65536.0)

local function sp_to_bp(v)
    return (tonumber(v) or 0) * SP_TO_BP
end

local function fmt_num(v)
    -- JSON number: keep ints as-is, otherwise emit a trimmed float.
    local n = tonumber(v) or 0
    if n == math.floor(n) then
        return string.format("%d", n)
    end
    local s = string.format("%.6f", n)
    s = s:gsub("0+$", ""):gsub("%.$", "")
    return s
end

local function write_event(json_str)
    if not output_file then
        return
    end
    if first_entry then
        first_entry = false
    else
        output_file:write(",\n")
    end
    output_file:write(json_str)
    output_file:flush()
end

local function escape_json(s)
    if not s then
        return ""
    end
    s = tostring(s)
    -- Escape backslash and quote first
    s = s:gsub("\\", "\\\\")
    s = s:gsub('"', '\\"')
    -- Escape control characters (JSON requires escaping U+0000 to U+001F)
    s = s:gsub("[%z\1-\31]", function(c)
        if c == "\n" then return "\\n" end
        if c == "\r" then return "\\r" end
        if c == "\t" then return "\\t" end
        if c == "\b" then return "\\b" end
        if c == "\f" then return "\\f" end
        return string.format("\\u%04x", string.byte(c))
    end)
    return s
end

local function extract_text_from_hlist(head)
    -- Very simple text extractor: concatenate glyphs in traversal order.
    -- For better quality we can implement (top,x) sorting later.
    local parts = {}
    for n in node.traverse(head) do
        local id = n.id
        if id == node.id("glyph") then
            parts[#parts + 1] = utf8.char(n.char)
        elseif id == node.id("glue") then
            -- keep spaces minimal
            parts[#parts + 1] = " "
        end
    end
    local txt = table.concat(parts)
    txt = txt:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return txt
end

local function json_kv_string(k, v)
    return string.format('"%s":"%s"', k, escape_json(v))
end

local function json_kv_number(k, v)
    return string.format('"%s":%s', k, fmt_num(v))
end

local function ev_to_json(ev)
    -- Minimal JSON encoder for our flat event objects.
    local parts = {}
    parts[#parts + 1] = "{"

    local function add_raw(s)
        parts[#parts + 1] = s
        parts[#parts + 1] = ","
    end

    add_raw(json_kv_string("id", ev.id or ""))
    add_raw(json_kv_string("role", ev.role or ""))
    add_raw(json_kv_string("event", ev.event or ""))

    if ev.row ~= nil then
        add_raw(json_kv_number("row", ev.row))
    end
    if ev.col ~= nil then
        add_raw(json_kv_number("col", ev.col))
    end
    if ev.colspan ~= nil then
        add_raw(json_kv_number("colspan", ev.colspan))
    end
    if ev.text ~= nil then
        add_raw(json_kv_string("text", ev.text))
    end
    if ev.w ~= nil then
        add_raw(json_kv_number("w", ev.w))
    end
    if ev.h ~= nil then
        add_raw(json_kv_number("h", ev.h))
    end
    if ev.d ~= nil then
        add_raw(json_kv_number("d", ev.d))
    end
    if ev.cols ~= nil then
        add_raw(json_kv_number("cols", ev.cols))
    end
    if ev.page ~= nil then
        add_raw(json_kv_number("page", ev.page))
    end
    if ev.container ~= nil then
        add_raw(json_kv_string("container", ev.container))
    end
    if ev.x0 ~= nil then
        add_raw(json_kv_number("x0", ev.x0))
        add_raw(json_kv_number("y0", ev.y0))
        add_raw(json_kv_number("x1", ev.x1))
        add_raw(json_kv_number("y1", ev.y1))
    end
    if ev.unit ~= nil then
        add_raw(json_kv_string("unit", ev.unit))
    end

    -- drop trailing comma if present
    if parts[#parts] == "," then
        parts[#parts] = nil
    end
    parts[#parts + 1] = "}"
    return table.concat(parts)
end

local function finalize_colspans(rows_data)
    -- Robust MVP colspan inference:
    -- - Determine atomic column count as max cells in any row.
    -- - For each row, distribute the missing columns (ncols - k) to the widest cells.
    --   This matches typical \multicolumn usage without depending on absolute width stability.
    local ncols = 0
    for _, r in ipairs(rows_data) do
        local k = r.cells and #r.cells or 0
        if k > ncols then
            ncols = k
        end
    end
    if ncols <= 0 then
        return 0
    end

    for _, r in ipairs(rows_data) do
        local cells = r.cells or {}
        local k = #cells
        if k == 0 then
            goto continue_row
        end

        -- Initial spans: 1 each.
        local span = {}
        for i = 1, k do
            span[i] = 1
        end

        local remaining = ncols - k
        if remaining > 0 then
            -- Sort indices by descending width.
            local idx = {}
            for i = 1, k do
                idx[i] = i
            end
            table.sort(idx, function(a, b)
                return (cells[a].w or 0) > (cells[b].w or 0)
            end)

            local j = 1
            while remaining > 0 do
                local ii = idx[j]
                span[ii] = span[ii] + 1
                remaining = remaining - 1
                if j < #idx then
                    j = j + 1
                else
                    -- If we still have remaining columns, keep adding to the widest cell.
                    j = 1
                end
            end
        end

        -- Assign absolute columns left-to-right.
        local cur = 1
        for i = 1, k do
            cells[i].col = cur
            cells[i].colspan = span[i]
            cur = cur + span[i]
        end

        ::continue_row::
    end

    return ncols
end

local function median(nums)
    if not nums or #nums == 0 then
        return 0
    end
    table.sort(nums)
    local n = #nums
    local mid = math.floor((n + 1) / 2)
    if n % 2 == 1 then
        return nums[mid]
    end
    return math.floor((nums[mid] + nums[mid + 1]) / 2)
end

local function infer_col_widths(rows_data, ncols)
    -- Use rows with exactly ncols cells as full rows.
    local per = {}
    for i = 1, ncols do
        per[i] = {}
    end
    local full = 0
    for _, r in ipairs(rows_data) do
        if r.cells and #r.cells == ncols then
            full = full + 1
            for i, cell in ipairs(r.cells) do
                per[i][#per[i] + 1] = cell.w or 0
            end
        end
    end
    local widths = {}
    if full > 0 then
        for i = 1, ncols do
            widths[i] = median(per[i])
        end
    else
        local sum = 0
        local count = 0
        for _, r in ipairs(rows_data) do
            for _, cell in ipairs(r.cells or {}) do
                sum = sum + (cell.w or 0)
                count = count + 1
            end
        end
        local avg = count > 0 and math.floor(sum / count) or 0
        for i = 1, ncols do
            widths[i] = avg
        end
    end
    return widths
end

local function infer_row_heights(rows_data)
    local heights = {}
    for r_i, r in ipairs(rows_data) do
        local max_h = 0
        local max_d = 0
        for _, cell in ipairs(r.cells or {}) do
            local h = cell.h or 0
            local d = cell.d or 0
            if h > max_h then max_h = h end
            if d > max_d then max_d = d end
        end
        heights[r_i] = { h = max_h, d = max_d }
    end
    return heights
end

local function sum_width(widths, start_col, span)
    local s = 0
    for i = 0, span - 1 do
        s = s + (widths[start_col + i] or 0)
    end
    return s
end

local function bbox_from_baseline(x0, yb, w, h, d)
    local x1 = x0 + w
    local y_top = yb + h
    local y_bot = yb - d
    local y0 = math.min(y_bot, y_top)
    local y1 = math.max(y_bot, y_top)
    return x0, y0, x1, y1
end

function M.set_anchor(page, x, y)
    anchor.page = tonumber(page) or 0
    anchor.x = tonumber(x) or 0
    anchor.y = tonumber(y) or 0
    row_pos = row_pos or {}
    row_pos[1] = { page = anchor.page, x = anchor.x, y = anchor.y }
end

function M.set_dirx(x, y)
    dirx.x = tonumber(x) or 0
    dirx.y = tonumber(y) or 0
    -- Derive local x direction vector per sp using 1pt offset (65536sp).
    local dx = (dirx.x - anchor.x) / 65536.0
    local dy = (dirx.y - anchor.y) / 65536.0
    local norm = math.sqrt(dx * dx + dy * dy)
    if norm > 0.000001 then
        dir.dx = dx / norm
        dir.dy = dy / norm
    else
        dir.dx = 1.0
        dir.dy = 0.0
    end
end

function M.set_container(cid)
    container_id = cid
end

function M.open_file(jobname)
    if not jobname or jobname == "" then
        jobname = (tex and tex.jobname) or (status and status.jobname) or "texput"
    end
    local filename = jobname .. ".lpsb-table.json"
    output_file = io.open(filename, "w")
    if output_file then
        output_file:write("[\n")
        texio.write_nl("term and log", "LPSB-Table: Opened " .. filename)
    end
end

function M.close_file()
    if output_file then
        output_file:write("\n]")
        output_file:close()
        texio.write_nl("term and log", "LPSB-Table: File closed")
    end
end

function M.begin_table(table_id)
    active = true
    active_table_id = table_id or "Table-unknown"
    row = 1
    col = 0
    row_started = false
    rows = { { cells = {} } }
    row_pos = {}
    container_id = container_id -- keep last value if set before begin_table
    if debug then
        texio.write_nl("term and log", "LPSB-Table: begin_table " .. tostring(active_table_id))
    end
end

function M.end_table()
    if not active then
        return
    end
    -- Remove trailing empty row if any.
    while rows and #rows > 0 do
        local last = rows[#rows]
        if last and last.cells and #last.cells == 0 then
            rows[#rows] = nil
        else
            break
        end
    end

    -- Save first row as template for this table (for future reference)
    if active_table_id and rows and rows[1] and rows[1].cells then
        table_row_templates[active_table_id] = #rows[1].cells
    end

    local ncols = finalize_colspans(rows or {})
    local col_widths = infer_col_widths(rows or {}, ncols)
    local row_heights = infer_row_heights(rows or {})

    -- Infer table local axes in page coordinates.
    -- Prefer row-to-row vector (more robust than TeX-mode-dependent dirx probing).
    local ux, uy = dir.dx, dir.dy
    local vx, vy = -uy, ux
    if row_pos and row_pos[1] and row_pos[2] then
        local rx = row_pos[2].x - row_pos[1].x
        local ry = row_pos[2].y - row_pos[1].y
        local rnorm = math.sqrt(rx * rx + ry * ry)
        if rnorm > 0.000001 then
            -- v: row progression direction (row1 -> row2) in page coords per sp.
            vx, vy = rx / rnorm, ry / rnorm
            -- u: perpendicular (local x axis).
            ux, uy = -vy, vx
        end
    end

    -- Optional y-axis correction (some engines report y from top; we want PDF-style bottom-up).
    -- Heuristic: if row progression goes "down" by increasing y, flip using page height.
    local flip_y = false
    local pageheight_sp = nil
    if row_pos and row_pos[1] and row_pos[2] then
        local ry = row_pos[2].y - row_pos[1].y
        if ry > 0 then
            flip_y = true
        end
    end
    if flip_y and tex and tex.dimen and tex.dimen.pageheight then
        pageheight_sp = tonumber(tex.dimen.pageheight) or nil
    end

    -- Emit JSON for this table instance.
    write_event(ev_to_json({ id = active_table_id, role = "Table", event = "start", cols = ncols, page = anchor.page, container = container_id, unit = "bp" }))
    for r_i, r in ipairs(rows or {}) do
        local tr_id = string.format("%s-TR%d", active_table_id, r_i)
        local rp = row_pos and row_pos[r_i] or nil
        local tr_page = (rp and rp.page) or anchor.page
        write_event(ev_to_json({ id = tr_id, role = "TR", event = "start", row = r_i, page = tr_page }))
        for _, cell in ipairs(r.cells or {}) do
            local td_id = string.format("%s-TD%d", tr_id, cell.col or 0)
            local base_x = (rp and rp.x) or anchor.x
            local base_y = (rp and rp.y) or anchor.y
            local offset = 0
            if cell.col and cell.col > 1 then
                offset = sum_width(col_widths, 1, cell.col - 1)
            end
            local w = sum_width(col_widths, cell.col or 1, cell.colspan or 1)
            local rh = row_heights[r_i] or { h = 0, d = 0 }

            local px = base_x + ux * offset
            local py = base_y + uy * offset

            local function addpt(x, y, dxs, dys)
                return x + dxs, y + dys
            end

            -- Corners (axis-aligned bbox of parallelogram).
            local xA, yA = px, py
            local xB, yB = addpt(px, py, ux * w, uy * w)
            local xC, yC = addpt(px, py, vx * (rh.h or 0), vy * (rh.h or 0))
            local xD, yD = addpt(xB, yB, vx * (rh.h or 0), vy * (rh.h or 0))
            local xE, yE = addpt(px, py, -vx * (rh.d or 0), -vy * (rh.d or 0))
            local xF, yF = addpt(xB, yB, -vx * (rh.d or 0), -vy * (rh.d or 0))

            local x0i = math.floor(math.min(xA, xB, xC, xD, xE, xF) + 0.5)
            local x1i = math.floor(math.max(xA, xB, xC, xD, xE, xF) + 0.5)
            local y0i = math.floor(math.min(yA, yB, yC, yD, yE, yF) + 0.5)
            local y1i = math.floor(math.max(yA, yB, yC, yD, yE, yF) + 0.5)

            if flip_y and pageheight_sp then
                local ny0 = pageheight_sp - y1i
                local ny1 = pageheight_sp - y0i
                y0i, y1i = ny0, ny1
            end

            write_event(ev_to_json({
                id = td_id,
                role = "TD",
                event = "start",
                row = r_i,
                col = cell.col,
                colspan = cell.colspan or 1,
                text = cell.text or "",
                w = sp_to_bp(w or 0),
                h = sp_to_bp(rh.h or 0),
                d = sp_to_bp(rh.d or 0),
                page = tr_page,
                x0 = sp_to_bp(x0i),
                y0 = sp_to_bp(y0i),
                x1 = sp_to_bp(x1i),
                y1 = sp_to_bp(y1i),
            }))
            write_event(ev_to_json({ id = td_id, role = "TD", event = "end" }))
        end
        write_event(ev_to_json({ id = tr_id, role = "TR", event = "end", row = r_i, page = tr_page }))
    end
    write_event(ev_to_json({ id = active_table_id, role = "Table", event = "end", page = anchor.page }))

    if debug then
        texio.write_nl("term and log", "LPSB-Table: end_table " .. tostring(active_table_id))
    end
    active = false
    active_table_id = nil
    row = 0
    col = 0
    row_started = false
    rows = nil
    row_pos = nil
    container_id = nil
end

function M.row_break(page, x, y)
    if not active then
        return
    end
    row = row + 1
    col = 0
    row_started = false
    if rows then
        rows[#rows + 1] = { cells = {} }
    end
    row_pos = row_pos or {}
    row_pos[row] = { page = tonumber(page) or 0, x = tonumber(x) or 0, y = tonumber(y) or 0 }
end

-- Try to only capture alignment cell packs.
-- In practice, groupcode differs between LuaTeX versions; we keep a heuristic:
-- - active table
-- - has some glyphs
local function hpack_filter(head, groupcode, size, packtype, direction)
    -- TEST MODE: Immediately return (Priority 1 investigation)
    if test_hpack_immediate_return then
        return head
    end
    
    -- Allow disabling hpack_filter entirely (e.g., for longtable which it corrupts)
    if not hpack_filter_enabled then
        return head
    end
    
    if not active then
        return head
    end

    -- Skip cell detection when processing longtable headers/footers
    if in_header_footer then
        if debug then
            texio.write_nl("LPSB-Table: Skipping cell (in header/footer)")
        end
        return head
    end

    local txt = extract_text_from_hlist(head)
    if txt == "" then
        return head
    end

    -- Automatic row detection (no LaTeX hooks needed)
    -- Per-table strategy: Each table has its own first-row template
    if row_started and col > 0 and active_table_id then
        -- Get or establish template for this table
        local template_cols = table_row_templates[active_table_id]
        
        if not template_cols then
            -- First row of this table - establish template after it's complete
            -- For now, just accumulate cells
        else
            -- Template exists - check if current row has reached the template count
            local current_row_cells = (rows and rows[#rows] and rows[#rows].cells) or {}
            
            if #current_row_cells >= template_cols then
                -- Start new row
                row = row + 1
                col = 0
                row_started = false
                if rows then
                    rows[#rows + 1] = { cells = {} }
                end
                if debug then
                    texio.write_nl("LPSB-Table: New row for " .. active_table_id .. " (r=" .. row .. ", template=" .. template_cols .. ")")
                end
            end
        end
    end

    if not row_started then
        row_started = true
    end

    col = col + 1

    -- Use the target hpack size when available: for tabular/alignment cells, hpack is
    -- typically done "to a width" (size). Content dimensions alone are not enough to
    -- infer colspan (multicolumn content can be narrow).
    local w = tonumber(size) or 0
    local h, d = 0, 0
    if w <= 0 then
        -- Fallback: content dimensions (best effort).
        local cw, ch, cd = node.dimensions(head)
        w = cw or 0
        h = ch or 0
        d = cd or 0
    else
        -- We still record content height/depth for debugging; width is the key signal.
        local _, ch, cd = node.dimensions(head)
        h = ch or 0
        d = cd or 0
    end

    if rows and rows[#rows] and rows[#rows].cells then
        rows[#rows].cells[#rows[#rows].cells + 1] = {
            text = txt,
            w = w or 0,
            h = h or 0,
            d = d or 0,
        }
    end

    if debug then
        texio.write_nl("term and log", string.format("LPSB-Table: TD r=%d c=%d txt=%s", row, col, txt))
    end

    return head
end

function M.init()
    if luatexbase and luatexbase.add_to_callback then
        luatexbase.add_to_callback("hpack_filter", hpack_filter, "lpsb_table_capture")
    else
        callback.register("hpack_filter", hpack_filter)
    end
    texio.write_nl("term and log", "LPSB-Table: Callback registered.")
end

-- Set flag for when longtable is processing headers/footers
-- to prevent hpack_filter from detecting them as data cells
function M.set_in_header_footer(flag)
    in_header_footer = flag
    if debug then
        texio.write_nl(string.format("LPSB-Table: in_header_footer = %s", tostring(flag)))
    end
end

-- Disable/enable hpack_filter entirely (for longtable which it corrupts)
function M.disable_hpack_filter()
    hpack_filter_enabled = false
    if debug then
        texio.write_nl("LPSB-Table: hpack_filter DISABLED")
    end
end

function M.enable_hpack_filter()
    hpack_filter_enabled = true
    if debug then
        texio.write_nl("LPSB-Table: hpack_filter ENABLED")
    end
end

return M


