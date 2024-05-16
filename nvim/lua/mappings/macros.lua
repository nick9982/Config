vim.api.nvim_set_keymap("n", "<LEADER>nf", ":lua=prompt_new_file_name()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<LEADER>dcf", ":lua=prompt_delete_file()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<LEADER>nd", ":lua=prompt_new_directory_name()<CR>", {noremap = true, silent = true})

function prompt_delete_file()
    local requestNotSatisfied = true
    local location = vim.api.nvim_buf_get_name(0)
    local prmpt = 'Are you sure you would like to delete the file '..location..'? [Y/n] '
    while requestNotSatisfied do
        vim.ui.input({prompt = prmpt}, function(response)
            if response == 'Y' or response == 'y' then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":q<CR>:!rm "..location.."<CR><CR>", true, false, true), 'm', true)
                requestNotSatisfied = false
            elseif response == 'N' or response == 'n' then
                requestNotSatisfied = false
            else
                prmpt = 'Invalid response. Do you really want to delete the file you are in? [Y/n] '
            end
        end)
    end
end

function prompt_new_directory_name()
    vim.ui.input({prompt = 'New directory name: '}, function(newDirectoryName)
        local location = getBufferParentDirectoryPath()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":!mkdir "..location..newDirectoryName.."<CR><CR>", true, false, true), 'm', true)
    end)
end

function prompt_new_file_name()
    vim.ui.input({prompt = 'New file name: '}, function(newFileName)
        local location = getBufferParentDirectoryPath()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":e "..location..newFileName.."<CR>"..":w<CR>", true, false, true), 'm', true);
    end)
end

function getBufferParentDirectoryPath()
    local location = vim.api.nvim_buf_get_name(0)
    for i = 1, #location do
        if location:sub(#location-i, #location-i) == '/' then
            return location:sub(0, #location-i)
        end
    end
end
