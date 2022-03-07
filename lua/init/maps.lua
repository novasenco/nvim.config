-- Author: Nova Senco
-- Last Change: 07 March 2022

-- init{{{1

local m = require'mapping'
local nmap = m.nmap
local imap = m.imap
local xmap = m.xmap
local cmap = m.cmap
local omap = m.omap
local tmap = m.tmap

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local augroup = 'NovaMaps'
vim.api.nvim_create_augroup(augroup, { clear=true })
local A = function(evt, cmd, pat)
  vim.api.nvim_create_autocmd(evt, {group=augroup, command=cmd, pattern=pat})
end

-- main {{{1

local D

D='minimize annoying mapleader accidents'
m.nmap(_, '<space>', '', D)

D='quietly update file'
m.nmap('sn', '<m-w>', ':silent update<cr>', D)
m.imap('sne', '<m-w>', "&modified ? '<esc>:sil up<cr>gi' : ''", D)

D='quietly update w/o autocmds'
m.nmap('sn', '<m-W>', ':silent noautocmd update<cr>', D)
m.imap('sne', '<m-W>', "&mod ? '<esc>:sil noa up<cr>gi' : ''", D)

m.nmap('sn', '<localleader>q', ':qa<cr>', 'quits unless unsaved changes')

m.nmap('sn', '<c-l>', "<cmd>nohlsearch|diffupdate|redraw!|echon ''<cr>",
    ':nohlsearch, :diffupdate, :redraw! all in one')

m.nmap('sn', '<leader><c-l>', ':syntax sync fromstart<cr>',
    'sync syntax from beginning of file')

m.nmap('ne', '<c-p>',
    "{last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'",
    'opens last command or search')
A('CmdlineEnter',   'let g:_cmdtype_last_ = v:event.cmdtype')

m.xmap('n', '<c-p>', ":<c-u>'<,'><up>",
    "open last command operating on visual selection")

m.nmap('ne', 'zO', "foldclosed('.') is -1 ? 'zczO' : 'zO'",
    'same as zO but if fold already open, close first')

m.nmap('sne', '<leader>;',
    "(getline('.') =~# ';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'",
    'toggle ";" at end of line')

D='quick :Make / :Lmake'
m.nmap('sn', '<m-M>', '<cmd>sil Make<cr>', D)
m.nmap('sn', '<m-L>', '<cmd>sil Lmake<cr>', D)

m.nmap('sn', '<leader>p', '<cmd>call synstack#echo()<cr>',
    'print highlight groups')
m.xmap('ne', '<leader>p', 'maps#vExprPrint()',
    "print stats visual selection (similar to 'showcmd')")

m.omap('sn', 'w', '<cmd>call maps#o_word(0)<cr>', 'fix cw/dw inconsistency')
m.omap('sn', 'W', '<cmd>call maps#o_word(1)<cr>', 'fix cW/dW inconsistency')

-- Search: {{{1

m.nmap('sn', '*',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<cr>",
    "like * but respect capitalization; don't move cursor")
m.nmap('sn', '#',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<bar>call search('', 'bc')<cr>",
    "like # but respect capitalization; move cursor to beg of word")
m.nmap('sn', 'g*',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<cr>",
    "like g* without \\< and \\>")
m.nmap('sn', 'g#',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<bar>call search('', 'bc')<cr>",
    "like g# without \\< and \\>")

m.xmap(_, '*', '<esc>*gv', 'use * in visual mode',
    "* and reselect; doesn't move cursor")
m.xmap(_, '#', '<esc>#gv', 'use # in visual mode',
    "# and reselect; doesn't move cursor")
m.xmap(_, 'g*', '<esc>g*gv', 'use g* in visual mode',
    "g* and reselect; doesn't move cursor")
m.xmap(_, 'g#', '<esc>g#gv', 'use g# in visual mode',
    "g# and reselect; doesn't move cursor")

-- tldr: try c*Foo<esc>. (dot operator at end)
m.omap('sne', '*', 'maps#stargn(1)', "faster *N{op}gn")
m.omap('sne', '#', 'maps#stargn(1)', "faster #N{op}gn")
m.omap('sne', 'g*', 'maps#stargn(0)', "faster g*N{op}gn")
m.omap('sne', 'g#', 'maps#stargn(0)', "faster g#N{op}gn")

D='search for visual selection'
m.xmap('n', '<leader>*', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', D)
m.xmap('n', '<leader>#', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', D)

m.nmap('ne', 'n', "(v:searchforward ? 'n' : 'N')..'zv'", 'always search forwards')
m.nmap('ne', 'N', "(v:searchforward ? 'N' : 'n')..'zv'", 'always search backwards')

m.xmap('ne', 'n', "v:searchforward ? 'nzv' : 'Nzv'", 'always search forwards')
m.xmap('ne', 'N', "v:searchforward ? 'Nzv' : 'nzv'", 'always search backwards')

m.omap('ne', 'n', "v:searchforward ? 'n' : 'N'", 'always search forwards')  
m.omap('ne', 'N', "v:searchforward ? 'N' : 'n'", 'always search backwards') 

-- Quick: {{{1

-- buffers
m.nmap('sn', '[b', ":<c-u>execute v:count.'bprevious'<cr>")
m.nmap('sn', '[B', ":bfirst<cr>", ':bfirst')
m.nmap('sn', ']b', ":<c-u>execute v:count.'bnext'<cr>")
m.nmap('sn', ']B', ":blast<cr>")

-- arguments
m.nmap('sn', '[a', ":<c-u>execute v:count.'previous'<cr>")
m.nmap('sn', '[A', ":first<cr>")
m.nmap('sn', ']a', ":<c-u>execute v:count.'next'<cr>")
m.nmap('sn', ']A', ":last<cr>")

-- local list
m.nmap('sn', '<leader>ll', '<cmd>call maps#locToggle()<cr>')
m.nmap('sn', '<leader>lo', ':lopen<cr>')
m.nmap('sn', '<leader>lc', ':lclose<cr>')
m.nmap('sn', '[w', ":<c-u>execute v:count.'lprevious'<cr>")
m.nmap('sn', '[W', ':lfirst<cr>')
m.nmap('sn', ']w', ":<c-u>execute v:count.'lnext'<cr>")
m.nmap('sn', ']W', ":llast<cr>")

-- quickfix
m.nmap('sn', '<leader>qq', '<cmd>call maps#qfToggle()<cr>')
m.nmap('sn', '<leader>qo', ':belowright copen<cr>')
m.nmap('sn', '<leader>qc', ':cclose<cr>')
m.nmap('sn', '[q', ":<c-u>execute v:count.'cprevious'<cr>")
m.nmap('sn', '[Q', ':cfirst<cr>')
m.nmap('sn', ']q', ":<c-u>execute v:count.'cnext'<cr>")
m.nmap('sn', ']Q', ':clast<cr>')

-- moving lines; tldr: [e...u (repeatable but undo whole move operation)
m.nmap('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 0)<cr>', 'move line up')
m.xmap('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 1)<cr>', 'move selection up')
m.nmap('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 0)<cr>', 'move line down')
m.xmap('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 1)<cr>', 'move selection down')

m.nmap('sn', '[g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb')<cr>",
    'jump to next git marker')
m.nmap('sn', ']g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>",
    'jump to previous git marker')

m.nmap('sn', ']f', ':call maps#nextFile(1)<cr>', 'edit next file in directory')
m.nmap('sn', '[f', ':call maps#nextFile(0)<cr>', 'edit previous file in directory')

D='quick file and other stuff'
m.nmap('sn', '<leader>f', ':Files<cr>')                -- browse ./**
-- nmap('sn', '<leader>F',
--     [[<cmd>call fzf#run(fzf#wrap('Oldfiles', #{sink:'e', source:filter(v:oldfiles, 'v:val !~# "^\%(term\|fugitive\|man\)://"')}))<cr>]]) -- :browse oldfiles
m.nmap('sn', '<leader>F', '<cmd>History<cr>')
m.nmap('sn', '<localleader>f', '<cmd>Files %:p:h<cr>') -- browse %:p:h/**
m.nmap('n', '<localleader>F', ':Files %:p:h<c-z>')     -- browse %:p:h/**; wait
m.nmap('sn', '<leader>b', '<cmd>Buffers<cr>')          -- switch buffers
m.nmap('n', '<leader>sb', ':BLines<cr>')               -- find pattern in current buffer
m.nmap('n', '<leader>sB', ':Lines<cr>')                -- find pattern in buffers
m.nmap('n', '<leader>S', ':Rg ')                       -- find pattern in files
m.nmap('n', '<leader>cd', ':cd %:p:h<c-z>')            -- cd %:p:h; wait

m.nmap('sn', '<leader>:', '<cmd>History :<cr>')
m.nmap('sn', '<leader>/', '<cmd>History /<cr>')

-- netrw sucks
m.nmap('sn', 'gx', "<cmd>execute 'silent !xdg-open' fnameescape(expand('<cfile>'))<cr>")

-- improved ]c & [c (go to DiffText if in DiffChange)
m.nmap('sn', ']c', ':call maps#nextChange(1)<cr>')
m.nmap('sn', '[c', ':call maps#nextChange(0)<cr>')

-- init: {{{1

m.nmap('sn', '<localleader>c',
    "<cmd>call fzf#run(fzf#wrap('Files', #{source:'fd --type f --hidden --follow --exclude pack --exclude spell --exclude .gitignore', dir:stdpath('config'), options:fzf#vim#with_preview().options}))<cr>",
    'edit files in config')

if vim.fn.getenv('MYVIMRC'):match('%.lua$') then
  m.nmap('sn', '<localleader>C', ':luafile $MYVIMRC<cr>', 'reload init.lua')
else
  m.nmap('sn', '<localleader>C', ':source $MYVIMRC<cr>', 'reload vimrc')
  m.nmap('sn', '<localleader>V', ':let g:init_reload_opts = 1<bar>source $MYVIMRC<cr>', 'hard reload vimrc')
end


-- Spell: {{{1

-- Note: CTRL-S may conflict with "flow control" in some terminals

m.imap('n', '<c-s>', '<esc>[s1z=gi', 'quickly fix prev spell error in insert mode')

m.nmap('sn', '<c-s>h', '[s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', 'fix prev spell error (repeatable)')
m.nmap('sn', '<c-s>l', ']s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', 'fix next spell error (repeatable)')

D='spell gooding (repeatable)'
m.nmap('sn', '<c-s>gh', '[Szg``:sil! call repeat#set("\\<c-s>gh")<cr>', D)
m.nmap('sn', '<c-s>gl', ']Szg``:sil! call repeat#set("\\<c-s>gl")<cr>', D)
m.nmap('sn', '<c-s>Gh', '[SzG``:sil! call repeat#set("\\<c-s>Gh")<cr>', D)
m.nmap('sn', '<c-s>Gl', ']SzG``:sil! call repeat#set("\\<c-s>Gl")<cr>', D)

-- Abbrevs: {{{1

vim.cmd[[
" I never type these properly
abbrev unkown unknown

" quazi-fix missing "v" prefixed commands
cabbrev <expr> vsb getcmdline() =~# '^vsb' && getcmdpos() is 4 ? 'vert sb' : 'vsb'
cabbrev <expr> vh getcmdline() =~# '^vh' && getcmdpos() is 3 ? 'vert h' : 'vh'
cabbrev <expr> vsn getcmdline() =~# '^vsn' && getcmdpos() is 4 ? 'vert sn' : 'vsn'
cabbrev <expr> vsbn getcmdline() =~# '^vsbn' && getcmdpos() is 5 ? 'vert sbn' : 'vsbn'
cabbrev <expr> vsbp getcmdline() =~# '^vsbp' && getcmdpos() is 5 ? 'vert sbp' : 'vsbp'
]]

-- Cmdline: {{{1

m.cmap('n', '<m-b>', '<s-left>', 'better than <s-left>')
m.cmap('n', '<m-f>', '<s-right>', 'better than <s-right>')

D='Better than arrows'
m.cmap('n', '<m-h>', '<left>', D)
m.cmap('n', '<m-l>', '<right>', D)
m.cmap('n', '<m-k>', '<up>', D)
m.cmap('n', '<m-j>', '<down>', D)

m.cmap('n', '<m-a>', '<c-b>', 'duplicate <c-b>')
m.cmap('n', '<m-e>', '<c-e>', 'duplicate <c-e>')

-- open folds automatically when jumping to different matches
m.cmap('n', '<c-g>', "<c-g><c-r>=execute('sil! foldo!')[-1]<cr>")
m.cmap('n', '<c-t>', "<c-t><c-r>=execute('sil! foldo!')[-1]<cr>")

-- Iter: {{{1

m.nmap(_, '<leader>i', '<plug>(IterNext)')
m.nmap(_, '<leader>I', '<plug>(IterPrev)')
m.xmap(_, '<leader>i', '<plug>(IterNext)')
m.xmap(_, '<leader>I', '<plug>(IterPrev)')
m.nmap(_, '<localleader>i', '<plug>(IterReset)')
m.imap(_, '<c-r>[', '<plug>(IterPrev)')
m.imap(_, '<c-r>]', '<plug>(IterNext)')

-- Terminal: {{{1

-- make nvim terminal behave like vim terminal (mostly)
m.tmap('sn', '<c-w>k', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
m.tmap('sn', '<c-w><c-k>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
m.tmap('sn', '<c-w>j', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
m.tmap('sn', '<c-w><c-j>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
m.tmap('sn', '<c-w>h', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
m.tmap('sn', '<c-w><c-h>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
m.tmap('sn', '<c-w>l', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
m.tmap('sn', '<c-w><c-l>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
m.tmap('sn', '<c-w>p', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
m.tmap('sn', '<c-w><c-p>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
m.tmap('n', '<c-w>N', '<c-bslash><c-n>')
m.tmap('n', '<c-w>:', '<c-bslash><c-n>:let b:_term_ins_=1<cr>:')
m.tmap('sn', '<c-w>K', '<c-bslash><c-n><c-w>Ki')
m.tmap('sn', '<c-w>J', '<c-bslash><c-n><c-w>Ji')
m.tmap('sn', '<c-w>H', '<c-bslash><c-n><c-w>Hi')
m.tmap('sn', '<c-w>L', '<c-bslash><c-n><c-w>Li')
m.tmap('sn', '<c-w>v', '<c-bslash><c-n><c-w>vi')
m.tmap('sn', '<c-w><c-v>', '<c-bslash><c-n><c-w>vi')
m.tmap('sn', '<c-w>s', '<c-bslash><c-n><c-w>si')
m.tmap('sn', '<c-w><c-s>', '<c-bslash><c-n><c-w>si')
m.tmap('sn', '<c-w>c', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>c')
m.tmap('sn', '<c-w>w', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>w')
m.tmap('sn', '<c-w>=', '<c-bslash><c-n><c-w>=i')
-- can't easily do <c-w>4| or <c-w>4_ though

-- :term and :vterm open terminals in splits (:terminal still works normally)
vim.cmd [[ cabbrev <expr> term getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term'
           cabbrev <expr> vterm getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

m.tmap('ne', '<c-w><c-w>', 'feedkeys("\\<c-w>", "nt")[-1]', 'double <c-w> sends raw <c-w>')

A('TermOpen', 'if &buflisted')
  -- auto start insert when terminal opened
  A('TermOpen', 'startinsert')
  -- remove garbage from file name (and statusline)
  A('TermOpen', "execute 'file' substitute(@%, '^term://\\.//', '', '')")
  A('TermOpen', 'setl stl=%{@%}%=[terminal]')
A('TermOpen', 'endif')

