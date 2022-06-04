-- Author: Nova Senco
-- Last Change: 02 June 2022

local au = require'utils.autocmd'.build('NovaAutocmds')

-- au('VimEnter', 'exe "norm Adate\\<m-l>"')

-- save and restore view persistently
au('BufWinLeave', 'call mkview#make()')
au('VimLeave', 'call mkview#make()')
au('BufWinEnter', 'call mkview#load()')

-- *do NOT* insert comment when using o/O in normal mode
-- *do* insert comment when pressing <cr> in insert mode
--      EVER.
au('BufWinEnter', 'setlocal formatoptions+=r')
au('BufWinEnter', 'setlocal formatoptions-=o')
au('FileType',    'setlocal formatoptions+=r')
au('FileType',    'setlocal formatoptions-=o')

-- -- save and restore window before and after hivis runs
-- A('User', 'let w:hivis_viewsav = winsaveview()', 'HivisPre')
-- A('User', 'call winrestview(w:hivis_viewsav)', 'Hivis')

-- autohandle swapfiles
au('SwapExists', "call autocmd#HandleSwap(expand('<afile>:p'))")

-- autoupdate "Last Changed"
au('BufWritePre', 'call autocmd#updateLastChange()')

-- don't fold the command window
au('CmdwinEnter', 'setl nofoldenable foldlevel=99')

-- don't store swap, backup, viminfo for files in /tmp
au('VimEnter,BufNew', "if expand('<afile>:p') =~ '^/tmp'")
au('VimEnter,BufNew', '  setl noswapfile nowritebackup nobackup')
au('VimEnter,BufNew', 'endif')

-- view PDF in vim
au('BufRead', "let _r = fnameescape(expand('%:r'))", '*.pdf')
au('BufRead', "exe 'e' _r.'_pdf.txt'", '*.pdf')
au('BufRead', 'setl bt=nofile', '*.pdf')
au('BufRead', "exe 'sil r !pdftotext' _r.'.pdf -'", '*.pdf')
au('BufRead', '1d', '*.pdf')

-- open folds with incsearch
au('CmdlineChanged', 'silent! foldopen', '[/?]')

-- A('BufWritePost', [[exe "lua require'packer'.sync()" | exe 'doautocmd ColorScheme' g:colors_name]], '*/lua/plugins.lua')
au('BufWritePost', function() package.loaded.plugins = nil require'plugins' require'packer'.sync() end, '*/lua/plugins.lua')

-- start insert when entering terminal window that was left with above mappings
au({'BufWinEnter','WinEnter','CmdlineLeave'}, "if &bt is 'terminal' && get(b:, '_term_ins_')")
au({'BufWinEnter','WinEnter','CmdlineLeave'}, '  startinsert')
au({'BufWinEnter','WinEnter','CmdlineLeave'}, '  unlet! b:_term_ins_')
au({'BufWinEnter','WinEnter','CmdlineLeave'}, 'endif')

au({'BufNewFile'}, [[call setline(1, readfile(stdpath('config')..'/lua/snippets/.skel'))]], vim.fn.stdpath('config')..'/lua/snippets/*.lua')
au({'BufNewFile'}, [[echo 'New snippet buffer created; read snippet skeleton (lua/snippets/.skel)']], vim.fn.stdpath('config')..'/lua/snippets/*.lua')

-- A('FileType', 'set fdm=marker')

-- No background :3
-- A('ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', 'nokto')
-- A('ColorScheme', 'highlight ColorColumn ctermbg=235 guibg=#262626', 'nokto')
-- A('ColorScheme', 'highlight NonText ctermbg=NONE guibg=NONE cterm=bold gui=bold', 'nokto')

-- A('FileType', 'TSBufDisable highlight', 'html')

