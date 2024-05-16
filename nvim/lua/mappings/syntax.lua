local map = vim.api.nvim_set_keymap

function findFirstClass(str)
    for i=1, #str do
        local c = str:sub(i, i)
        if(c ~= ' ') then
            str = string.sub(str, i)
            break
        end
    end
    idxOfFirstSpace = string.find(str, " ")
    if idxOfFirstSpace == nil then
        return str == "class"
    end
    firstWord = string.sub(str, 1, idxOfFirstSpace-1)
    return firstWord == "class"
end

function contains_nonspace(str)
    for i=1, #str do
        local c = str:sub(i, i)
        if(c ~= ' ') then
            return true
        end
    end
    return false
end

function excludeCurlyBraces(currentLine)
    for i=1, #currentLine-1 do
        if currentLine:sub(i, i+1) == "{}" then
            local str1 = currentLine:sub(0, i-1)
            local str2 = currentLine:sub(i+2)
            return str1..str2
        end
    end
    return currentLine
end

--true this is main line. False this is not main line
function isCurrLineMain(currentLine, previousLine)
    currentLine = excludeCurlyBraces(currentLine)
    if(findFirstClass(currentLine)) then
        return true
    elseif(findFirstClass(previousLine)) then
        if(contains_nonspace(currentLine)) then
            return true
        else
            return false
        end
    elseif(contains_nonspace(currentLine)) then
        return true
    elseif(contains_nonspace(previousLine)) then
        return false
    end
    return false
end

function countSpaces(input)
    for i=1, #input do
        local c = input:sub(i, i)
        if(c ~= ' ') then
            return i-1
        end
        if(i == string.len(input))then
            return i
        end
    end
    return 0
end

function clearLine()
    vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1], 0})
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>d$i", true, false, true), 'm', true)
end

function curlyBracesCpp()
        -- deleteArrowBinds()
        del_keybind("i", "}")
        del_keybind("i", "<BS>")
    if (getCharBeforeCursor() == "{" and getCharAfterCursor() == "}") then
        del_keybind("i", "{")
        currentLine=vim.api.nvim_get_current_line()
        lineNumber=vim.api.nvim_win_get_cursor(0)[1]
        previousLine=vim.api.nvim_buf_get_lines(0, lineNumber-2, lineNumber-1, false)[1]
        baseOffCurrentLine=isCurrLineMain(currentLine, previousLine)
        colonAtEnd=false
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), 'm', true)
        vim.api.nvim_set_keymap("i", "x", "<CMD>lua=curlyBracesCpp1()<CR>x", { noremap = true, silent = true })
        if(baseOffCurrentLine) then
            spaces = countSpaces(currentLine)
            vim.api.nvim_feedkeys("\n", 'm', true)
            if(findFirstClass(currentLine)) then
                colonAtEnd=true
            end
        else
            spaces = countSpaces(previousLine)
            if(findFirstClass(previousLine)) then
                colonAtEnd=true
            end
        end
        indentation = ""
        for i=1, spaces, 1 do
            indentation = indentation.."<SPACE>"
        end
        vim.api.nvim_feedkeys("x", 'm', true)
    else
        vim.api.nvim_feedkeys("\n", 'm', true)
    end
end

function curlyBracesCpp1()
    clearLine()
    vim.api.nvim_set_keymap("i", "x", "<CMD>lua=curlyBracesCpp2()<CR>", {noremap = true, silent = true})
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indentation.."{\nx", true, false, true), 'm', true)
end

function curlyBracesCpp2()
    clearLine()
    vim.api.nvim_set_keymap("i", "x", "<CMD>lua=curlyBracesCpp3()<CR>", { noremap = true, silent = true })
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indentation.."<TAB>\nx", true, false, true), 'm', true)
end

function curlyBracesCpp3()
    clearLine()
    vim.api.nvim_set_keymap("i", "x", "<CMD>lua=curlyBracesFinalizeFormatCpp()<CR>", { noremap = true, silent = true })
    if(colonAtEnd) then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indentation.."};", true, false, true), 'm', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(indentation.."}", true, false, true), 'm', true)
    end
    vim.api.nvim_feedkeys("x", 'm', true)
end

function curlyBracesFinalizeFormatCpp()
    lineNumber = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_win_set_cursor(0, {lineNumber, spaces})
    local cntr = 1

    afterTab = string.sub(vim.api.nvim_get_current_line(), spaces+1)
    idxOfBracket = string.find(afterTab, "}")

    while (cntr < idxOfBracket) do
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<DEL>", true, false, true), 'm', true)
        cntr = cntr+1
    end
    vim.api.nvim_del_keymap("i", "x")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<UP><RIGHT><RIGHT><RIGHT><RIGHT>", true, false, true), 'm', true)
    vim.api.nvim_set_keymap("i", "{", "{<CMD>lua=autoClose(\"}\")<CR>", {silent = true, noremap = true})
