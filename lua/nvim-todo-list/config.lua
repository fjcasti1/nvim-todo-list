local DEFAULT_TODO_PATH = '~/.local/share/nvim/nvim-todo-list/TODO-default.md'

---@class TodoListConfig
---@field greeting string
---@field name string
---@field filepath string
---@field settings TodoListUI
local TodoListConfig = {}

---@return TodoListConfig
function TodoListConfig.get_default_config()
  return {
    greeting = 'Hello!',
    name = 'Kiko',
    filepath = DEFAULT_TODO_PATH,
    settings = {
      kind = 'markdown',
    },
  }
end

return TodoListConfig
