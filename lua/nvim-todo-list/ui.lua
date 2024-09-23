---@class TodoListUIConfig
---@field split string
local TodoListUIConfig = {}

---@return TodoListUIConfig
function TodoListUIConfig.get_default_ui_settings()
  return {
    split = 'left',
  }
end

return TodoListUIConfig
