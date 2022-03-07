-- Author: Nova Senco
-- Last Change: 23 February 2022

local c = vim.api.nvim_add_user_command
local o 

o = { bang=true, bar=true, nargs='?' }
c('Q'  , 'q<bang> <args>'  , o)
c('QA' , 'qa<bang> <args>' , o)
c('Qa' , 'qa<bang> <args>' , o)
c('WQ' , 'wq<bang> <args>' , o)
c('Wq' , 'wq<bang> <args>' , o)
c('WQA', 'wqa<bang> <args>', o)
c('WQa', 'wqa<bang> <args>', o)
c('Wqa', 'wqa<bang> <args>', o)

-- :{arg,buf,win}do without mucking syntax or changing buffers
o = { nargs='+' }
c('Argdo', 'call cmds#ArgDo(<q-args>)', o)
c('Bufdo', 'call cmds#BufDo(<q-args>)', o)
c('Windo', 'call cmds#WinDo(<q-args>)', o)

-- preserve view while executing some command
c('Keepview', table.concat({
  'let g:viewsav=winsaveview()',
  'exe escape(<q-args>, \'\\"\')',
  'call winrestview(g:viewsav)',
  'unlet g:viewsav',
  }, '|'), { nargs=1, bar=true })

-- search all args with :grep or :vimgrep (do NOT use on big files)
o = { nargs='+', bar=true }
c('ArgGrep'   , 'call cmds#FilelistGrep(<q-args>, argv())'   , o)
c('ArgVimgrep', 'call cmds#FilelistVimgrep(<q-args>, argv())', o)

-- search all listed buffers with :grep or :vimgrep (do NOT use on big files)
c('BufGrep'   , 'call cmds#FilelistGrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', o)
c('BufVimgrep', 'call cmds#FilelistVimgrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', o)

-- put an ex command - eg :Put version
o = { range=true, nargs='+', complete='command' }
c('Put' , 'call cmds#Put(<q-args>, <line1>, getcurpos(), 0, "")', o)
c('Sput', 'call cmds#Put(<q-args>, <line1>, getcurpos(), 1, <q-mods>)', o)

-- still synchronous but quieter make
o = { bar=true, nargs='?' }
c('Make' , 'call cmds#Make(<q-args>)', o)
c('Lmake', 'call cmds#Lmake(<q-args>)', o)

-- :help :DiffOrig
c('DiffOrig', table.concat({
  'vert new',
  'set buftype=nofile',
  'read ++e#',
  '0d_',
  'diffthis',
  'wincmd p',
  'diffthis',
  }, '|'), {})

-- clear quickfix
c('Cclear', 'call setqflist([], "r")', { nargs=0 })

-- neovim, come on, bestie
c('Sterminal', '<mods> split | terminal <args>', { nargs='*' })
