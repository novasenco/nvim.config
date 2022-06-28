
local map = require'utils.map'.set
local au = require'utils.autocmd'.build('NovaTerm')

-- make nvim terminal behave like vim terminal (mostly)
map('t',  '<c-w>k', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k', 'sn')
map('t',  '<c-w><c-k>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>k', 'sn')
map('t',  '<c-w>j', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j', 'sn')
map('t',  '<c-w><c-j>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>j', 'sn')
map('t',  '<c-w>h', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h', 'sn')
map('t',  '<c-w><c-h>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>h', 'sn')
map('t',  '<c-w>l', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l', 'sn')
map('t',  '<c-w><c-l>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>l', 'sn')
map('t',  '<c-w>p', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p', 'sn')
map('t',  '<c-w><c-p>', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>p', 'sn')
map('t',  '<c-w>N', '<c-bslash><c-n>', 'n')
map('t',  '<c-w>:', '<c-bslash><c-n>:let b:_term_ins_=1<cr>:', 'n')
map('t',  '<c-w>K', '<c-bslash><c-n><c-w>Ki', 'sn')
map('t',  '<c-w>J', '<c-bslash><c-n><c-w>Ji', 'sn')
map('t',  '<c-w>H', '<c-bslash><c-n><c-w>Hi', 'sn')
map('t',  '<c-w>L', '<c-bslash><c-n><c-w>Li', 'sn')
map('t',  '<c-w>T', '<c-bslash><c-n><c-w>Ti', 'sn')
map('t',  '<c-w>v', '<c-bslash><c-n><c-w>vi', 'sn')
map('t',  '<c-w><c-v>', '<c-bslash><c-n><c-w>vi', 'sn')
map('t',  '<c-w>s', '<c-bslash><c-n><c-w>si', 'sn')
map('t',  '<c-w><c-s>', '<c-bslash><c-n><c-w>si', 'sn')
map('t',  '<c-w>c', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>c', 'sn')
map('t',  '<c-w>w', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>w', 'sn')
map('t',  '<c-w>=', '<c-bslash><c-n><c-w>=i', 'sn')
-- can't easily do <c-w>4| or <c-w>4_ though

-- :term and :vterm open terminals in splits (:terminal still works normally)
vim.cmd[[ cabbrev <expr> term getcmdtype() is ':' && getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term' ]]
vim.cmd[[ cabbrev <expr> vterm getcmdtype() is ':' && getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

map('t',  '<c-w><c-w>', 'feedkeys("\\<c-w>", "nt")[-1]', 'ne', 'double <c-w> sends raw <c-w>')

au('TermOpen', 'if &buflisted')

  -- auto start insert when terminal opened
  au('TermOpen', 'startinsert')

  -- remove garbage from file name (and statusline)
  au('TermOpen', "execute 'file' substitute(@%, '^term://.\\{-}:', '', '')")
  au('TermOpen', 'setl stl=%{@%}%=[terminal]')

au('TermOpen', 'endif')

-- -- auto close response when terminal closed
-- au('TermClose', [[call feedkeys("\<esc>", 'nt')]])
