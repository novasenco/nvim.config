-- Author: Nova Senco
-- Last Change: 19 March 2022

local A = require'autocmd-utils'.build_autocmd('NovaInit')

-- save and restore view persistently
A('BufWinLeave', 'call mkview#make()')
A('VimLeave', 'call mkview#make()')
A('BufWinEnter', 'call mkview#load()')

-- *do NOT* insert comment when using o/O in normal mode
-- *do* insert comment when pressing <cr> in insert mode
--      EVER.
A('BufWinEnter', 'setlocal formatoptions+=r')
A('BufWinEnter', 'setlocal formatoptions-=o')
A('FileType',    'setlocal formatoptions+=r')
A('FileType',    'setlocal formatoptions-=o')

-- -- save and restore window before and after hivis runs
-- A('User', 'let w:hivis_viewsav = winsaveview()', 'HivisPre')
-- A('User', 'call winrestview(w:hivis_viewsav)', 'Hivis')

-- autohandle swapfiles
A('SwapExists', "call autocmd#HandleSwap(expand('<afile>:p'))")

-- autoupdate "Last Changed"
A('BufWritePre', 'call autocmd#updateLastChange()')

-- don't fold the command window
A('CmdwinEnter', 'setl nofoldenable foldlevel=99')

-- don't store swap, backup, viminfo for files in /tmp
A('VimEnter,BufNew', "if expand('<afile>:p') =~ '^/tmp'")
A('VimEnter,BufNew', '  setl noswapfile nowritebackup nobackup')
A('VimEnter,BufNew', 'endif')

-- view PDF in vim
A('BufRead', "let _r = fnameescape(expand('%:r'))", '*.pdf')
A('BufRead', "exe 'e' _r.'_pdf.txt'", '*.pdf')
A('BufRead', 'setl bt=nofile', '*.pdf')
A('BufRead', "exe 'sil r !pdftotext' _r.'.pdf -'", '*.pdf')
A('BufRead', '1d', '*.pdf')

-- open folds with incsearch
A('CmdlineChanged', 'silent! foldopen', '[/?]')

-- A('BufWritePost', [[exe "lua require'packer'.sync()" | exe 'doautocmd ColorScheme' g:colors_name]], '*/lua/plugins.lua')
A('BufWritePost', function() package.loaded.plugins = nil require'plugins' require'packer'.sync() end, '*/lua/plugins.lua')

-- auto close response when terminal closed
A('TermClose', [[call feedkeys("\<esc>", 'nt')]])

-- start insert when entering terminal window that was left with above mappings
A('BufWinEnter,WinEnter,CmdlineLeave', "if &bt is 'terminal' && get(b:, '_term_ins_')")
A('BufWinEnter,WinEnter,CmdlineLeave', '  startinsert')
A('BufWinEnter,WinEnter,CmdlineLeave', '  unlet! b:_term_ins_')
A('BufWinEnter,WinEnter,CmdlineLeave', 'endif')

-- A('FileType', 'set fdm=marker')

-- " jankicus maximus
-- A('BufRead', '++nested set filetype=lua')
-- A('OptionSet', "if v:option_new == 'lua'")
-- A('OptionSet', "  unlet b:current_syntax")
-- A('OptionSet', "  syntax include @VIM syntax/vim.vim")
-- A('OptionSet', "  let b:current_syntax = 'lua'")
-- A('OptionSet', "  syntax region luaNvimExec matchgroup=Snip keepend start=+\\%(vim\\.api\\.nvim_exec(\\)\\@<=\\[\\[+ end=+\\]\\]+ containedin=luaString contained contains=@VIM")
-- A('OptionSet', "  highlight! link vimFunctionError vimFunction")
-- A('OptionSet', "endif')

-- No background :3
-- A('ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', 'nokto')
-- A('ColorScheme', 'highlight ColorColumn ctermbg=235 guibg=#262626', 'nokto')
-- A('ColorScheme', 'highlight NonText ctermbg=NONE guibg=NONE cterm=bold gui=bold', 'nokto')

-- A('FileType', 'TSBufDisable highlight', 'html')