end

function getCharAfterCursor()
    line = vim.api.nvim_get_current_line()
    linenr = vim.api.nvim_win_get_cursor(0)[2]
    return string.sub(line, linenr+1, linenr+1)
end

function getCharBeforeCursor()
    line = vim.api.nvim_get_current_line()
    linenr = vim.api.nvim_win_get_cursor(0)[2]
    return string.sub(line, linenr, linenr)
end

function arrowBindsForAutoClose()
    vim.api.nvim_set_keymap("i", "<LEFT>", "<LEFT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<RIGHT>", "<RIGHT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<UP>", "<UP>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<DOWN>", "<DOWN>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<ESC>", "x<BS><ESC>", {silent = true})
    vim.api.nvim_set_keymap("i", "<DEL>", "x<BS><DEL>", {silent = true})
end

function deleteArrowBinds()
    del_keybind("i", "<LEFT>")
    del_keybind("i", "<RIGHT>")
    del_keybind("i", "<UP>")
    del_keybind("i", "<DOWN>")
    del_keybind("i", "<ESC>")
    del_keybind("i", "<DEL>")
end

function charToRight(closingChar)
    vim.api.nvim_set_keymap("i", closingChar, "<RIGHT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<BS>", "<RIGHT>x<BS><BS><BS>", {silent = true})
    arrowBindsForAutoClose()
    local tmpcmd = vim.api.nvim_create_augroup("autoClose", { clear = true })
    vim.api.nvim_create_autocmd(
        {"InsertCharPre"}, {
            callback = function()
                del_keybind("i", closingChar)
                del_keybind("i", "<BS>")
                deleteArrowBinds()
                vim.api.nvim_create_augroup("autoClose", {clear = true})
            end,
            group=tmpcmd
        }
    )
end

function autoClose(closingChar)
    if(not isInQuote()) then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(closingChar.."<LEFT><CMD>lua=charToRight(\""..closingChar.."\")<CR>", true, false, true), 'm', true)
    end
end

function autoCloseTriBrack()
    if not isInQuote() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("><LEFT><CMD>lua=triBracketToRight(\">\")<CR>", true, false, true), 'm', true)
    end
end

function triBracketToRight()
    vim.api.nvim_set_keymap("i", ">", "<RIGHT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<BS>", "<RIGHT>x<BS><BS><BS>", { silent = true })
    arrowBindsForAutoClose()
    local tmpcmd = vim.api.nvim_create_augroup("autoClose", { clear = true })
    vim.api.nvim_create_autocmd(
        {"InsertCharPre"}, {
            callback = function()
                vim.api.nvim_del_keymap("i", ">")
                vim.api.nvim_del_keymap("i", "<BS>")
                deleteArrowBinds()
                vim.api.nvim_create_augroup("autoClose", {clear = true})
            end,
            group=tmpcmd
        }
    )
end

function autoCloseSingleQuote()
    if not isInQuote() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("'<LEFT><CMD>lua=singleQuoteToRight()<CR>", true, false, true), 'm', true)
    end
end

function singleQuoteToRight()
    vim.api.nvim_set_keymap("i", "'", "<RIGHT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<BS>", "<RIGHT>x<BS><BS><BS>", { silent = true })
    local tmpcmd = vim.api.nvim_create_augroup("autoClose", {clear = true})
    arrowBindsForAutoClose()
    vim.api.nvim_create_autocmd(
        {"InsertCharPre"}, {
            callback = function()
                vim.api.nvim_set_keymap("i", "'", "'<CMD>lua=autoCloseSingleQuote()<CR>", {silent = true, noremap = true})
                vim.api.nvim_del_keymap("i", "<BS>")
                deleteArrowBinds()
                vim.api.nvim_create_augroup("autoClose", {clear = true})
            end,
            group = tmpcmd
        }
    )
end

function autoCloseDoubleQuotes()
    if not isInQuoteForDQuote() then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"<LEFT><CMD>lua=doubleQuoteToRight()<CR>", true, false, true), 'm', true)
    end
end

function doubleQuoteToRight()
    vim.api.nvim_set_keymap("i", "\"", "<RIGHT>x<BS>", {silent = true})
    vim.api.nvim_set_keymap("i", "<BS>", "<RIGHT>x<BS><BS><BS>", {silent = true})
    arrowBindsForAutoClose()
    local tmpcmd = vim.api.nvim_create_augroup("autoClose", {clear = true})
    vim.api.nvim_create_autocmd(
        {"InsertCharPre"}, {
            callback = function()
                vim.api.nvim_set_keymap("i", "\"", "\"<CMD>lua=autoCloseDoubleQuotes()<CR>", { silent = true, noremap = true })
                vim.api.nvim_del_keymap("i", "<BS>")
                deleteArrowBinds()
                vim.api.nvim_create_augroup("autoClose", { clear = true })
            end,
            group = tmpcmd
        }
    )
