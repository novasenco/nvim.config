-- Author: Nova Senco
-- Last Change: 17 July 2022

-- setup {{{1

local map = require'utils.map'.set
local au = require'utils.autocmd'.build('NovaMaps')

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

local desc

-- main {{{1

-- since I set <space> to mapleader but it is a valid command (similar to
-- <right>), set it to <nop> so it won't trigger any weird side effects if a map
-- is cancelled
map('n', '<space>', '', nil, 'minimize annoying mapleader accidents')

-- :write file if unsaved
--    <m-w> => update file silently
--    <m-W> => update file silently and don't trigger any autocommands
map('nix', '<m-w>', '<cmd>silent update<cr>', 'sn', 'quietly update file')
map('nix', '<m-W>', '<cmd>silent noautocmd update<cr>', 'sn', 'quietly update without autocmds')

-- fast quitting (don't force if unsaved changes, though)
--    <bslash>q => :qa
map('n', '<localleader>q', '<cmd>qa<cr>', 'sn', 'quit unless unsaved changes')

-- efficient redrawing
--    <c-l> => :nohls, :diffu, :redraw! all in one
--    <space><c-l> => :syn sync fromstart for when syn hl is broken
map('n', '<c-l>', "<cmd>nohlsearch|diffupdate|redraw!|echon ''<cr>", 'sn', ':nohlsearch, :diffupdate, :redraw! all in one')
map('n', '<leader><c-l>', ':syntax sync fromstart<cr>', 'sn', 'sync syntax from beginning of file')

-- perform last command-line operation (:, /, ?) again and wait for enter
--    <c-p> => open last command or search
--    <c-p> => [visual] open last ex command that starts with ":'<,'>"
map('n','<c-p>', "{last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'",
    'ne', 'opens last command or search')
au('CmdlineEnter', function() vim.g._cmdtype_last_ = vim.v.event.cmdtype end)
map('x', '<c-p>', ":<c-u>'<,'><up>", 'n', "open last command operating on visual selection")

-- ensure that fold and parent folds are open
--    zO => first zc then zO if fold closed; else zO
map('n', 'zO', "foldclosed('.') is -1 ? 'zczO' : 'zO'", 'ne', 'same as zO but if fold already open, close first')

-- for C-like languages ...
--    <space>; => toggle ';' at EOL
map('n', '<leader>;', "(getline('.') =~# ';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'", 'sne', 'toggle ";" at end of line')

-- quick make; see plugin/cmds.lua
--    <m-M> => :Make
--    <m-L> => :Lmake
map('n', '<m-M>', '<cmd>sil Make<cr>', 'sn', 'quick :Make')
map('n', '<m-L>', '<cmd>sil Lmake<cr>', 'sn', 'quick :Lmake')

-- see highlight groups or selection stats; see autoload/synstack.vim
--    <space>p => print highlight groups (with color!) under cursor from highest to lowest
--    <space>p => [visual] print stats (lines, chars, bytes, words selected)
map('n', '<leader>p', '<cmd>call synstack#echo()<cr>', 'sn', 'print highlight groups')
map('x', '<leader>p', 'synstack#vExprPrint()', 'ne', "print stats visual selection (similar to 'showcmd')")

-- fix op-pending w / W (because w and W move until next word, so why should dw ignore space?! it's not de!!)
--    {cmd}w / {cmd}W => goes until next word and includes space if any
map('o', 'w', '<cmd>call maps#o_word(0)<cr>', 'sn', 'fix cw/dw inconsistency')
map('o', 'W', '<cmd>call maps#o_word(1)<cr>', 'sn', 'fix cW/dW inconsistency')

-- search {{{1

-- better * / #
--    * / # => search <cword> and enforce case even if 'ignorecase' (and 'smartcase') is set
--    g* / g# => like * / # but don't include word boundaries: /\</ and /\>/
map('n', '*', "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<cr>", 'sn', "like * but respect capitalization; don't move cursor")
map('n', '#', "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<bar>call search('', 'bc')<cr>", 'sn', "like # but respect capitalization; move cursor to beg of word")
map('n', 'g*', "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<cr>", 'sn', "like g* without \\< and \\>")
map('n', 'g#', "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<bar>call search('', 'bc')<cr>", 'sn', "like g# without \\< and \\>")

-- use * / # / g* / g# in visual mode; see above comments, for they are directly mapped
map('x', '*', '<esc>*gv', nil, 'use * in visual mode')
map('x', '#', '<esc>#gv', nil, 'use # in visual mode')
map('x', 'g*', '<esc>g*gv', nil, 'use g* in visual mode')
map('x', 'g#', '<esc>g#gv', nil, 'use g# in visual mode')

-- faster way to to do *Ncgn / *NcgN
--    {cmd}* / {cmd}# => perform {cmd} on /\<<cword>\>/
--    {cmd}g* / {cmd}g# => perform {cmd} on /<cword>/
--
--    eg: c*Replacement<esc>.. to replace <cword> with 'Replacement' and repeat twice
map('o', '*', 'maps#stargn(1)', 'sne', "faster *N{op}gn")
map('o', '#', 'maps#stargn(1)', 'sne', "faster #N{op}gn")
map('o', 'g*', 'maps#stargn(0)', 'sne', "faster g*N{op}gn")
map('o', 'g#', 'maps#stargn(0)', 'sne', "faster g#N{op}gn")

-- literal search of visual selection
--    <space># / <space>* => search backward / forward for visual selection literally (escape all specials for regex)
map('x', '<leader>#', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', 'n', 'search backward for literal visual selection')
map('x', '<leader>*', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', 'n', 'search forward for literal visual selection')

-- n and N should always search in the same direction. period.
--    n / N => like vanilla n / N but always the same direction regardless of v:searchforward
map('nxo', 'n', function()
  -- vim.v.searchforward = 1 -- broken wtf
  vim.cmd[[let v:searchforward = 1]]
  vim.api.nvim_feedkeys('n', 'ntx', false)
  if vim.fn.foldclosed('.') >= 0 then
    vim.cmd'silent! foldopen!'
  end
end, 'n', 'always search forwards')

map('nxo', 'N', function()
  -- vim.v.searchforward = 1 -- broken wtf
  vim.cmd[[let v:searchforward = 1]]
  vim.api.nvim_feedkeys('N', 'ntx', false)
  if vim.fn.foldclosed('.') >= 0 then
    vim.cmd'silent! foldopen!'
  end
end, 'n', 'always search backwards')

-- open folds automatically when jumping to different matches
--    <c-t> / <c-g> => jump to prev / next match while searching and auto-open fold if closed
map('c', '<c-t>', "<c-t><c-r>=execute('sil! foldo!')[-1]<cr>", 'n')
map('c', '<c-g>', "<c-g><c-r>=execute('sil! foldo!')[-1]<cr>", 'n')


-- quick {{{1

-- quickly jump places and open things

-- buffers
--    [b / ]b => jump to prev / next buffer
--    [B / ]B => jump to first / last buffer
map('n', '[b', ":<c-u>execute v:count.'bprevious'<cr>", 'sn', '[count] bprevious')
map('n', '[B', ":bfirst<cr>", 'sn', 'bfirst')
map('n', ']b', ":<c-u>execute v:count.'bnext'<cr>", 'sn', '[count] bnext')
map('n', ']B', ":blast<cr>", 'sn', 'blast')

-- arguments
--    [a / ]a => jump to prev / next arg
--    [A / ]A => jump to first / last arg
map('n', '[a', ":<c-u>execute v:count.'previous'<cr>", 'sn', '[count] previous')
map('n', '[A', ":first<cr>", 'sn', 'first')
map('n', ']a', ":<c-u>execute v:count.'next'<cr>", 'sn', '[count] next')
map('n', ']A', ":last<cr>", 'sn', 'last')

-- local list
--    <space>wl => toggle location list
--    <space>wo => open location list
--    <space>wc => close ocatino list
--    [w / ]w => go to prev / next location list
--    [W / ]W => go to first / last location list
map('n', '<leader>wl', '<cmd>call maps#locToggle()<cr>', 'sn', 'toggle local list')
map('n', '<leader>wo', ':lopen<cr>', 'sn', 'open local list')
map('n', '<leader>wc', ':lclose<cr>', 'sn', 'close local list')
map('n', '[w', ":<c-u>execute v:count.'lprevious'<cr>", 'sn', '[count] lprevious')
map('n', '[W', ':lfirst<cr>', 'sn', 'lfirst')
map('n', ']w', ":<c-u>execute v:count.'lnext'<cr>", 'sn', '[count] lnext')
map('n', ']W', ":llast<cr>", 'sn', 'llast')

-- quickfix
--    <space>ql => toggle quickfix list
--    <space>qo => open quickfix list
--    <space>qc => close ocatino list
--    [q / ]q => go to prev / next quickfix list
--    [Q / ]Q => go to first / last quickfix list
map('n', '<leader>qq', '<cmd>call maps#qfToggle()<cr>', 'sn', 'toggle quickfix list')
map('n', '<leader>qo', ':belowright copen<cr>', 'sn', 'open quickfix list')
map('n', '<leader>qc', ':cclose<cr>', 'sn', 'close quickfix list')
map('n', '[q', ":<c-u>execute v:count.'cprevious'<cr>", 'sn', '[count] cprevious')
map('n', '[Q', ':cfirst<cr>', 'sn', 'cfirst')
map('n', ']q', ":<c-u>execute v:count.'cnext'<cr>", 'sn', '[count] cnext')
map('n', ']Q', ':clast<cr>', 'sn', 'clast')

-- moving lines; tldr: [e.......u (repeatable but undo whole move operation)
--    [e / ]e => move current line or visual selection up / down (repeat with .)
map('n', '[e', ':<c-u>call maps#moveLine(0, v:count, 0)<cr>', 'sn', 'move line up')
map('x', '[e', ':<c-u>call maps#moveLine(0, v:count, 1)<cr>', 'sn', 'move selection up')
map('n', ']e', ':<c-u>call maps#moveLine(1, v:count, 0)<cr>', 'sn', 'move line down')
map('x', ']e', ':<c-u>call maps#moveLine(1, v:count, 1)<cr>', 'sn', 'move selection down')

-- go to git marker
--    [g / ]g => go to prev / next git marker
map('n', '[g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb')<cr>", 'sn', 'jump to next git marker')
map('n', ']g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>", 'sn', 'jump to previous git marker')

-- jump to next file
map('n', ']f', ':call maps#nextFile(1)<cr>', 'sn', 'edit next file in directory')
map('n', '[f', ':call maps#nextFile(0)<cr>', 'sn', 'edit previous file in directory')

-- browse files in cwd
map('n', '<leader>f', ':Files<cr>', 'sn', 'browse ./**')

-- browse oldfiles
map('n', '<leader>F', '<cmd>History<cr>', 'sn', 'browse oldfiles')

-- browse files in current file's directory
map('n', '<localleader>f', '<cmd>Files %:p:h<cr>', 'sn', 'browse %:p:h/**')

-- fill cmdline with :Files %:p:h, expand it, wait
map('n', '<localleader>F', ':Files %:p:h<c-z>', 'n', 'browse %:p:h/** but wait for user')
map('n', '<leader>b', '<cmd>Buffers<cr>', 'sn', 'switch buffers')

-- map('n', '<leader>sb', ':BLines<cr>', 'n', 'find pattern in current buffer')
-- map('n', '<leader>sB', ':Lines<cr>', 'n', 'find pattern in buffers')
-- map('n', '<leader>S', ':Rg ', 'n', 'find pattern in files')
-- map('n', '<leader>:', '<cmd>History :<cr>', 'sn')
-- map('n', '<leader>/', '<cmd>History /<cr>', 'sn')

map('n', '<leader>cd', ':cd %:p:h<c-z>', 'n', 'cd %:p:h; wait')

map('n', '<leader>g', ':Git ', 'n')

-- config {{{1

-- quickly edit / source config
--
--    <bslash>c open fzf on .config/nvim/ directory
--    <bslash>C source all vim / lua in plugin/*

map('n', '<localleader>c',
    "<cmd>call fzf#run(fzf#wrap('Files', #{source:'fd --type f --hidden --follow --exclude pack --exclude spell --exclude .gitignore --exclude .git', dir:stdpath('config'), options:fzf#vim#with_preview().options}))<cr>",
    'sn', 'edit files in config')

map('n', '<localleader>C', function()
  local dn = vim.fn.stdpath'config'..'/plugin/'
  local fd  = vim.loop.fs_opendir(dn, nil, 10)
  local fs = vim.loop.fs_readdir(fd)
  local files = {}
  while fs do
    for _,f in ipairs(fs) do
      if f.type == 'file' then
        local cmd = nil
        if f.name:match'.lua$' then -- lua script
          cmd = 'luafile'
        elseif f.name:match'.vim$' then -- vim script
          cmd = 'source'
        end
        if cmd then
          files[#files+1] = f.name
          vim.api.nvim_cmd({ cmd=cmd, args={dn..f.name} }, {})
        end
      end
    end
    fs = vim.loop.fs_readdir(fd)
  end
  vim.loop.fs_closedir(fd)
  print(vim.inspect( files ))
  print(string.format('Reloaded plugin/{%s}', table.concat(files, ',')))
  end, 'sn', 'reload config')

-- spell {{{1

-- Quickly fix spelling errors (don't forget to :setl spell)
-- Note: CTRL-S may conflict with "flow control" in some terminals
--
--    <c-s> fix last spelling error while in insert mode
--    <c-s>h fix last spelling error from normal mode (. to repeat)
--    <c-s>l fix next spelling error (. to repeat)
--    <c-s>gh / <c-s>gl spell good prev / next
--    <c-s>Gh / <c-s>Gl spell good (internal) prev / next

map('i', '<c-s>', '<esc>[s1z=gi', 'n', 'quickly fix prev spell error in insert mode')

map('n', '<c-s>h', '[s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', 'sn', 'fix prev spell error (repeatable)')
map('n', '<c-s>l', ']s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', 'sn', 'fix next spell error (repeatable)')

desc = 'spell gooding (repeatable)'
map('n', '<c-s>gh', '[Szg``:sil! call repeat#set("\\<c-s>gh")<cr>', 'sn', desc)
map('n', '<c-s>gl', ']Szg``:sil! call repeat#set("\\<c-s>gl")<cr>', 'sn', desc)
map('n', '<c-s>Gh', '[SzG``:sil! call repeat#set("\\<c-s>Gh")<cr>', 'sn', desc)
map('n', '<c-s>Gl', ']SzG``:sil! call repeat#set("\\<c-s>Gl")<cr>', 'sn', desc)

-- cmdline {{{1

-- Navigate command line easier
--
--    <m-h> move <left>
--    <m-j> move <down>
--    <m-k> move <up>
--    <m-l> move <right>
--    <m-b> move back (like <s-left>)
--    <m-f> move forward (like <s-right>)
--    <m-a> move to BOL (like <c-b>)
--    <m-e> move to EOL (like <c-e>)

map('c', '<m-b>', '<s-left>', 'n', 'better than <s-left>')
map('c', '<m-f>', '<s-right>', 'n', 'better than <s-right>')

desc = 'Better than '
map('c', '<m-h>', '<left>',  'n', desc..'left')
map('c', '<m-l>', '<right>', 'n', desc..'right')
map('c', '<m-k>', '<up>',    'n', desc..'up')
map('c', '<m-j>', '<down>',  'n', desc..'down')

map('c', '<m-a>', '<c-b>', 'n', 'mirror <c-b>')
map('c', '<m-e>', '<c-e>', 'n', 'mirror <c-e>')

-- snap {{{1

-- create placeholders/reminders and snap to them later
-- see https://github.com/novasenco/snap
--
--    <m-p> insert placeholder
--    <m-P> insert reminder (placeholder with reminder text)
--    <m-o> snap to placeholder
--    <m-i> snap to placeholder backwards
--    <m-O> repeat last insertion on next placeholder
--    <m-I> repeat last insertion on prev placeholder

map('i', '<m-p>', '<plug>(snapSimple)', nil, 'insert placeholder')
map('i', '<m-P>', '<plug>(snapText)', nil, 'insert reminder')
map('inxso', '<m-o>', '<plug>(snapNext)', nil, 'snap to next placeholder')
map('inxs', '<m-O>', '<plug>(snapRepeatNext)', nil, 'repeat last snap on next placeholder')
map('inxso', '<m-i>', '<plug>(snapPrev)', nil, 'snap to previous placeholder')
map('inxs', '<m-I>', '<plug>(snapRepeatPrev)', nil, 'repeat last snap on previous placeholder')

-- luasnip {{{1

-- maps for luasnip
--
--    <m-j> expand snippet
--    <m-l> jump to next node
--    <m-h> jump to prev node
--    <m-k> toggle choice node
--    <m-K> toggle choice node backwards

local ls = require'luasnip'

map('is', '<m-j>', function()
  if ls.expandable() then
    ls.expand()
  end
end, 'sn', 'expand luasnippet')

map('isn', '<m-h>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, 'sn', 'jump to previous luasnip node')

map('isn', '<m-l>', function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, 'sn', 'jump to next luasnip node')

map('is', '<m-k>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, 'sn', 'cycle forward though luasnip node choices')

map('is', '<m-K>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end, 'sn', 'cycle backward though luasnip node choices')

