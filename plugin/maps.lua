-- Author: Nova Senco
-- Last Change: 01 June 2022

-- setup {{{1

local map = require'utils.map'
local au = require'utils.autocmd'.build('NovaMaps')

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local desc -- description

-- main {{{1

desc = 'minimize annoying mapleader accidents'
map.n(_, '<space>', '', desc)

desc = 'quietly update file'
map.n('sn', '<m-w>', ':silent update<cr>', desc)
map.i('sne', '<m-w>', "&modified ? '<esc>:sil up<cr>gi' : ''", desc)

desc = 'quietly update w/o autocmds'
map.n('sn', '<m-W>', ':silent noautocmd update<cr>', desc)
map.i('sne', '<m-W>', "&mod ? '<esc>:sil noa up<cr>gi' : ''", desc)

map.n('sn', '<localleader>q', ':qa<cr>', 'quits unless unsaved changes')

map.n('sn', '<c-l>', "<cmd>nohlsearch|diffupdate|redraw!|echon ''<cr>",
    ':nohlsearch, :diffupdate, :redraw! all in one')

map.n('sn', '<leader><c-l>', ':syntax sync fromstart<cr>',
    'sync syntax from beginning of file')

map.n('ne', '<c-p>',
    "{last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'",
    'opens last command or search')
au('CmdlineEnter', function() vim.g._cmdtype_last_ = vim.v.event.cmdtype end)

map.x('n', '<c-p>', ":<c-u>'<,'><up>",
    "open last command operating on visual selection")

map.n('ne', 'zO', "foldclosed('.') is -1 ? 'zczO' : 'zO'",
    'same as zO but if fold already open, close first')

map.n('sne', '<leader>;',
    "(getline('.') =~# ';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'",
    'toggle ";" at end of line')

desc = 'quick :Make / :Lmake'
map.n('sn', '<m-map>', '<cmd>sil Make<cr>', desc)
map.n('sn', '<m-L>', '<cmd>sil Lmake<cr>', desc)

map.n('sn', '<leader>p', '<cmd>call synstack#echo()<cr>',
    'print highlight groups')
map.x('ne', '<leader>p', 'maps#vExprPrint()',
    "print stats visual selection (similar to 'showcmd')")

map.o('sn', 'w', '<cmd>call maps#o_word(0)<cr>', 'fix cw/dw inconsistency')
map.o('sn', 'W', '<cmd>call maps#o_word(1)<cr>', 'fix cW/dW inconsistency')

-- search {{{1

map.n('sn', '*',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<cr>",
    "like * but respect capitalization; don't move cursor")
map.n('sn', '#',
    "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<bar>call search('', 'bc')<cr>",
    "like # but respect capitalization; move cursor to beg of word")
map.n('sn', 'g*',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<cr>",
    "like g* without \\< and \\>")
map.n('sn', 'g#',
    "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<bar>call search('', 'bc')<cr>",
    "like g# without \\< and \\>")

map.x(_, '*', '<esc>*gv', 'use * in visual mode')
map.x(_, '#', '<esc>#gv', 'use # in visual mode')
map.x(_, 'g*', '<esc>g*gv', 'use g* in visual mode')
map.x(_, 'g#', '<esc>g#gv', 'use g# in visual mode')

-- tldr: try c*Foo<esc>. (dot operator at end)
map.o('sne', '*', 'maps#stargn(1)', "faster *N{op}gn")
map.o('sne', '#', 'maps#stargn(1)', "faster #N{op}gn")
map.o('sne', 'g*', 'maps#stargn(0)', "faster g*N{op}gn")
map.o('sne', 'g#', 'maps#stargn(0)', "faster g#N{op}gn")

desc = 'search for visual selection'
map.x('n', '<leader>*', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', desc)
map.x('n', '<leader>#', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', desc)

map.n('ne', 'n', "(v:searchforward ? 'n' : 'N')..'zv'", 'always search forwards')
map.n('ne', 'N', "(v:searchforward ? 'N' : 'n')..'zv'", 'always search backwards')

map.x('ne', 'n', "v:searchforward ? 'nzv' : 'Nzv'", 'always search forwards')
map.x('ne', 'N', "v:searchforward ? 'Nzv' : 'nzv'", 'always search backwards')

map.o('ne', 'n', "v:searchforward ? 'n' : 'N'", 'always search forwards')
map.o('ne', 'N', "v:searchforward ? 'N' : 'n'", 'always search backwards')

-- quick {{{1

-- buffers
map.n('sn', '[b', ":<c-u>execute v:count.'bprevious'<cr>")
map.n('sn', '[B', ":bfirst<cr>", ':bfirst')
map.n('sn', ']b', ":<c-u>execute v:count.'bnext'<cr>")
map.n('sn', ']B', ":blast<cr>")

-- arguments
map.n('sn', '[a', ":<c-u>execute v:count.'previous'<cr>")
map.n('sn', '[A', ":first<cr>")
map.n('sn', ']a', ":<c-u>execute v:count.'next'<cr>")
map.n('sn', ']A', ":last<cr>")

-- local list
map.n('sn', '<leader>ll', '<cmd>call maps#locToggle()<cr>')
map.n('sn', '<leader>lo', ':lopen<cr>')
map.n('sn', '<leader>lc', ':lclose<cr>')
map.n('sn', '[w', ":<c-u>execute v:count.'lprevious'<cr>")
map.n('sn', '[W', ':lfirst<cr>')
map.n('sn', ']w', ":<c-u>execute v:count.'lnext'<cr>")
map.n('sn', ']W', ":llast<cr>")

-- quickfix
map.n('sn', '<leader>qq', '<cmd>call maps#qfToggle()<cr>')
map.n('sn', '<leader>qo', ':belowright copen<cr>')
map.n('sn', '<leader>qc', ':cclose<cr>')
map.n('sn', '[q', ":<c-u>execute v:count.'cprevious'<cr>")
map.n('sn', '[Q', ':cfirst<cr>')
map.n('sn', ']q', ":<c-u>execute v:count.'cnext'<cr>")
map.n('sn', ']Q', ':clast<cr>')

-- moving lines; tldr: [e...u (repeatable but undo whole move operation)
map.n('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 0)<cr>', 'move line up')
map.x('sn', '[e', ':<c-u>call maps#moveLine(0, v:count, 1)<cr>', 'move selection up')
map.n('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 0)<cr>', 'move line down')
map.x('sn', ']e', ':<c-u>call maps#moveLine(1, v:count, 1)<cr>', 'move selection down')

map.n('sn', '[g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb')<cr>",
    'jump to next git marker')
map.n('sn', ']g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>",
    'jump to previous git marker')

map.n('sn', ']f', ':call maps#nextFile(1)<cr>', 'edit next file in directory')
map.n('sn', '[f', ':call maps#nextFile(0)<cr>', 'edit previous file in directory')

desc = 'quick file and other stuff'
map.n('sn', '<leader>f', ':Files<cr>')                -- browse ./**
-- nmap('sn', '<leader>F',
--     [[<cmd>call fzf#run(fzf#wrap('Oldfiles', #{sink:'e', source:filter(v:oldfiles, 'v:val !~# "^\%(term\|fugitive\|man\)://"')}))<cr>]]) -- :browse oldfiles
map.n('sn', '<leader>F', '<cmd>History<cr>')
map.n('sn', '<localleader>f', '<cmd>Files %:p:h<cr>') -- browse %:p:h/**
map.n('n', '<localleader>F', ':Files %:p:h<c-z>')     -- browse %:p:h/**; wait
-- map.n('sn', '<leader>b', '<cmd>Buffers<cr>')          -- switch buffers
-- map.n('n', '<leader>sb', ':BLines<cr>')               -- find pattern in current buffer
-- map.n('n', '<leader>sB', ':Lines<cr>')                -- find pattern in buffers
-- map.n('n', '<leader>S', ':Rg ')                       -- find pattern in files
-- map.n('sn', '<leader>:', '<cmd>History :<cr>')
-- map.n('sn', '<leader>/', '<cmd>History /<cr>')

map.n('n', '<leader>cd', ':cd %:p:h<c-z>')            -- cd %:p:h; wait

map.n('n', '<leader>g', ':Git ')

-- -- improved ]c & [c (go to DiffText if in DiffChange)
-- map.nmap('sn', ']c', ':call maps#nextChange(1)<cr>')
-- map.nmap('sn', '[c', ':call maps#nextChange(0)<cr>')

-- init {{{1

map.n('sn', '<localleader>c',
    "<cmd>call fzf#run(fzf#wrap('Files', #{source:'fd --type f --hidden --follow --exclude pack --exclude spell --exclude .gitignore --exclude .git', dir:stdpath('config'), options:fzf#vim#with_preview().options}))<cr>",
    'edit files in config')

if vim.fn.getenv('MYVIMRC'):match('%.lua$') then
  map.n('sn', '<localleader>C', "<cmd>for f in glob(stdpath('config')..'/plugin/**/*.lua', 0, 1) | execute 'luafile' f | endfor<cr>", 'reload init.lua')
else
  map.n('sn', '<localleader>C', ':source $MYVIMRC<cr>', 'reload vimrc')
  map.n('sn', '<localleader>V', ':let g:init_reload_opts = 1<bar>source $MYVIMRC<cr>', 'hard reload vimrc')
end


-- url {{{1

-- spell {{{1

-- Note: CTRL-S may conflict with "flow control" in some terminals

map.i('n', '<c-s>', '<esc>[s1z=gi', 'quickly fix prev spell error in insert mode')

map.n('sn', '<c-s>h', '[s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', 'fix prev spell error (repeatable)')
map.n('sn', '<c-s>l', ']s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', 'fix next spell error (repeatable)')

desc = 'spell gooding (repeatable)'
map.n('sn', '<c-s>gh', '[Szg``:sil! call repeat#set("\\<c-s>gh")<cr>', desc)
map.n('sn', '<c-s>gl', ']Szg``:sil! call repeat#set("\\<c-s>gl")<cr>', desc)
map.n('sn', '<c-s>Gh', '[SzG``:sil! call repeat#set("\\<c-s>Gh")<cr>', desc)
map.n('sn', '<c-s>Gl', ']SzG``:sil! call repeat#set("\\<c-s>Gl")<cr>', desc)

-- abbrevs {{{1

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

-- cmdline {{{1

map.c('n', '<m-b>', '<s-left>', 'better than <s-left>')
map.c('n', '<m-f>', '<s-right>', 'better than <s-right>')

desc = 'Better than '
map.c('n', '<m-h>', '<left>', desc..'left')
map.c('n', '<m-l>', '<right>', desc..'right')
map.c('n', '<m-k>', '<up>', desc..'up')
map.c('n', '<m-j>', '<down>', desc..'down')

map.c('n', '<m-a>', '<c-b>', 'mirror <c-b>')
map.c('n', '<m-e>', '<c-e>', 'mirror <c-e>')

-- open folds automatically when jumping to different matches
desc = 'open folds automatically with '
map.c('n', '<c-g>', "<c-g><c-r>=execute('sil! foldo!')[-1]<cr>")
map.c('n', '<c-t>', "<c-t><c-r>=execute('sil! foldo!')[-1]<cr>")

-- snap {{{1

-- insert placeholder
map.i('', '<m-;>', '<plug>(snapSimple)')
-- insert reminder
map.i('', '<m-:>', '<plug>(snapText)')

-- snap to next placeholder
map.i('', '<m-l>', '<plug>(snapNext)')
map.n('', '<m-l>', '<plug>(snapNext)')
map.x('', '<m-l>', '<plug>(snapNext)')
map.s('', '<m-l>', '<plug>(snapNext)')
map.o('', '<m-l>', '<plug>(snapNext)')

-- repeat last snap on next placeholder
map.i('', '<m-L>', '<plug>(snapRepeatNext)')
map.n('', '<m-L>', '<plug>(snapRepeatNext)')
map.x('', '<m-L>', '<plug>(snapRepeatNext)')
map.s('', '<m-L>', '<plug>(snapRepeatNext)')

-- snap to previous placeholder
map.i('', '<m-h>', '<plug>(snapPrev)')
map.n('', '<m-h>', '<plug>(snapPrev)')
map.x('', '<m-h>', '<plug>(snapPrev)')
map.s('', '<m-h>', '<plug>(snapPrev)')
map.o('', '<m-h>', '<plug>(snapPrev)')

-- repeat last snap on previous placeholder
map.i('', '<m-H>', '<plug>(snapRepeatPrev)')
map.n('', '<m-H>', '<plug>(snapRepeatPrev)')
map.x('', '<m-H>', '<plug>(snapRepeatPrev)')
map.s('', '<m-H>', '<plug>(snapRepeatPrev)')

-- luasnips {{{1

map.n('s', '<m-o>', "<cmd>lua require'luasnip'.jump(1)<cr>")
map.n('s', '<m-i>', "<cmd>lua require'luasnip'.jump(-1)<cr>")

map.i('s', '<m-o>', '<plug>luasnip-expand-or-jump')
map.i('s', '<m-i>', "<cmd>lua require'luasnip'.jump(-1)<cr>")

map.s('s', '<m-o>', "<cmd>lua require'luasnip'.jump(1)<cr>")
map.s('s', '<m-i>', "<cmd>lua require'luasnip'.jump(-1)<cr>")

map.i('se', '<m-[>', "luasnip#choice_active() ? '<plug>luasnip-next-choice' : ''")
map.s('se', '<m-[>', "luasnip#choice_active() ? '<plug>luasnip-next-choice' : ''")

-- iter {{{1

map.n(_, '<leader>i', '<plug>(IterNext)')
map.n(_, '<leader>I', '<plug>(IterPrev)')
map.x(_, '<leader>i', '<plug>(IterNext)')
map.x(_, '<leader>I', '<plug>(IterPrev)')
map.n(_, '<localleader>i', '<plug>(IterReset)')
map.i(_, '<c-r>[', '<plug>(IterPrev)')
map.i(_, '<c-r>]', '<plug>(IterNext)')

-- terminal {{{1

-- make nvim terminal behave like vim terminal (mostly)
map.t('sn', '<c-w>k', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
map.t('sn', '<c-w><c-k>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k')
map.t('sn', '<c-w>j', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
map.t('sn', '<c-w><c-j>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j')
map.t('sn', '<c-w>h', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
map.t('sn', '<c-w><c-h>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h')
map.t('sn', '<c-w>l', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
map.t('sn', '<c-w><c-l>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l')
map.t('sn', '<c-w>p', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
map.t('sn', '<c-w><c-p>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p')
map.t('n', '<c-w>N', '<c-bslash><c-n>')
map.t('n', '<c-w>:', '<c-bslash><c-n>:let b:_term_ins_=1<cr>:')
map.t('sn', '<c-w>K', '<c-bslash><c-n><c-w>Ki')
map.t('sn', '<c-w>J', '<c-bslash><c-n><c-w>Ji')
map.t('sn', '<c-w>H', '<c-bslash><c-n><c-w>Hi')
map.t('sn', '<c-w>L', '<c-bslash><c-n><c-w>Li')
map.t('sn', '<c-w>v', '<c-bslash><c-n><c-w>vi')
map.t('sn', '<c-w><c-v>', '<c-bslash><c-n><c-w>vi')
map.t('sn', '<c-w>s', '<c-bslash><c-n><c-w>si')
map.t('sn', '<c-w><c-s>', '<c-bslash><c-n><c-w>si')
map.t('sn', '<c-w>c', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>c')
map.t('sn', '<c-w>w', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>w')
map.t('sn', '<c-w>=', '<c-bslash><c-n><c-w>=i')
-- can't easily do <c-w>4| or <c-w>4_ though

-- :term and :vterm open terminals in splits (:terminal still works normally)
vim.cmd [[ cabbrev <expr> term getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term'
           cabbrev <expr> vterm getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

map.t('ne', '<c-w><c-w>', 'feedkeys("\\<c-w>", "nt")[-1]', 'double <c-w> sends raw <c-w>')

au('TermOpen', 'if &buflisted')
  -- auto start insert when terminal opened
  au('TermOpen', 'startinsert')
  -- remove garbage from file name (and statusline)
  au('TermOpen', "execute 'file' substitute(@%, '^term://.\\{-}:', '', '')")
  au('TermOpen', 'setl stl=%{@%}%=[terminal]')
au('TermOpen', 'endif')

