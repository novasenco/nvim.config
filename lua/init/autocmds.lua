
local augroup = 'NovaInit'
vim.api.nvim_create_augroup(augroup, { clear=true })
local A = function(evt, cmd, pat)
  vim.api.nvim_create_autocmd(evt, {group=augroup, command=cmd, pattern=pat})
end

-- save and restore view persistently
A('BufWinLeave', 'call mkview#make()')
A('VimLeave', 'call mkview#make()')
A('BufWinEnter', 'call mkview#load()')

A('BufWinEnter', "if !has('vim_starting') || !empty(bufname())")
A('BufWinEnter', '  set concealcursor=n') --  hide concealed text in normal
A('BufWinEnter', '  set conceallevel=2') -- conceal fully, but show cchar if defined
A('BufWinEnter', 'endif')

-- *do NOT* insert comment when using o/O in normal mode
-- *do* insert comment when pressing <cr> in insert mode
A('BufWinEnter', 'set formatoptions+=r')
A('BufWinEnter', 'set formatoptions-=o')

-- save and restore window before and after hivis runs
A('User', 'let w:hivis_viewsav = winsaveview()', 'HivisPre')
A('User', 'call winrestview(w:hivis_viewsav)', 'Hivis')

-- *don't* insert comment when using o/O in normal mode
-- *do* insert comment when pressing <cr> in insert mode
A('FileType', 'setlocal formatoptions+=r')
A('FileType', 'setlocal formatoptions-=o')

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

A('BufWritePost', "exe 'luafile %' | exe 'PackerInstall' | exe 'PackerCompile'", '*/lua/*/plugins.lua')
A('BufWritePost', "exe 'luafile %' | exe 'PackerInstall' | exe 'PackerCompile'", '*/lua/plugins.lua')

-- auto close response when terminal closed
A('TermClose', 'call feedkeys("\\<esc>", \'nt\')')

-- start insert when entering terminal window that was left with above mappings
A('BufWinEnter,WinEnter,CmdlineLeave', "if &bt is 'terminal' && get(b:, '_term_ins_')")
A('BufWinEnter,WinEnter,CmdlineLeave', '  startinsert')
A('BufWinEnter,WinEnter,CmdlineLeave', '  unlet! b:_term_ins_')
A('BufWinEnter,WinEnter,CmdlineLeave', 'endif')

A('FileType', 'set fdm=marker')

-- " jankicus maximus
-- A('BufRead', '++nested set filetype=lua')
-- A('OptionSet', "if v:option_new == 'lua'")
-- A('OptionSet', "  unlet b:current_syntax")
-- A('OptionSet', "  syntax include @VIM syntax/vim.vim")
-- A('OptionSet', "  let b:current_syntax = 'lua'")
-- A('OptionSet', "  syntax region luaNvimExec matchgroup=Snip keepend start=+\\%(vim\\.api\\.nvim_exec(\\)\\@<=\\[\\[+ end=+\\]\\]+ containedin=luaString contained contains=@VIM")
-- A('OptionSet', "  highlight! link vimFunctionError vimFunction")
-- A('OptionSet', "endif')

-- A('ColorScheme', { command='highlight Normal ctermbg=NONE guibg=NONE' })
-- A('ColorScheme', { command='highlight! MatchWord cterm=underline gui=underline ctermbg=234 guibg=#1c1c1c' })
-- A('ColorScheme', { command='highlight Folded guibg=NONE ctermbg=NONE guifg=af8787 ctermfg=138' })

-- A('FileType', 'TSBufDisable highlight', 'html')

-- md2pdf
A('BufWritePost', 'call md2pdf#convert', '*.md')

