-- Author: Nova Senco
-- Last Change: 07 March 2022

local M = vim.api.nvim_set_keymap
local sn = { silent = true, noremap = true }
local x = function(lhs, rhs) M('x', lhs, rhs, sn) end
local o = function(lhs, rhs) M('x', lhs, rhs, sn) end

-- In Line: entire line sans white-space
x('il', ':<c-u>normal! g_v^<cr>')
o('il', ':<c-u>normal! g_v^<cr>')
-- Around Line: entire line sans trailing newline
x('al', 'm`$o0')
o('al', ':<c-u>normal! m`$v0<cr>')

-- In Document: from first line to last
x('id', ':<c-u>normal! G$Vgg0<cr>')
o('id', ':<c-u>normal! GVgg<cr>')

-- Go Other: align this corner to other corner
x('go', ':<c-u>call textobjs#visualGoOther(0)<cr>')
-- Get Other: align other corner to this corner
x('gO', ':<c-u>call textobjs#visualGoOther(1)<cr>')

-- Go Line: move this corner to other corner's line
x('gl', ':<c-u>call textobjs#visualGoLine(0)<cr>')
-- Get Line: move other line to this corner's line
x('gL', ':<c-u>call textobjs#visualGoLine(1)<cr>')

-- In Number: next number after cursor on current line
x('in', ':<c-u>call textobjs#inNumber()<cr>')
o('in', ':<c-u>call textobjs#inNumber()<cr>')
-- Around Number: next number on line and possible surrounding white-space
x('an', ':<c-u>call textobjs#aroundNumber()<cr>')
o('an', ':<c-u>call textobjs#aroundNumber()<cr>')

-- In Indentation: indentation level sans any surrounding empty lines
x('ii', ':<c-u>call textobjs#inIndentation()<cr>')
o('ii', ':<c-u>call textobjs#inIndentation()<cr>')
-- Around Indentation: indentation level and any surrounding empty lines
x('ai', ':<c-u>call textobjs#aroundIndentation()<cr>')
o('ai', ':<c-u>call textobjs#aroundIndentation()<cr>')

