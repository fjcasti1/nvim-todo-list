local funcs = require('nvim-todo-list.funcs')
local Config = require('nvim-todo-list.config')
local Ui = require('nvim-todo-list.ui')
local Util = require('nvim-todo-list.utils')

---@class TodoList
---@field config TodoListConfig
---@field ui TodoListUI
local TodoList = {}

function TodoList:new()
  local config = Config.get_default_config()
  local instance = {
    config = config,
    ui = Ui:new(config.settings),
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
function TodoList:info()
  Util.pretty_print('Todolist info', self)
end

function TodoList:hello()
  return funcs.my_first_function(self.config.greeting, self.config.name)
end
return the_todolist
