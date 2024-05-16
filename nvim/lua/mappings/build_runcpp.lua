local cpp_macros = vim.api.nvim_create_augroup("cpp_macros", {clear = true})
vim.api.nvim_create_autocmd(
--    {"BufEnter, WinEnter"}, {
      {"WinEnter", "BufEnter"}, {
        callback = function()
            location = vim.api.nvim_buf_get_name(0)
            if(vim.bo.filetype == "cpp" or vim.bo.filetype == "hpp" or vim.bo.filetype == "cmake") then
                --build a cpp project
                vim.api.nvim_set_keymap("n", "<LEADER>xy", ":wall<CR>:!python3 ~/.cppmacros/buildcpp.py \""..location.."\"<CR>", {silent = true, noremap = true})
                --make/run a cpp project
                vim.api.nvim_set_keymap("n", "<LEADER>xm", ":wall<CR>:!python3 ~/.cppmacros/makecpp.py \""..location.."\"<CR>", {silent = true, noremap = true})
                --run a cpp project
                vim.api.nvim_set_keymap("n", "<LEADER>xr", ":!python3 ~/.cppmacros/runcpp.py \""..location.."\"<CR>", {silent = true, noremap = true})
            end
        end,
        group = cpp_macros
    }
)

vim.api.nvim_create_autocmd(
    {"BufLeave", "WinLeave"}, {
        callback = function()
            if(vim.bo.filetype == "cpp" or vim.bo.filetype == "hpp" or vim.bo.filetype == "cmake") then
                del_keybind("n", "<LEADER>xy")
                del_keybind("n", "<LEADER>xm")
                del_keybind("n", "<LEADER>xr")
            end
        end
    }
)
