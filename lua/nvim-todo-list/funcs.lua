---@class Funcs
local M = {}

---@return string

-- Function to check if a line starts with "- [ ] "
M.is_todo_not_done = function(line)
    return line:match('^%- %[ %] ')
end
-- Function to check if a line starts with "- [x] "
M.is_todo_done = function(line)
    return line:match('^%- %[x%] ')
end

-- Function to replace "- [x] " with "- [ ] "
M.mark_todo_not_done = function(line)
    return line:gsub('^%- %[x%]', '- [ ]', 1)
end
-- Function to replace "- [ ] " with "- [x] "
M.mark_todo_done = function(line)
    return line:gsub('%- %[ %]', '- [x]', 1)
end

-- Function to add TODO prefix when creating a new line
M.add_new_todo = function()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1] -- Get the current line number (1-based index)

    local prefix = '- [ ]  '
    -- Insert an empty line below the current line
    vim.api.nvim_buf_set_lines(current_buf, current_line_num, current_line_num, false, { prefix })

    -- Move the cursor to the new line
    vim.api.nvim_win_set_cursor(0, { current_line_num + 1, #prefix })
end

return M
