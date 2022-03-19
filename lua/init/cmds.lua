-- Author: Nova Senco
-- Last Change: 18 March 2022

local C = vim.api.nvim_add_user_command
local o -- opts

o = { bang=true, bar=true, nargs='?' }
C('Q'  , 'q<bang> <args>'  , o)
C('QA' , 'qa<bang> <args>' , o)
C('Qa' , 'qa<bang> <args>' , o)
C('WQ' , 'wq<bang> <args>' , o)
C('Wq' , 'wq<bang> <args>' , o)
C('WQA', 'wqa<bang> <args>', o)
C('WQa', 'wqa<bang> <args>', o)
C('Wqa', 'wqa<bang> <args>', o)

-- :{arg,buf,win}do without mucking syntax or changing buffers
o = { nargs='+' }
C('Argdo', 'call cmds#ArgDo(<q-args>)', o)
C('Bufdo', 'call cmds#BufDo(<q-args>)', o)
C('Windo', 'call cmds#WinDo(<q-args>)', o)

-- preserve view while executing some command
C('Keepview', table.concat({
  'let g:viewsav=winsaveview()',
  'exe escape(<q-args>, \'\\"\')',
  'call winrestview(g:viewsav)',
  'unlet g:viewsav',
  }, '|'), { nargs=1, bar=true })

-- search all args with :grep or :vimgrep (do NOT use on big files)
o = { nargs='+', bar=true }
C('ArgGrep'   , 'call cmds#FilelistGrep(<q-args>, argv())'   , o)
C('ArgVimgrep', 'call cmds#FilelistVimgrep(<q-args>, argv())', o)

-- search all listed buffers with :grep or :vimgrep (do NOT use on big files)
C('BufGrep'   , 'call cmds#FilelistGrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', o)
C('BufVimgrep', 'call cmds#FilelistVimgrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', o)

-- put an ex command - eg :Put version
o = { range=true, nargs='+', complete='command' }
C('Put' , 'call cmds#Put(<q-args>, <line1>, getcurpos(), 0, "")', o)
C('Sput', 'call cmds#Put(<q-args>, <line1>, getcurpos(), 1, <q-mods>)', o)

-- still synchronous but quieter make
o = { bar=true, nargs='?' }
C('Make' , 'call cmds#Make(<q-args>)', o)
C('Lmake', 'call cmds#Lmake(<q-args>)', o)

-- :help :DiffOrig
C('DiffOrig', table.concat({
  'vert new',
  'set buftype=nofile',
  'read ++e#',
  '0d_',
  'diffthis',
  'wincmd p',
  'diffthis',
  }, '|'), {})

-- clear quickfix
C('Cclear', 'call setqflist([], "r")', { nargs=0 })

-- neovim, come on, bestie
C('Sterminal', '<mods> split | terminal <args>', { nargs='*' })
