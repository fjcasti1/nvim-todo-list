local funcs = require('nvim-todo-list.funcs')
local Config = require('nvim-todo-list.config')
local Ui = require('nvim-todo-list.ui')

---@class TodoList
---@field config TodoListConfig
---@field ui TodoListUI
local TodoList = {}

function TodoList:new()
  local config = Config.get_default_config()
  local todolist = setmetatable({
    config = config,
    ui = Ui:new(config.settings),
  }, self)

  return todolist
end

local the_todolist = TodoList:new()
---@param self TodoList
---@param user_config TodoListConfig?
---@return TodoList
TodoList.setup = function(self, user_config)
  -- you can define your setup function here. Usually configurations
  -- can be merged, accepting outside params and you can also put
  -- some validation here for those.
  if self ~= the_todolist then
    ---@diagnostic disable-next-line: cast-local-type
    user_config = self
    self = the_todolist
  end
  self.config = vim.tbl_deep_extend('force', the_todolist.config, user_config or {})
end

TodoList.hello = function(self)
  return funcs.my_first_function(self.config.opt, self.config.name)
end
