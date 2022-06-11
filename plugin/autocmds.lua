-- Author: Nova Senco
-- Last Change: 06 June 2022

-- Autocommands

local au = require'utils.autocmd'.build('NovaAutocmds')

-- save and restore view persistently
au('BufWinLeave,VimLeave', 'call mkview#make()')
au('BufWinEnter', 'call mkview#load()')

-- *do NOT* insert comment when using o/O in normal mode EVER
-- *do* insert comment when pressing <cr> in insert mode in ALL comments
au('BufWinEnter,FileType', 'setl fo+=r fo-=o')

-- auto-handle swapfiles (don't interrupt me)
au('SwapExists', "call autocmd#HandleSwap(expand('<afile>:p'))")

-- auto-update "Last Changed" in comment
au('BufWritePre', 'call autocmd#updateLastChange()')

-- don't fold the command window
au('CmdwinEnter', 'setl nofoldenable foldlevel=99')

-- don't store swap, backup, viminfo for files in /tmp
au('VimEnter,BufNew', "if expand('<afile>:p') =~ '^/tmp'")
au('VimEnter,BufNew', '  setl noswapfile nowritebackup nobackup')
au('VimEnter,BufNew', 'endif')

-- open folds when searching with incsearch
au('CmdlineChanged', 'silent! foldopen', '[/?]')

-- auto-sync packer when writing lua/plugins.lua
au('BufWritePost', function()
  package.loaded.plugins = nil require'plugins' require'packer'.sync()
end, '*/lua/plugins.lua')

-- start insert when entering terminal window that was left with above mappings
au('BufWinEnter,WinEnter,CmdlineLeave', "if &bt is 'terminal' && get(b:, '_term_ins_')")
au('BufWinEnter,WinEnter,CmdlineLeave', '  startinsert')
au('BufWinEnter,WinEnter,CmdlineLeave', '  unlet! b:_term_ins_')
au('BufWinEnter,WinEnter,CmdlineLeave', 'endif')

-- A('ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', 'nokto')
-- A('ColorScheme', 'highlight ColorColumn ctermbg=235 guibg=#262626', 'nokto')
-- A('ColorScheme', 'highlight NonText ctermbg=NONE guibg=NONE cterm=bold gui=bold', 'nokto')

