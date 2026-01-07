-- lpsb-math.lua
-- LPSB Lua module for capturing ALL math in LuaLaTeX
-- With page/coordinate capture and align environment grouping
-- v2.1 - 2026-01-07

local M = {}

-- State
local section_num = 0
local display_in_section = 0
local inline_in_section = 0
local align_in_section = 0  -- Counter for align environments
local output_file = nil
local first_entry = true

-- Math tracking
local math_id_counter = 0
local math_entries = {}
local lpsb_math_attr = nil

-- Align detection state
local in_align_mode = false
local align_group = nil  -- Current align group being built
local align_start_counter = 0  -- Counter when align started
local last_math_time = 0  -- For detecting rapid consecutive math

-- Optional MathML conversion
local luamml_convert_ok, luamml_convert = pcall(require, "luamml-convert")
local luamml_xml_ok, luamml_xmlwriter = pcall(require, "luamml-xmlwriter")

-- Helper: escape string for JSON
local function escape_json(s)
    if not s then return "" end
    s = tostring(s)
    s = s:gsub('\\', '\\\\')
    s = s:gsub('"', '\\"')
    s = s:gsub('\n', '\\n')
    s = s:gsub('\r', '\\r')
    s = s:gsub('\t', '\\t')
    return s
end

-- Helper: convert sp to bp
local function sp_to_bp(sp)
    if not sp or sp == 0 then return 0 end
    return sp / 65536 / 72.27 * 72
end

-- Called from TeX when section changes
function M.new_section(num)
    section_num = num
    display_in_section = 0
    inline_in_section = 0
    align_in_section = 0
    -- Flush any pending align group
    if align_group then
        finalize_align_group()
    end
end

-- Open output file
function M.open_file(jobname)
    if not jobname or jobname == "" then
        jobname = (tex and tex.jobname) or "texput"
    end
    local filename = jobname .. ".lpsb-math.json"
    output_file = io.open(filename, "w")
    if output_file then
        output_file:write("[\n")
        texio.write_nl("term and log", "LPSB-Math: Opened " .. filename)
    end
end

-- Write JSON entry
local function write_event(json_str)
    if output_file then
        if first_entry then
            first_entry = false
        else
            output_file:write(",\n")
        end
        output_file:write(json_str)
        output_file:flush()
    end
end

-- Get current page
local function get_current_page()
    local page = tex.count[0]
    if page and page > 0 then return page end
    return 1
end

-- Set attribute recursively
local function set_attr_recursive(head, attr, val)
    for n in node.traverse(head) do
        node.set_attribute(n, attr, val)
        if n.head then set_attr_recursive(n.head, attr, val) end
        if n.list then set_attr_recursive(n.list, attr, val) end
    end
end

-- Finalize align group - merge cells into one entry
local function finalize_align_group()
    if not align_group or #align_group.cells == 0 then
        align_group = nil
        return
    end
    
    -- Merge MathML from all cells
    local combined_mathml_parts = {}
    local total_width = 0
    local max_height = 0
    local max_depth = 0
    
    for _, cell in ipairs(align_group.cells) do
        if cell.mathml and cell.mathml ~= "" then
            -- Extract content from <math>...</math>
            local content = cell.mathml:match("<math[^>]*>(.-)</math>")
            if content and content ~= "" then
                table.insert(combined_mathml_parts, content)
            end
        end
        total_width = total_width + (cell.width or 0)
        if cell.height and cell.height > max_height then max_height = cell.height end
        if cell.depth and cell.depth > max_depth then max_depth = cell.depth end
    end
    
    -- Build combined MathML
    local combined_mathml = ""
    if #combined_mathml_parts > 0 then
        combined_mathml = '<math display="block" xmlns="http://www.w3.org/1998/Math/MathML"><mtable>'
        -- Group cells into rows (estimate: cells come in pairs for align)
        local row = {}
        for i, part in ipairs(combined_mathml_parts) do
            table.insert(row, "<mtd>" .. part .. "</mtd>")
            if i % 2 == 0 or i == #combined_mathml_parts then
                combined_mathml = combined_mathml .. "<mtr>" .. table.concat(row) .. "</mtr>"
                row = {}
            end
        end
        combined_mathml = combined_mathml .. "</mtable></math>"
        combined_mathml = escape_json(combined_mathml)
    end
    
    -- Create the merged align entry
    align_in_section = align_in_section + 1
    local id = string.format("Sec-%d-Align-%d", section_num, align_in_section)
    
    math_id_counter = math_id_counter + 1
    local attr_val = math_id_counter
    
    math_entries[attr_val] = {
        id = id,
        display = true,
        type = "align",
        cell_count = #align_group.cells,
        page = align_group.page,
        width = total_width,
        height = max_height,
        depth = max_depth,
        mathml = combined_mathml,
        x = nil,
        y = nil
    }
    
    align_group = nil
