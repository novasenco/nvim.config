-- Author: Nova Senco
-- Last Change: 18 March 2022

local M = require'map-utils'

-- In Line: entire line sans white-space
M.xmap('sn', 'il', ':<c-u>normal! g_v^<cr>')
M.omap('sn', 'il', ':<c-u>normal! g_v^<cr>')
-- Around Line: entire line sans trailing newline
M.xmap('sn', 'al', 'm`$o0')
M.omap('sn', 'al', ':<c-u>normal! m`$v0<cr>')

-- In Document: from first line to last
M.xmap('sn', 'id', ':<c-u>normal! G$Vgg0<cr>')
M.omap('sn', 'id', ':<c-u>normal! GVgg<cr>')

-- Go Other: align this corner to other corner
M.xmap('sn', 'go', ':<c-u>call textobjs#visualGoOther(0)<cr>')
-- Get Other: align other corner to this corner
M.xmap('sn', 'gO', ':<c-u>call textobjs#visualGoOther(1)<cr>')

-- Go Line: move this corner to other corner's line
M.xmap('sn', 'gl', ':<c-u>call textobjs#visualGoLine(0)<cr>')
-- Get Line: move other line to this corner's line
M.xmap('sn', 'gL', ':<c-u>call textobjs#visualGoLine(1)<cr>')

-- In Number: next number after cursor on current line
M.xmap('sn', 'in', ':<c-u>call textobjs#inNumber()<cr>')
M.omap('sn', 'in', ':<c-u>call textobjs#inNumber()<cr>')
-- Around Number: next number on line and possible surrounding white-space
M.xmap('sn', 'an', ':<c-u>call textobjs#aroundNumber()<cr>')
M.omap('sn', 'an', ':<c-u>call textobjs#aroundNumber()<cr>')

-- In Indentation: indentation level sans any surrounding empty lines
M.xmap('sn', 'ii', ':<c-u>call textobjs#inIndentation()<cr>')
M.omap('sn', 'ii', ':<c-u>call textobjs#inIndentation()<cr>')
-- Around Indentation: indentation level and any surrounding empty lines
M.xmap('sn', 'ai', ':<c-u>call textobjs#aroundIndentation()<cr>')
M.omap('sn', 'ai', ':<c-u>call textobjs#aroundIndentation()<cr>')

