-- main module file
local funcs = require('nvim-todo-list.funcs')

---@class Config
---@field opt string Your config option
local config = {
  opt = 'Hello!',
}

---@class TodoList
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
  M.config = vim.tbl_deep_extend('error', M.config, args or {})
end

M.hello = function()
  return funcs.my_first_function(M.config.opt)
end

return M
