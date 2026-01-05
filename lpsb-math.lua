-- lpsb-math.lua
-- LPSB Lua module for capturing ALL math (including $...$) in LuaLaTeX
-- Syncs with TeX counters via explicit callbacks

local M = {}

-- State (synchronized with TeX via new_section())
local section_num = 0
local math_in_section = 0
local output_file = nil
local first_entry = true

-- Optional MathML conversion via luamml
local luamml_convert_ok, luamml_convert = pcall(require, "luamml-convert")
local luamml_xml_ok, luamml_xmlwriter = pcall(require, "luamml-xmlwriter")
local debug_mml = os.getenv("LPSB_MATH_DEBUG") == "1"
local warned_mml = false

-- Called from TeX when section changes
function M.new_section(num)
    section_num = num
    math_in_section = 0
    texio.write_nl("term and log", string.format("LPSB-Math: Section %d started", num))
end

-- Open output file
function M.open_file(jobname)
    if not jobname or jobname == "" then
        jobname = (tex and tex.jobname) or (status and status.jobname) or "texput"
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

-- Callback: intercept all math lists
local function process_math(head, style, penalties)
    math_in_section = math_in_section + 1
    
    local id = string.format("Sec-%d-Math-%d", section_num, math_in_section)
    local is_display = false
    -- LuaTeX can pass style as a string ("display") or numeric math style.
    if style == "display" or style == 0 or style == 1 then
        is_display = true
    end
    
    -- Try MathML extraction (optional)
    local mathml = ""
    if luamml_convert_ok and luamml_convert and luamml_xml_ok and luamml_xmlwriter then
        -- Map into luamml style domain: <2 => display, >=2 => inline.
        local cur_style = is_display and 0 or 2
        -- Third argument: text_families table (must be non-nil).
        local ok1, tree_or_err = pcall(luamml_convert.process, head, cur_style, {})
        if ok1 and tree_or_err then
            local ok2, root_or_err = pcall(luamml_convert.make_root, tree_or_err, cur_style)
            if ok2 and root_or_err then
                local ok3, xml_or_err = pcall(luamml_xmlwriter, root_or_err, false, nil)
                if ok3 and xml_or_err then
                    mathml = tostring(xml_or_err)
                    mathml = mathml:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\r', ' '):gsub('\n', ' ')
                elseif debug_mml and not warned_mml then
                    warned_mml = true
                    texio.write_nl("term and log", "LPSB-Math: luamml xmlwriter failed: " .. tostring(xml_or_err))
                end
            elseif debug_mml and not warned_mml then
                warned_mml = true
                texio.write_nl("term and log", "LPSB-Math: luamml make_root failed: " .. tostring(root_or_err))
            end
        elseif debug_mml and not warned_mml then
            warned_mml = true
            texio.write_nl("term and log", "LPSB-Math: luamml process failed: " .. tostring(tree_or_err))
        end
    elseif debug_mml and not warned_mml then
        warned_mml = true
        texio.write_nl("term and log", "LPSB-Math: luamml modules missing (convert_ok=" .. tostring(luamml_convert_ok) .. ", xml_ok=" .. tostring(luamml_xml_ok) .. ")")
    end
    
    -- Write start event
    write_event(string.format(
        '{"id": "%s", "role": "Math", "event": "start", "display": %s, "mathml": "%s"}',
        id, is_display and "true" or "false", mathml
    ))
    
    -- Standard conversion
    local new_head = node.mlist_to_hlist(head, style, penalties)
    
    -- Write end event
    write_event(string.format('{"id": "%s", "role": "Math", "event": "end"}', id))
    
    return new_head
end

-- Close file
function M.close_file()
    if output_file then
        output_file:write("\n]")
        output_file:close()
        texio.write_nl("term and log", "LPSB-Math: File closed")
    end
end

function M.init()
    -- In LaTeX/LuaLaTeX, direct callback.register() is blocked; use luatexbase's callback chain.
    if luatexbase and luatexbase.add_to_callback then
        luatexbase.add_to_callback("mlist_to_hlist", process_math, "lpsb_math_capture")
    else
        -- Fallback for plain LuaTeX formats
        callback.register("mlist_to_hlist", process_math)
    end
    texio.write_nl("term and log", "LPSB-Math: Callback registered. Counters synced with TeX.")
end

return M
