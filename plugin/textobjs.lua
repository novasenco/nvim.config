-- Author: Nova Senco
-- Last Change: 02 April 2022

local map = require'utils.map'

-- In Line: entire line sans white-space
map.x('sn', 'il', ':<c-u>normal! g_v^<cr>')
map.o('sn', 'il', ':<c-u>normal! g_v^<cr>')
-- Around Line: entire line sans trailing newline
map.x('sn', 'al', 'm`$o0')
map.o('sn', 'al', ':<c-u>normal! m`$v0<cr>')

-- In Document: from first line to last
map.x('sn', 'id', ':<c-u>normal! G$Vgg0<cr>')
map.o('sn', 'id', ':<c-u>normal! GVgg<cr>')

-- Go Other: align this corner to other corner
map.x('sn', 'go', ':<c-u>call textobjs#visualGoOther(0)<cr>')
-- Get Other: align other corner to this corner
map.x('sn', 'gO', ':<c-u>call textobjs#visualGoOther(1)<cr>')

-- Go Line: move this corner to other corner's line
map.x('sn', 'gl', ':<c-u>call textobjs#visualGoLine(0)<cr>')
-- Get Line: move other line to this corner's line
map.x('sn', 'gL', ':<c-u>call textobjs#visualGoLine(1)<cr>')

-- In Number: next number after cursor on current line
map.x('sn', 'in', ':<c-u>call textobjs#inNumber()<cr>')
map.o('sn', 'in', ':<c-u>call textobjs#inNumber()<cr>')
-- Around Number: next number on line and possible surrounding white-space
map.x('sn', 'an', ':<c-u>call textobjs#aroundNumber()<cr>')
map.o('sn', 'an', ':<c-u>call textobjs#aroundNumber()<cr>')

-- In Indentation: indentation level sans any surrounding empty lines
map.x('sn', 'ii', ':<c-u>call textobjs#inIndentation()<cr>')
map.o('sn', 'ii', ':<c-u>call textobjs#inIndentation()<cr>')
-- Around Indentation: indentation level and any surrounding empty lines
map.x('sn', 'ai', ':<c-u>call textobjs#aroundIndentation()<cr>')
map.o('sn', 'ai', ':<c-u>call textobjs#aroundIndentation()<cr>')

