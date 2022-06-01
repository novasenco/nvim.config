nvim.config
===========
nova's nvim config for `:version` >= 0.7 (>= ~ +1000)


## Startup

All files in [lua/init/](/lua/init/) automatically load because of
[lua/start.lua](/lua/start.lua).

[init.lua](/init.lua) first loads everything in [lua/init/](/lua/init/). Then it
loads [lua/plugins.lua](/lua/plugins.lua). If the plugins load successfully,
then [lua/lsp.lua](/lua/lsp.lua) is called to set up lsp.

If there are errors, [![each error in the stack trace is appended to the
quickfix](https://asciinema.org/a/8aIxXVlsvEJuTQs7YIuBHiRpv.svg)](https://asciinema.org/a/8aIxXVlsvEJuTQs7YIuBHiRpv)

### Autocmds

[lua/init/autocmds.lua](/lua/init/autocmds.lua)

- auto-save and -restore view when leaving a window or nvim session.
    - the end
- force every buffer to have fo+=r fo-=o
    - the end
- better swap handling
    - reference nvim program id to detect if crash and notify about `:recover`
    - just open the file if I am editing it elsewhere and print warning
    - the end
- auto-update comments that look like "Last Changed: {date}"
    - the end
- prevent command window from folding
- don't use swap files for /tmp/\* files
- view pdf in nvim (never used)
- auto-open folds during search when 'incsearch' is enabled
- auto-update plugins after writing [lua/plugins.lua](/lua/plugins.lua)
- auto-close terminals on exit
- navigate with CTRL-W\* commands in terminals

### Commands

[lua/init/cmds.lua](/lua/init/cmds.lua)

- handle all upper- and mixed-case of :q, :qa, and :wqa
- :Argdo, :Bufdo, :Windo that preserve window/buffer location
- :Keepview {cmd} to run a {cmd} but preserve current view
    - don't use if {cmd} switches buffers, windows, or tabs
- :ArgGrep, :ArgVimgrep to search with :grep, :vimgrep on :args
- :BufGrep, :BufVimgrep to search with :grep, :vimgrep on :buffers (:ls)
- :Put {cmd} to put output of {cmd} below cursor
- :Sput {cmd} to put output of {cmd} in a new split window
    - egs, :Sput version, :Sput set
- :Make, :Lmake for quieter make
- :DiffOrig - see :help :DiffOrig
- :Cclear to quickly clear quickfix (never used)
- :Sterminal for split :term - come on nvim. Really?
    - I also have a cabbrev that auto-expands :term to :Sterm

### Maps

[lua/init/maps.lua](/lua/init/maps.lua)

- **leader**: `<space>`
- **localleader**: `<bslash>`
- `<m-w>` = silent `:update` (write) file
- `<localleader>q` = `:qa`
- `<c-l>` = `:nohl` + `:diffup` + `:redraw!`
- `<leader><c-l>` = `:syn sync fromstart`
- `<c-p>` = open last command or search (whichever opened last)
    - open last command operating on any visual selection in visual mode
- `zO` = `zO` but close folds first if folds under cursor
- `<leader>;` = toggle ';' at end of line
- `<m-M>`, `<m-L>` = :Make, :Lmake
- `<leader>p` = print syntax stack under cursor prettily
- better `*`, `#` that are case-sensitive
- better `g*` and `g#`
- `<leader>*`, `<leader>#` search for literal visual selection
- `n`, `N` always go to next, previous search (respectively and regardless of
  `*` or `#` usage
- `]b`, etc to go to `:bnext` buffer, etc
- `]a`, etc to go to `:next` argument, etc
- `<leader>l…` to do local list stuff
- `<leader>q…` to do quickfix list stuff
- `]e`, `[e` to move (range of) line(s); repeatible and undoes in one undo
    - uses :undojoin
- `]g`, `[g` to jump to git markers
- `]f`, `[f` to jump to files in current buffer's file's parent directory
- fzf commands like `<leader>F`, `<localleader>F`, etc
- `<leader>cd` to `:cd` to the current buffer's file's parent dir
    - wait for user to modify and press Return
- `<localleader>c` to open fzf at config directory
- `<localleader>C` to reload init.lua (broken; see Todo)
- `<c-s>` in insert mode fixes previous spelling error
- `<c-s>h`, `<c-s>l` fix prev, next spelling errors
- abbrev unkown -> unknown
    - yes, I typed both of these incorrectly on accident while typing this
- cabbrevs for:
    - :vsb -> :vert sb
    - :vh -> :vert h
    - :vsn -> :vert sn
    - :vspr -> :vert spr
    - :vsbn -> :vert sbn
    - :vsbp -> :vert sbp
- better commandline navigation:
    - `<m-b>` = `<s-left>`
    - `<m-f>` = `<s-right>`
    - `<m-h>` = `<left>`
    - `<m-l>` = `<right>`
    - `<m-k>` = `<up>`
    - `<m-h>` = `<left>`
    - etc
- open folds with 'incsearch' using `<c-g>`, `<c-t>`
- make nvim's :terminal behave like vim's

### Options

[lua/init/opts.lua](/lua/init/opts.lua)

- persistent undo
- grepprg set to ripgrep's rg if available
- etc

### Pastebin

[lua/init/paste.lua](/lua/init/paste.lua)

automagically paste with:

- `<leader>B{motion}` operator (eg, `<leader>Bip` for in paragraph text object)
- `<leader>BB` for current line
- `:{range}Pastebin [site]` command to upload range to optional site
    - default site is ix.io
- `:Pbset {site}` to change default {site} with custom completion

### Custom Text Objects

[lua/init/textobjs.lua](/lua/init/textobjs.lua)

- `il` = inner line (entire line sans white space)
- `al` = around line (entire line sans trailing newline)
- `id` = in document (entire buffer)
- `go` = go other (in visual mode, align this corner to other corner)
- `gO` = get other (in visual mode, align other corner to this corner)
- `in` = in number (hex, binary, decimal)
- `an` = around number (like `in` but surrounding space too)
- `ii` = in indentation (current indentation (including deeper indents))
- `ai` = around indentation (like `ii` but include surround empty lines)

### Url Stuff

[lua/init/url.lua](/lua/init/url.lua)

- fix `gx` from gross netrw plugin
    - also enhance: `<leader>u`, `<leader>U` visually select next, prev URL
- add `gX` to perform vim command on URL under cursor


## Plugins

[lua/plugins.lua](/lua/plugins.lua)

Uses packer.nvim. Automagically sets up on startup. Automatically updates when
plugins.lua is written.

Todo: create list of plugins with very brief descriptions

## LSP

[lua/lsp.lua](/lua/lsp.lua)

Loaded after plugins.

- sumneko lua
- c

Todo: Share (global and buffer) key maps created here

## Autocmd Utils

[lua/autocmd-utils.lua](/lua/autocmd-utils.lua)

autocmd-utils is a simple utility class to create an augroup and generate an
autocmd function (using a closure) that adds autocmds to that created augroup.
Here's an example.

```lua
local au = require('autocmd-utils').build('MyAugroup')
au('VimEnter', [[unsilent echom 'Hello, welcome to nvim']])
au('FileType', function() print"You're editing a markdown file" end, 'markdown')
```

Note that the first param is the event, the second is the command (string for
vim command, function for lua callback), and the third is the optional pattern
(`'*'` by default).

The above code block is equivalent to

```vim
augroup MyAugroup
    au!
    au VimEnter * unsilent echom 'Hello, welcome to nvim'
    au FileType markdown lua print"You're editing a markdown file"
augroup end
```

## Map Utils

[lua/map-utils.lua](/lua/map-utils.lua)

map-utils creates lots of useful map functions that can be used to more
easily create maps. For example `nmap('sn', '<c-g>', '<cmd>echo "hi"<cr>")` is
equivalent to `:nnoremap <silent> <c-g> <cmd>echo "hi"<cr>` in vim-script.

The first arg is a string of flags:

- 's': `<silent>`
- 'n': `nore` (as in n**nore**map)
- 'e': `<expr>`
- 'u': `<unique>`
- 'W': `<nowait>`
- 'S': `<script>`

Use `bnmap(…)` for `nmap <buffer> ...`, `bmap('n', …)` for `nnoremap <buffer>`,
`xmap(…)` for visual map, `cmap(…)` for command map, `imap(…)` for insert map,
`tmap(…)` for terminal map, etc.

## Folding

[after/plugin/fold.vim](/after/plugin/fold.vim)

uses [autoload/fold.vim](/autoload/fold.vim) to create a nice, simple fold.

It converts `Foo {{{1` to `Foo ● …`, `Foo {{{2` to `Foo ●● …`, etc - assuming
'foldmethod' is `marker` and 'foldmarker' is `{{{,}}}`.

## Filetype Plugin

[after/ftplugin/](/after/ftplugin/)

custom settings per filetype

## Todo

- map/command to reload init.lua via lua
