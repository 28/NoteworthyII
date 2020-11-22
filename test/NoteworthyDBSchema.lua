local M = {}

function M.number(n)
    return type(n) == "number"
end

function M.table(t)
    return type(t) == "table"
end

function M.boolean(t)
    return type(t) == "boolean"
end

function M.string(t)
    return type(t) == "string"
end

function M.getschema()
    local S = {
        ["minimap_button"] = M.table,

        -- data
        ["character_count"] = M.number,
        ["character_list"] = M.table,
        ["Remind_" .. "<char>"] = M.string,
        ["<char>"] = M.string,
        ["shared_text"] = M.string,
        ["quick_text"] = M.string,

        -- session
        ["last_char"] = M.number,
        ["last_tab"] = M.number,
        ["last_curs"] = M.number,

        -- configuration
        ["initialised"] = M.boolean,
        ["version"] = M.number,
        ["remember_page"] = M.boolean,
        ["focus_text"] = M.boolean,
        ["combat_close"] = M.boolean,
        ["save_on_close"] = M.boolean,
        ["save_on_page_change"] = M.boolean,
        ["play_sounds"] = M.boolean,
        ["show_floating_button"] = M.boolean,
        ["qnote_prefix"] = M.boolean,
        ["qnote_edit"] = M.boolean,
        ["qnote_cursor"] = M.boolean,
        ["chat_logging"] = M.boolean,
        ["date_only_format"] = M.string,
        ["date_time_format"] = M.string,
        ["coord_format"] = M.string,
        ["snd_scribble"] = M.table,
        ["snd_pageturn"] = M.table,
        ["snd_pageclose"] = M.table,
    }
    return S
end

return M
