vim.api.nvim_create_user_command('TodoListToggle', require('nvim-todo-list').hello, {})
vim.api.nvim_create_user_command('TestPrint', print('caca'), {})
