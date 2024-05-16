-- SPLITS
vim.cmd([[set splitbelow splitright]])

--Remap splits navigation
vim.api.nvim_set_keymap("n", "<LEADER>sa", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LEADER>ss", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<LEADER>sw", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LEADER>sd", "<C-w>l", { noremap = true, silent = true })

--Adjusting split sizes easier
vim.api.nvim_set_keymap("n", "<C-LEFT>", ":vertical resize +3<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-RIGHT>", ":vertical resize -3<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-UP>", ":resize +3<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-DOWN>", ":resize -3<CR>", { noremap = true, silent = true })

--Change 2 splits from vertical to horizontal or vice versa
vim.api.nvim_set_keymap("n", "<LEADER>th", "<C-w>t<C-w>H", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LEADER>tk", "<C-w>t<C-w>K", { noremap = true, silent = true })
