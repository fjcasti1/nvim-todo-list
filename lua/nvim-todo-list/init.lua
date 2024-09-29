local funcs = require('nvim-todo-list.funcs')
local Config = require('nvim-todo-list.config')
local Path = require('plenary.path')

---@class TodoList
---@field config TodoListConfig
local TodoList = {}

TodoList.config = Config.get_default_config()

---@param user_config TodoListConfig?
TodoList.setup = function(user_config)
    -- you can define your setup function here. Usually configurations
    -- can be merged, accepting outside params and you can also put
    -- some validation here for those.
    TodoList.config = vim.tbl_deep_extend('force', TodoList.config, user_config or {})
end

-- Variable to store the buffer number and window ID for the opened file
local bufnr = nil
local winid = nil

-- Function to open a file in a vertical split and remember the buffer/window
local function open_file_in_split(filepath, direction)
    -- Determine the split direction based on the argument
    local split_cmd
    if direction == 'left' then
        split_cmd = 'leftabove vsplit' -- Open a vertical split on the left
    elseif direction == 'right' then
        split_cmd = 'vsplit' -- Open a vertical split on the right (default behavior)
    elseif direction == 'up' then
        split_cmd = 'leftabove split' -- Open a horizontal split above
    elseif direction == 'down' then
        split_cmd = 'split' -- Open a horizontal split below
    else
        -- Default to right split if direction is invalid or not provided
        split_cmd = 'vsplit'
    end
    -- Check if the file buffer already exists and is valid
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        -- Check if the window for the file is still valid
        if winid and vim.api.nvim_win_is_valid(winid) then
            -- If both buffer and window are valid, just switch to the window
            vim.api.nvim_set_current_win(winid)
            return
        else
            -- The buffer exists but the window was closed, so we need to reopen the split
            vim.cmd(split_cmd)
            winid = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(winid, bufnr)
            return
        end
    end

    -- If no valid file buffer exists, create a new one
    bufnr = vim.api.nvim_create_buf(false, false)
    -- Create split
    vim.cmd(split_cmd)
    -- Set the current window to use the new buffer
    vim.api.nvim_win_set_buf(0, bufnr)
    -- Save window id
    winid = vim.api.nvim_get_current_win()

    -- Open the file in a new buffer
    vim.cmd('edit ' .. filepath)

    vim.bo.modifiable = true -- Make sure the buffer is modifiable, as we're opening a file for editing
    vim.bo.buflisted = false -- Don't show buffer in buffer list

    -- Set up an autocommand to automatically save the file when exiting the buffer
    vim.api.nvim_create_autocmd('BufWinLeave', {
        buffer = bufnr, -- Attach to the specific buffer
        callback = function()
            if vim.bo.modified then -- Only save if there are changes
                vim.cmd('silent! write') -- Save the file
            end
        end,
    })
    -- Set up an autocommand to ensure buffer stays unlisted even when manually saved
    vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = bufnr, -- Attach to the specific buffer
        callback = function()
            vim.bo.buflisted = false -- Ensure the buffer stays unlisted after any save operation
        end,
    })
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        'X',
        '<cmd>TodoListToggleStatusDone<CR>',
        { noremap = true, silent = true }
    )
    -- Key mapping for normal mode to add TODO prefix when pressing 'o' or 'O'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'o', 'o- [ ] ', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'O', 'O- [ ] ', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<CR>', '<Esc><cmd>TodoListAddItem<CR><Esc>i', {})
end

TodoList.open_window = function()
    -- Function to open or create a file using plenary
    local file_path = Path:new(TodoList.config.filepath)
    file_path = Path:new(file_path:expand())
    assert(
        file_path:is_absolute() == true,
        'Error: the filepath set is not an absolute filepath' .. TodoList.config.filepath
    )
    file_path = Path:new(file_path)

    -- Check if the file exists
    if not file_path:exists() then
        -- If it doesn't exist, create an empty file
        file_path:touch({ parents = true }) -- Create file and missing directories
    end
    open_file_in_split(file_path:absolute(), TodoList.config.ui.split)
end

TodoList.add_new_todo = function()
    funcs.add_new_todo()
end

-- Define a function to toglle the TODO mark (done vs undone)
TodoList.toggle_todo_status = function()
    local line = vim.api.nvim_get_current_line()
    if funcs.is_todo_not_done(line) then
        -- TODO: The return of mark functions should be such that you don't need to double the brackets
        vim.api.nvim_set_current_line((funcs.mark_todo_done(line))) -- double (()) is intentional
    elseif funcs.is_todo_done(line) then
        vim.api.nvim_set_current_line((funcs.mark_todo_not_done(line))) -- double (()) is intentional
    end
end

-- TODO: Remove this function
TodoList.info = function()
    P(TodoList)
end

return TodoList
