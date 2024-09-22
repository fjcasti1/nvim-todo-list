---@class Funcs
local M = {}

---@return string
M.my_first_function = function(greeting)
  print(greeting)
  return greeting
end

return M
