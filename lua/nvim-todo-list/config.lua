local Ui = require('nvim-todo-list.ui')
local DEFAULT_TODO_PATH = '~/.local/share/nvim/nvim-todo-list/TODO-default.md'

---@class TodoListConfig
---@field greeting string
---@field name string
---@field filepath string
---@field fileformat string
---@field ui TodoListUIConfig
local TodoListConfig = {}

---@return TodoListConfig
function TodoListConfig.get_default_config()
  return {
    greeting = 'Hello!',
    name = 'Kiko',
    filepath = DEFAULT_TODO_PATH,
    fileformat = 'markdown',
    ui = Ui.get_default_ui_settings(),
  }
end

return TodoListConfig
