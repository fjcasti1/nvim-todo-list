---@class Funcs
local M = {}

---@return string
M.my_first_function = function(greeting, name)
  print(greeting, name)
  return greeting
end

return M
