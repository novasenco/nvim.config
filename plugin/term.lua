
local map = require'utils.map'
local au = require'utils.autocmd'.build('NovaMaps')

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
map.t('sn', '<c-w>T', '<c-bslash><c-n><c-w>Ti')
map.t('sn', '<c-w>v', '<c-bslash><c-n><c-w>vi')
map.t('sn', '<c-w><c-v>', '<c-bslash><c-n><c-w>vi')
map.t('sn', '<c-w>s', '<c-bslash><c-n><c-w>si')
map.t('sn', '<c-w><c-s>', '<c-bslash><c-n><c-w>si')
map.t('sn', '<c-w>c', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>c')
map.t('sn', '<c-w>w', '<c-bslash><c-n>:let b:_term_ins_=1<cr><c-w>w')
map.t('sn', '<c-w>=', '<c-bslash><c-n><c-w>=i')
-- can't easily do <c-w>4| or <c-w>4_ though

-- :term and :vterm open terminals in splits (:terminal still works normally)
vim.cmd[[ cabbrev <expr> term getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term' ]]
vim.cmd[[ cabbrev <expr> vterm getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

map.t('ne', '<c-w><c-w>', 'feedkeys("\\<c-w>", "nt")[-1]', 'double <c-w> sends raw <c-w>')

au('TermOpen', 'if &buflisted')

  -- auto start insert when terminal opened
  au('TermOpen', 'startinsert')

  -- remove garbage from file name (and statusline)
  au('TermOpen', "execute 'file' substitute(@%, '^term://.\\{-}:', '', '')")
  au('TermOpen', 'setl stl=%{@%}%=[terminal]')

au('TermOpen', 'endif')

-- auto close response when terminal closed
au('TermClose', [[call feedkeys("\<esc>", 'nt')]])