end

-- Check if this looks like an align cell (displaystyle inline math)
local function is_align_cell(mathml, is_display)
    if is_display then return false end  -- Display math is not an align cell
    -- Check for displaystyle wrapper (indicates alignment context)
    if mathml and mathml:match('displaystyle="true"') then
        return true
    end
    return false
end

-- Callback: intercept all math lists
local function process_math(head, style, penalties)
    local is_display = false
    if style == "display" or style == 0 or style == 1 then
        is_display = true
    end

    local page = get_current_page()
    
    -- Try MathML extraction first
    local mathml = ""
    if luamml_convert_ok and luamml_convert and luamml_xml_ok and luamml_xmlwriter then
        local cur_style = is_display and 0 or 2
        local ok1, tree_or_err = pcall(luamml_convert.process, head, cur_style, {})
        if ok1 and tree_or_err then
            local ok2, root_or_err = pcall(luamml_convert.make_root, tree_or_err, cur_style)
            if ok2 and root_or_err then
                local ok3, xml_or_err = pcall(luamml_xmlwriter, root_or_err, false, nil)
                if ok3 and xml_or_err then
                    mathml = tostring(xml_or_err)
                end
            end
        end
    end
    
    -- Convert to hlist
    local new_head = node.mlist_to_hlist(head, style, penalties)
    
    -- Get dimensions
    local width, height, depth = 0, 0, 0
    if new_head then
        for nd in node.traverse(new_head) do
            if nd.width then width = width + nd.width end
            if nd.height and nd.height > height then height = nd.height end
            if nd.depth and nd.depth > depth then depth = nd.depth end
        end
    end
    
    -- Check if this is an align cell
    local is_cell = is_align_cell(mathml, is_display)
    
    if is_cell then
        -- Part of an align environment
        if not align_group then
            align_group = {
                page = page,
                cells = {}
            }
        end
        
        -- Skip empty cells (width = 0)
        if width > 0 or (mathml and not mathml:match('<mstyle[^>]*/>')  and mathml ~= "") then
            table.insert(align_group.cells, {
                mathml = mathml,
                width = sp_to_bp(width),
                height = sp_to_bp(height),
                depth = sp_to_bp(depth)
            })
        end
        
        -- Tag for position tracking (use group's first attr)
        if lpsb_math_attr and new_head then
            -- We'll use a placeholder; position will come from align group
        end
    else
        -- Finalize any pending align group
        if align_group then
            finalize_align_group()
        end
        
        -- Regular math (inline or display)
        local id
        if is_display then
            display_in_section = display_in_section + 1
            id = string.format("Sec-%d-Math-%d", section_num, display_in_section)
        else
            inline_in_section = inline_in_section + 1
            id = string.format("Sec-%d-IMath-%d", section_num, inline_in_section)
        end
        
        math_id_counter = math_id_counter + 1
        local attr_val = math_id_counter
        
        -- Tag for position tracking
        if lpsb_math_attr and new_head then
            set_attr_recursive(new_head, lpsb_math_attr, attr_val)
        end
        
        math_entries[attr_val] = {
            id = id,
            display = is_display,
            type = is_display and "display" or "inline",
            page = page,
            width = sp_to_bp(width),
            height = sp_to_bp(height),
            depth = sp_to_bp(depth),
            mathml = escape_json(mathml),
            x = nil,
            y = nil
        }
    end
    
    return new_head
end

-- Pre-shipout callback
local function capture_positions(box)
    if not lpsb_math_attr then return box end
    
    local page_num = tex.count[0] or 1
    
    local function traverse(head, x_offset, y_offset)
        if not head then return end
        local x, y = x_offset, y_offset
        
        for n in node.traverse(head) do
            local attr_val = node.get_attribute(n, lpsb_math_attr)
            
            if attr_val and math_entries[attr_val] and not math_entries[attr_val].x then
                math_entries[attr_val].x = sp_to_bp(x)
                math_entries[attr_val].y = sp_to_bp(y)
                math_entries[attr_val].page = page_num
            end
            
            local subhead = n.head or n.list
            if subhead then
                local sub_x = x
                local sub_y = y - (n.shift or 0)
                traverse(subhead, sub_x, sub_y)
            end
            
            if n.width then x = x + n.width end
        end
    end
    
    local page_height = tex.pageheight or 0
    if box then
        if box.list then
            traverse(box.list, 0, sp_to_bp(page_height))
        elseif box.head then
            traverse(box.head, 0, sp_to_bp(page_height))
        else
            traverse(box, 0, sp_to_bp(page_height))
        end
    end
    
    return box
end

-- Close file
function M.close_file()
    -- Finalize any pending align group
    if align_group then
        finalize_align_group()
    end
    
    local count = 0
    for i = 1, math_id_counter do
        local entry = math_entries[i]
        if entry then
            count = count + 1
            local x_val = entry.x or 0
            local y_val = entry.y or 0
            
            local type_str = entry.type or (entry.display and "display" or "inline")
            local extra = ""
            if entry.cell_count then
                extra = string.format(', "cell_count": %d', entry.cell_count)
            end
            
            write_event(string.format(
                '{"id": "%s", "role": "Math", "event": "start", "type": "%s", "display": %s, "page": %d, "x": %.2f, "y": %.2f, "width": %.2f, "height": %.2f, "depth": %.2f%s, "mathml": "%s"}',
                entry.id,
                type_str,
                entry.display and "true" or "false",
                entry.page,
                x_val, y_val,
                entry.width, entry.height, entry.depth,
                extra,
                entry.mathml
            ))
            write_event(string.format('{"id": "%s", "role": "Math", "event": "end"}', entry.id))
        end
    end
    
    if output_file then
        output_file:write("\n]")
        output_file:close()
        texio.write_nl("term and log", string.format("LPSB-Math: Captured %d math expressions.", count))
    end
end

function M.init()
    lpsb_math_attr = luatexbase.new_attribute("lpsb@mathid")
    
    if luatexbase and luatexbase.add_to_callback then
        -- luatexbase exists in older TeX Live too, but some callback plumbing differs.
        -- Be defensive: if luatexbase rejects registration, fall back to raw callback.register.
        local ok1, err1 = pcall(luatexbase.add_to_callback, "mlist_to_hlist", process_math, "lpsb_math_capture")
        local ok2, err2 = pcall(luatexbase.add_to_callback, "pre_shipout_filter", capture_positions, "lpsb_math_positions")
        if not (ok1 and ok2) then
            if texio and texio.write_nl then
                texio.write_nl("term and log", "LPSB-Math: luatexbase.add_to_callback failed; falling back to callback.register")
            end
            if not ok1 and err1 and texio and texio.write_nl then
                texio.write_nl("term and log", "LPSB-Math: callback error (mlist_to_hlist): " .. tostring(err1))
            end
            if not ok2 and err2 and texio and texio.write_nl then
                texio.write_nl("term and log", "LPSB-Math: callback error (pre_shipout_filter): " .. tostring(err2))
            end
            callback.register("mlist_to_hlist", process_math)
            callback.register("pre_shipout_filter", capture_positions)
        end
    else
        callback.register("mlist_to_hlist", process_math)
        callback.register("pre_shipout_filter", capture_positions)
    end
    texio.write_nl("term and log", "LPSB-Math: Initialized with align grouping")
end

return M
