---@class TodoListUI
local TodoListUI = {}

---@param settings table<string, string>
---@return TodoListUI
function TodoListUI:new(settings)
  return setmetatable({
    settings = settings,
  }, self)
end

return TodoListUI