end

function isInQuote()
    local currentLine = vim.api.nvim_get_current_line()
    local rmcntr = 0
    for i=1, #currentLine-1 do
        if currentLine:sub(i, i+1) == "\\\"" then
            rmcntr = rmcntr+2
        end
    end
    local currentLine = string.gsub(currentLine, "\\\"", "")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] - rmcntr
    if (cursor_pos > 0) then
        currentLine = string.sub(currentLine, 0, cursor_pos)
    else
        currentLine = ""
    end
    rmcntr = 0
    for i=1, #currentLine do
        if currentLine:sub(i, i) == "\"" then
            rmcntr = rmcntr + 1
        end
    end
    return rmcntr%2 == 1
end

function isInQuoteForDQuote()
    local currentLine = excludeCursor()
    local rmcntr = 0
    for i=1, #currentLine-1 do
        if currentLine:sub(i, i+1) == "\\\"" then
            rmcntr = rmcntr+2
        end
    end
    local currentLine = string.gsub(currentLine, "\\\"", "")
    local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] - rmcntr
    if (cursor_pos > 0) then
        currentLine = string.sub(currentLine, 0, cursor_pos)
    else
        currentLine = ""
    end
    rmcntr = 0
    for i=1, #currentLine do
        if currentLine:sub(i, i) == "\"" then
            rmcntr = rmcntr + 1
        end
    end
    return rmcntr%2 == 1
end

function excludeCursor()
    local line = vim.api.nvim_get_current_line()
    local cursor_location = vim.api.nvim_win_get_cursor(0)[2]
    local line1 = line:sub(0, cursor_location-1)
    local line2 = line:sub(cursor_location+1)
    return line1.."x"..line2
end


local syntax_mappings = vim.api.nvim_create_augroup("syntax_mappings", {clear = true})
vim.api.nvim_create_autocmd(
    {"BufEnter", "WinEnter"}, {
        callback = function()
            local filetype = vim.bo.filetype
            if(filetype == "cpp" or filetype == "hpp" or filetype == "c" or filetype == "h" or filetype == "js") then
                vim.api.nvim_set_keymap("i", "<CR>", "<CMD>lua=curlyBracesCpp()<CR>", {noremap = true})
                vim.api.nvim_set_keymap("i", "{", "{<CMD>lua=autoClose(\"}\")<CR>", {silent = true, noremap = true})
                vim.api.nvim_set_keymap("i", "(", "(<CMD>lua=autoClose(\")\")<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "[", "[<CMD>lua=autoClose(\"]\")<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "'", "'<CMD>lua=autoCloseSingleQuote()<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "\"", "\"<CMD>lua=autoCloseDoubleQuotes()<CR>", {noremap = true, silent = true})
            elseif (filetype == "lua" or filetype == "python" or filetype == "cmake")  then
                vim.api.nvim_set_keymap("i", "(", "(<CMD>lua=autoClose(\")\")<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "[", "[<CMD>lua=autoClose(\"]\")<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "'", "'<CMD>lua=autoCloseSingleQuote()<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "{", "{<CMD>lua=autoClose(\"}\")<CR>", {noremap = true, silent = true})
                vim.api.nvim_set_keymap("i", "\"", "\"<CMD>lua=autoCloseDoubleQuotes()<CR>", {noremap = true, silent = true})
            end
        end,
        group = syntax_mappings
    }
)

function del_keybind(mode, keybind)
    pcall(function()
            vim.api.nvim_del_keymap(mode, keybind)
         end)
end

vim.api.nvim_create_autocmd(
    {"BufLeave", "WinLeave"}, {
        callback = function()
            local filetype = vim.bo.filetype
            if(filetype == "cpp" or filetype == "hpp" or filetype == "c" or filetype == "h" or filetype == "js") then
                del_keybind("i", "{")
                del_keybind("i", "<CR>")
                del_keybind("i", "(")
                del_keybind("i", "[")
                del_keybind("i", "'")
                del_keybind("i", "\"")
            elseif(filetype == "lua" or filetype == "python" or filetype == "cmake") then
                del_keybind("i", "(")
                del_keybind("i", "{")
                del_keybind("i", "[")
                del_keybind("i", "'")
                del_keybind("i", "\"")
            end
        end,
        group = syntax_mappings
    }
)
