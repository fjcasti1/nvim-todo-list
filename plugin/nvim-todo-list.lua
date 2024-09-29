local todolist = require('nvim-todo-list')
vim.api.nvim_create_user_command('TodoListOpenWindow', todolist.open_window, {})
vim.api.nvim_create_user_command('TodoListAddItem', todolist.add_new_todo, {})
vim.api.nvim_create_user_command('TodoListToggleStatusDone', todolist.toggle_todo_status, {})
