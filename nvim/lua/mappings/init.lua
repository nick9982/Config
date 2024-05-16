local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

map("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
map("n", "<C-x>", ":FzfLua files<CR>", { noremap = true, silent = true })
map("n", "<C-m>", ":Mason<CR>", { noremap = true, silent = true })
map("n", "<leader>y", "\"+y", { noremap = true, silent = true })
map("n", "<C-g>", ":Telescope live_grep<CR>", { noremap = true, silent = true })
map("n", "<leader>q", ":wall<CR>:qall<CR>", { noremap = true, silent = true })
map("n", "<leader>s", ":wall<CR>", {noremap = true, silent = true})

--tabs
map("n", "<C-s>", ":w<CR>", {silent = true})
map("n", "<leader>w", "<Cmd>BufferPrevious<CR>", {noremap = true, silent = true})
map("n", "<leader>e", "<Cmd>BufferNext<CR>", {noremap = true, silent = true})
map("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", {noremap = true, silent = true})
map("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", {noremap = true, silent = true})
map("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", {noremap = true, silent = true})
map("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", {noremap = true, silent = true})
map("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", {noremap = true, silent = true})
map("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", {noremap = true, silent = true})
map("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", {noremap = true, silent = true})
map("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", {noremap = true, silent = true})
map("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", {noremap = true, silent = true})
map("n", "<leader>0", "<Cmd>BufferLast<CR>", {noremap = true, silent = true})

