local DEFAULT_TODO_PATH = '~/.local/share/nvim/nvim-todo-list/TODO-default.md'

---@class TodoListConfig
---@field opt string
---@field name string
---@field filepath string
---@field settings TodoListUI
local TodoListConfig = {}

---@return TodoListConfig
function TodoListConfig.get_default_config()
  return {
    opt = 'Hello!',
    name = 'Kiko',
    filepath = DEFAULT_TODO_PATH,
    settings = {},
  }
end

return TodoListConfig
