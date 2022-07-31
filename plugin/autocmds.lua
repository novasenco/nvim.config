-- Author: Nova Senco
-- Last Change: 30 July 2022

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

-- au('ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', 'nokto')
-- au('ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', 'vulpo')
-- vim.cmd[[exe 'doautocmd ColorScheme' get(g:, 'colors_name', 'default')]]
-- au('ColorScheme', 'highlight ColorColumn ctermbg=235 guibg=#262626', 'nokto')
-- au('ColorScheme', 'highlight NonText ctermbg=NONE guibg=NONE cterm=bold gui=bold', 'nokto')

