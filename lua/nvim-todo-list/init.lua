local funcs = require('nvim-todo-list.funcs')
local Config = require('nvim-todo-list.config')
local Path = require('plenary.path')

---@class TodoList
---@field config TodoListConfig
local TodoList = {}

function TodoList:new()
  local config = Config.get_default_config()
  local instance = {
    config = config,
  }
  local todolist = setmetatable(instance, self)
  self.__index = self
  return todolist
end

local the_todolist = TodoList:new()

---@param self TodoList
---@param user_config TodoListConfig?
function TodoList.setup(self, user_config)
  if self ~= the_todolist then
    ---@diagnostic disable-next-line: cast-local-type
    user_config = self
    self = the_todolist
  end

  -- you can define your setup function here. Usually configurations
  -- can be merged, accepting outside params and you can also put
  -- some validation here for those.
  self.config = vim.tbl_deep_extend('force', self.config, user_config or {})
  return self
end

-- TODO: Remove this function
function TodoList:info()
  P(self)
end

function TodoList:hello()
  return funcs.my_first_function(self.config.greeting, self.config.name)
end

-- Variable to store the buffer number and window ID for the opened file
local file_bufnr = nil
local file_winid = nil

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
  if file_bufnr and vim.api.nvim_buf_is_valid(file_bufnr) then
    -- Check if the window for the file is still valid
    if file_winid and vim.api.nvim_win_is_valid(file_winid) then
      -- If both buffer and window are valid, just switch to the window
      vim.api.nvim_set_current_win(file_winid)
      return
    else
      -- The buffer exists but the window was closed, so we need to reopen the split
      vim.cmd(split_cmd)
      file_winid = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(file_winid, file_bufnr)
      return
    end
  end

  -- If no valid file buffer exists, create a new one
  vim.cmd(split_cmd) -- Open a vertical split
  file_winid = vim.api.nvim_get_current_win()

  -- Open the file in a new buffer
  vim.cmd('edit ' .. filepath)
  file_bufnr = vim.api.nvim_get_current_buf() -- Store the buffer number

  vim.bo.modifiable = true -- Make sure the buffer is modifiable, as we're opening a file for editing
  vim.bo.buflisted = false -- Don't show buffer in buffer list

  -- Set up an autocommand to automatically save the file when exiting the buffer
  vim.api.nvim_create_autocmd('BufWinLeave', {
    buffer = file_bufnr, -- Attach to the specific buffer
    callback = function()
      if vim.bo.modified then -- Only save if there are changes
        vim.cmd('silent! write') -- Save the file
      end
    end,
  })
  -- Set up an autocommand to ensure buffer stays unlisted even when manually saved
  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = file_bufnr, -- Attach to the specific buffer
    callback = function()
      vim.bo.buflisted = false -- Ensure the buffer stays unlisted after any save operation
    end,
  })
end

function TodoList:open()
  -- Function to open or create a file using plenary
  local file_path = Path:new(self.config.filepath)
  file_path = Path:new(file_path:expand())
  assert(
    file_path:is_absolute() == true,
    'Error: the filepath set is not an absolute filepath' .. self.config.filepath
  )
  file_path = Path:new(file_path)

  -- Check if the file exists
  if not file_path:exists() then
    -- If it doesn't exist, create an empty file
    file_path:touch({ parents = true }) -- Create file and missing directories
  end
  open_file_in_split(file_path:absolute(), self.config.ui.split)
end

return the_todolist
