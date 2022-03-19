-- Author: Nova Senco
-- Last Change: 19 March 2022

-- init {{{1

local M = require'map-utils'
local A = require'autocmd-utils'.build_autocmd('NovaMaps')

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local D -- description

-- main {{{1

D = 'minimize annoying mapleader accidents'
M.nmap(_, '<space>', '', D)

D = 'quietly update file'
M.nmap('sn', '<m-w>', ':silent update<cr>', D)
M.imap('sne', '<m-w>', "&modified ? '<esc>:sil up<cr>gi' : ''", D)

D = 'quietly update w/o autocmds'
M.nmap('sn', '<m-W>', ':silent noautocmd update<cr>', D)
M.imap('sne', '<m-W>', "&mod ? '<esc>:sil noa up<cr>gi' : ''", D)

M.nmap('sn', '<localleader>q', ':qa<cr>', 'quits unless unsaved changes')

M.nmap('sn', '<c-l>', "<cmd>nohlsearch|diffupdate|redraw!|echon ''<cr>",
    ':nohlsearch, :diffupdate, :redraw! all in one')

M.nmap('sn', '<leader><c-l>', ':syntax sync fromstart<cr>',
    'sync syntax from beginning of file')

M.nmap('ne', '<c-p>',
    "{last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'",
    'opens last command or search')
A('CmdlineEnter', function() vim.g._cmdtype_last_ = vim.v.event.cmdtype end)

M.xmap('n', '<c-p>', ":<c-u>'<,'><up>",
    "open last command operating on visual selection")

M.nmap('ne', 'zO', "foldclosed('.') is -1 ? 'zczO' : 'zO'",
    'same as zO but if fold already open, close first')

M.nmap('sne', '<leader>;',
    "(getline('.') =~# ';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'",
    'toggle ";" at end of line')

D = 'quick :Make / :Lmake'
M.nmap('sn', '<m-M>', '<cmd>sil Make<cr>', D)
M.nmap('sn', '<m-L>', '<cmd>sil Lmake<cr>', D)

M.nmap('sn', '<leader>p', '<cmd>call synstack#echo()<cr>',
    'print highlight groups')
M.xmap('ne', '<leader>p', 'maps#vExprPrint()',
    "print stats visual selection (similar to 'showcmd')")

M.omap('sn', 'w', '<cmd>call maps#o_word(0)<cr>', 'fix cw/dw inconsistency')
M.omap('sn', 'W', '<cmd>call maps#o_word(1)<cr>', 'fix cW/dW inconsistency')

-- Search: {{{1

M.nmap('sn', '*',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<cr>",
    "like * but respect capitalization; don't move cursor")
M.nmap('sn', '#',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<bar>call search('', 'bc')<cr>",
    "like # but respect capitalization; move cursor to beg of word")
M.nmap('sn', 'g*',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<cr>",
    "like g* without \\< and \\>")
M.nmap('sn', 'g#',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<bar>call search('', 'bc')<cr>",
    "like g# without \\< and \\>")

M.xmap(_, '*', '<esc>*gv', 'use * in visual mode')
M.xmap(_, '#', '<esc>#gv', 'use # in visual mode')
M.xmap(_, 'g*', '<esc>g*gv', 'use g* in visual mode')
M.xmap(_, 'g#', '<esc>g#gv', 'use g# in visual mode')

-- tldr: try c*Foo<esc>. (dot operator at end)
M.omap('sne', '*', 'maps#stargn(1)', "faster *N{op}gn")
M.omap('sne', '#', 'maps#stargn(1)', "faster #N{op}gn")
M.omap('sne', 'g*', 'maps#stargn(0)', "faster g*N{op}gn")
M.omap('sne', 'g#', 'maps#stargn(0)', "faster g#N{op}gn")

D = 'search for visual selection'
M.xmap('n', '<leader>*', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', D)
M.xmap('n', '<leader>#', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', D)

M.nmap('ne', 'n', "(v:searchforward ? 'n' : 'N')..'zv'", 'always search forwards')
M.nmap('ne', 'N', "(v:searchforward ? 'N' : 'n')..'zv'", 'always search backwards')

M.xmap('ne', 'n', "v:searchforward ? 'nzv' : 'Nzv'", 'always search forwards')
M.xmap('ne', 'N', "v:searchforward ? 'Nzv' : 'nzv'", 'always search backwards')

M.omap('ne', 'n', "v:searchforward ? 'n' : 'N'", 'always search forwards')  
M.omap('ne', 'N', "v:searchforward ? 'N' : 'n'", 'always search backwards') 

-- Quick: {{{1

-- buffers
M.nmap('sn', '[b', ":<c-u>execute v:count.'bprevious'<cr>")
M.nmap('sn', '[B', ":bfirst<cr>", ':bfirst')
M.nmap('sn', ']b', ":<c-u>execute v:count.'bnext'<cr>")
M.nmap('sn', ']B', ":blast<cr>")

-- arguments
M.nmap('sn', '[a', ":<c-u>execute v:count.'previous'<cr>")
M.nmap('sn', '[A', ":first<cr>")
M.nmap('sn', ']a', ":<c-u>execute v:count.'next'<cr>")
M.nmap('sn', ']A', ":last<cr>")

-- local list
M.nmap('sn', '<leader>ll', '<cmd>call maps#locToggle()<cr>')
M.nmap('sn', '<leader>lo', ':lopen<cr>')
M.nmap('sn', '<leader>lc', ':lclose<cr>')
M.nmap('sn', '[w', ":<c-u>execute v:count.'lprevious'<cr>")
M.nmap('sn', '[W', ':lfirst<cr>')
M.nmap('sn', ']w', ":<c-u>execute v:count.'lnext'<cr>")
M.nmap('sn', ']W', ":llast<cr>")

-- quickfix
M.nmap('sn', '<leader>qq', '<cmd>call maps#qfToggle()<cr>')
M.nmap('sn', '<leader>qo', ':belowright copen<cr>')
M.nmap('sn', '<leader>qc', ':cclose<cr>')
M.nmap('sn', '[q', ":<c-u>execute v:count.'cprevious'<cr>")
M.nmap('sn', '[Q', ':cfirst<cr>')
M.nmap('sn', ']q', ":<c-u>execute v:count.'cnext'<cr>")
M.nmap('sn', ']Q', ':clast<cr>')

-- moving lines; tldr: [e...u (repeatable but undo whole move operation)
M.nmap('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 0)<cr>', 'move line up')
M.xmap('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 1)<cr>', 'move selection up')
M.nmap('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 0)<cr>', 'move line down')
M.xmap('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 1)<cr>', 'move selection down')

M.nmap('sn', '[g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb')<cr>",
    'jump to next git marker')
M.nmap('sn', ']g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>",
    'jump to previous git marker')

M.nmap('sn', ']f', ':call maps#nextFile(1)<cr>', 'edit next file in directory')
M.nmap('sn', '[f', ':call maps#nextFile(0)<cr>', 'edit previous file in directory')

D = 'quick file and other stuff'
M.nmap('sn', '<leader>f', ':Files<cr>')                -- browse ./**
-- nmap('sn', '<leader>F',
--     [[<cmd>call fzf#run(fzf#wrap('Oldfiles', #{sink:'e', source:filter(v:oldfiles, 'v:val !~# "^\%(term\|fugitive\|man\)://"')}))<cr>]]) -- :browse oldfiles
M.nmap('sn', '<leader>F', '<cmd>History<cr>')
M.nmap('sn', '<localleader>f', '<cmd>Files %:p:h<cr>') -- browse %:p:h/**
M.nmap('n', '<localleader>F', ':Files %:p:h<c-z>')     -- browse %:p:h/**; wait
M.nmap('sn', '<leader>b', '<cmd>Buffers<cr>')          -- switch buffers
M.nmap('n', '<leader>sb', ':BLines<cr>')               -- find pattern in current buffer
M.nmap('n', '<leader>sB', ':Lines<cr>')                -- find pattern in buffers
M.nmap('n', '<leader>S', ':Rg ')                       -- find pattern in files
M.nmap('sn', '<leader>:', '<cmd>History :<cr>')
M.nmap('sn', '<leader>/', '<cmd>History /<cr>')

M.nmap('n', '<leader>cd', ':cd %:p:h<c-z>')            -- cd %:p:h; wait


-- -- improved ]c & [c (go to DiffText if in DiffChange)
-- M.nmap('sn', ']c', ':call maps#nextChange(1)<cr>')
-- M.nmap('sn', '[c', ':call maps#nextChange(0)<cr>')

-- init: {{{1

M.nmap('sn', '<localleader>c',
    "<cmd>call fzf#run(fzf#wrap('Files', #{source:'fd --type f --hidden --follow --exclude pack --exclude spell --exclude .gitignore --exclude .git', dir:stdpath('config'), options:fzf#vim#with_preview().options}))<cr>",
    'edit files in config')

if vim.fn.getenv('MYVIMRC'):match('%.lua$') then
  -- TODO: fix reload
  M.nmap('sn', '<localleader>C', ':luafile $MYVIMRC<cr>', 'reload init.lua')
else
  M.nmap('sn', '<localleader>C', ':source $MYVIMRC<cr>', 'reload vimrc')
  M.nmap('sn', '<localleader>V', ':let g:init_reload_opts = 1<bar>source $MYVIMRC<cr>', 'hard reload vimrc')
end


-- Url: {{{1

-- Spell: {{{1

-- Note: CTRL-S may conflict with "flow control" in some terminals

M.imap('n', '<c-s>', '<esc>[s1z=gi', 'quickly fix prev spell error in insert mode')

M.nmap('sn', '<c-s>h', '[s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', 'fix prev spell error (repeatable)')
M.nmap('sn', '<c-s>l', ']s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', 'fix next spell error (repeatable)')

D = 'spell gooding (repeatable)'
M.nmap('sn', '<c-s>gh', '[Szg``:sil! call repeat#set("\\<c-s>gh")<cr>', D)
M.nmap('sn', '<c-s>gl', ']Szg``:sil! call repeat#set("\\<c-s>gl")<cr>', D)
M.nmap('sn', '<c-s>Gh', '[SzG``:sil! call repeat#set("\\<c-s>Gh")<cr>', D)
M.nmap('sn', '<c-s>Gl', ']SzG``:sil! call repeat#set("\\<c-s>Gl")<cr>', D)

-- Abbrevs: {{{1

vim.cmd[[
" I never type these properly
abbrev unkown unknown

" quazi-fix missing "v" prefixed commands
cabbrev <expr> vsb getcmdline() =~# '^vsb' && getcmdpos() is 4 ? 'vert sb' : 'vsb'
cabbrev <expr> vh getcmdline() =~# '^vh' && getcmdpos() is 3 ? 'vert h' : 'vh'
cabbrev <expr> vsn getcmdline() =~# '^vsn' && getcmdpos() is 4 ? 'vert sn' : 'vsn'
cabbrev <expr> vspr getcmdline() =~# '^vspr' && getcmdpos() is 5 ? 'vert spr' : 'vspr'
cabbrev <expr> vsbn getcmdline() =~# '^vsbn' && getcmdpos() is 5 ? 'vert sbn' : 'vsbn'
cabbrev <expr> vsbp getcmdline() =~# '^vsbp' && getcmdpos() is 5 ? 'vert sbp' : 'vsbp'
]]

-- Cmdline: {{{1

M.cmap('n', '<m-b>', '<s-left>', 'better than <s-left>')
M.cmap('n', '<m-f>', '<s-right>', 'better than <s-right>')

D = 'Better than arrows'
M.cmap('n', '<m-h>', '<left>', D)
M.cmap('n', '<m-l>', '<right>', D)
M.cmap('n', '<m-k>', '<up>', D)
M.cmap('n', '<m-j>', '<down>', D)

M.cmap('n', '<m-a>', '<c-b>', 'duplicate <c-b>')
M.cmap('n', '<m-e>', '<c-e>', 'duplicate <c-e>')

-- open folds automatically when jumping to different matches
M.cmap('n', '<c-g>', "<c-g><c-r>=execute('sil! foldo!')[-1]<cr>")
M.cmap('n', '<c-t>', "<c-t><c-r>=execute('sil! foldo!')[-1]<cr>")

-- Iter: {{{1

M.nmap(_, '<leader>i', '<plug>(IterNext)')
M.nmap(_, '<leader>I', '<plug>(IterPrev)')
M.xmap(_, '<leader>i', '<plug>(IterNext)')
M.xmap(_, '<leader>I', '<plug>(IterPrev)')
M.nmap(_, '<localleader>i', '<plug>(IterReset)')
M.imap(_, '<c-r>[', '<plug>(IterPrev)')
M.imap(_, '<c-r>]', '<plug>(IterNext)')

-- Terminal: {{{1

-- make nvim terminal behave like vim terminal (mostly)
M.tmap('sn', '<c-w>k', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
M.tmap('sn', '<c-w><c-k>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
M.tmap('sn', '<c-w>j', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
M.tmap('sn', '<c-w><c-j>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
M.tmap('sn', '<c-w>h', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
M.tmap('sn', '<c-w><c-h>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
M.tmap('sn', '<c-w>l', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
M.tmap('sn', '<c-w><c-l>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
M.tmap('sn', '<c-w>p', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
M.tmap('sn', '<c-w><c-p>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
M.tmap('n', '<c-w>N', '<c-bslash><c-n>')
M.tmap('n', '<c-w>:', '<c-bslash><c-n>:let b:_term_ins_=1<cr>:')
M.tmap('sn', '<c-w>K', '<c-bslash><c-n><c-w>Ki')
M.tmap('sn', '<c-w>J', '<c-bslash><c-n><c-w>Ji')
M.tmap('sn', '<c-w>H', '<c-bslash><c-n><c-w>Hi')
M.tmap('sn', '<c-w>L', '<c-bslash><c-n><c-w>Li')
M.tmap('sn', '<c-w>v', '<c-bslash><c-n><c-w>vi')
M.tmap('sn', '<c-w><c-v>', '<c-bslash><c-n><c-w>vi')
M.tmap('sn', '<c-w>s', '<c-bslash><c-n><c-w>si')
M.tmap('sn', '<c-w><c-s>', '<c-bslash><c-n><c-w>si')
M.tmap('sn', '<c-w>c', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>c')
M.tmap('sn', '<c-w>w', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>w')
M.tmap('sn', '<c-w>=', '<c-bslash><c-n><c-w>=i')
-- can't easily do <c-w>4| or <c-w>4_ though

-- :term and :vterm open terminals in splits (:terminal still works normally)
vim.cmd [[ cabbrev <expr> term getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term'
           cabbrev <expr> vterm getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

M.tmap('ne', '<c-w><c-w>', 'feedkeys("\\<c-w>", "nt")[-1]', 'double <c-w> sends raw <c-w>')

A('TermOpen', 'if &buflisted')
  -- auto start insert when terminal opened
  A('TermOpen', 'startinsert')
  -- remove garbage from file name (and statusline)
  A('TermOpen', "execute 'file' substitute(@%, '^term://\\.//', '', '')")
  A('TermOpen', 'setl stl=%{@%}%=[terminal]')
A('TermOpen', 'endif')

