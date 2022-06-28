-- Author: Nova Senco
-- Last Change: 27 June 2022

local map = require'utils.map'.set

map('xo',  'il', '<cmd>normal! g_v^<cr>', 'sn', 'In Line: entire line sans white-space')
map('xo',  'al', '<cmd>normal! m`$v0<cr>', 'sn', 'Around Line: entire line sans trailing newline')

map('xo',  'id', '<cmd>normal! G$Vgg0<cr>', 'sn', 'In Document: from first line to last')

map('x',  'go', '<cmd>call textobjs#visualGoOther(0)<cr>', 'sn', 'Go Other: align this corner to other corner')
map('x',  'gO', '<cmd>call textobjs#visualGoOther(1)<cr>', 'sn', 'Get Other: align other corner to this corner')

map('x',  'gl', '<cmd>call textobjs#visualGoLine(0)<cr>', 'sn', "Go Line: move this corner to other corner's line")
map('x',  'gL', '<cmd>call textobjs#visualGoLine(1)<cr>', 'sn', "Get Line: move other line to this corner's line")

map('xo',  'in', '<cmd>call textobjs#inNumber()<cr>', 'sn', 'In Number: next number after cursor on current line')
map('xo',  'an', '<cmd>call textobjs#aroundNumber()<cr>', 'sn', 'Around Number: next number on line and possible surrounding white-space')

map('xo',  'ii', '<cmd>call textobjs#inIndentation()<cr>', 'sn', 'In Indentation: indentation level sans any surrounding empty lines')
map('xo',  'ai', '<cmd>call textobjs#aroundIndentation()<cr>', 'sn', 'Around Indentation: indentation level and any surrounding empty lines')

