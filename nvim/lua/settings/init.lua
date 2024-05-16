local opt = vim.opt
local o = vim.o
local cmd = vim.cmd

--end of line leads to beginning of next line
o.ww='<,>,[,]'

opt.expandtab=true
opt.smarttab=true
o.tabstop=4
o.shiftwidth=4

opt.mouse="a"

opt.smartcase=true
opt.ignorecase=true
--cmd([[%left 4]])
--good background color ctermbg=236
--colors
--Normal bg was 238
cmd([[hi Normal ctermbg=236]])
cmd([[set cursorline]])
cmd([[hi CursorLine cterm=NONE ctermbg=237 term=NONE]])
cmd([[hi LineNr ctermfg=247]])
--good bg for line nr of cursor 242
cmd([[hi cursorLineNr cterm=NONE ctermbg=237 ctermfg=white]])
cmd([[syntax on]])
--popup windows
cmd([[hi NormalFloat ctermbg=236]])
cmd([[set clipboard+=unnamedplus]])
-- autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
-- autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
-- cmd([[hi LspReferenceText ctermbg=236]])
-- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
-- vim.opt.updatetime=500

-- local highlight_document = vim.api.nvim_create_augroup("highlight_document", {clear = true})
-- vim.api.nvim_create_autocmd(
--     {"CursorHold", "CursorHoldI"}, {
--         callback = function()
--             vim.lsp.buf.document_highlight()
--         end,
--         group = highlight_document
--     }
-- )
--
-- vim.api.nvim_create_autocmd(
--     {"CursorMoved", "InsertCharPre"}, {
--         callback = function()
--             vim.lsp.buf.clear_references()
--         end,
--         group = highlight_document
--     }
-- )

--
--Line numbering
local toggle_numbers = vim.api.nvim_create_augroup("toggle-numbers", {clear = true})
vim.api.nvim_create_autocmd(
    {"InsertLeave", "BufEnter", "WinEnter"}, {
        callback = function()
            o.relativenumber=true
            o.number=true
        end,
        group=toggle_numbers
    }
)
vim.api.nvim_create_autocmd(
    {"BufLeave", "InsertEnter", "WinLeave"}, {
        callback=function()
            o.relativenumber=false
        end,
        group=toggle_numbers
    }
)
