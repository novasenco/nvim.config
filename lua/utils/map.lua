-- Author: Nova Senco
-- Last Change: 06 June 2022

local utils = {}

function utils.set(mode, lhs, rhs, opts, desc, bnr)
  -- map `lhs` to `rhs` in `mode`(s) with options `opts` and description `desc`
  -- (optionally for buffer `bnr`). Ie: simplify vim.keymap.set()
  --
  -- Eg: local map = require'utils.map'.set
  --     map('nxsic', '<f1>', '<cmd>write<cr>', 'ns')
  --
  --     this is the same as the following in vim-script:
  --        nnoremap <silent> <f1> <cmd>write<cr>
  --        xnoremap <silent> <f1> <cmd>write<cr>
  --        snoremap <silent> <f1> <cmd>write<cr>
  --        inoremap <silent> <f1> <cmd>write<cr>
  --        cnoremap <silent> <f1> <cmd>write<cr>
  --
  -- `mode`:
  --    string or table of short modes (see :help map-table for more info); if
  --    it's a string, it's converted to a table for vim.keymap.set()
  --
  --    (empty string) => normal, visual, select, operator-pending
  --    n => normal
  --    ! => insert and command-line
  --    i => insert
  --    c => command-line
  --    v => visual and select
  --    x => visual
  --    s => select
  --    o => operator-pending
  --    t => terminal
  --    l => insert, command-line, lang-arg
  --
  -- `lhs`:
  --    string representing the left-hand side of the map; egs: '<leader>a',
  --    '<f1>', '<c-a>', '<m-a>', etc
  --
  -- `rhs`:
  --    string representing an ex command or lua function (wow!)
  --
  -- `opts` (optional):
  --    options as a string or table (see :help vim.keymap.set() and :help
  --    nvim_set_keymap()); if it's a string, it's convert to a table for
  --    vim.keymap.set()
  --
  --    s => <silent>
  --    n => noremap
  --    e => <expr>
  --    r => use nvim_replace_termcodes()
  --    b => use <buffer> (if `bnr` is a number, this overrides 'b' in `opts`)
  --    R => remap (opposite of noremap)
  --    u => <unique>
  --    W => <nowait>
  --    S => <script>
  --
  -- `desc` (optional):
  --    description (string) for the map (this shows up in :map output)
  --
  -- `bnr` (optional):
  --    buffer number in which to map this buffer-local mapping

  local modes
  if #mode > 1 then
    modes = {}
    for i = 1, #mode do
      modes[#modes + 1] = mode:sub(i, i)
    end
  else
    modes = mode
  end

  local o = {}
  if opts then
    if opts:find's' then o.silent  = true end
    if opts:find'n' then o.noremap = true end
    if opts:find'e' then o.expr    = true end
    if opts:find'r' then o.replace_termcodes = true end
    if opts:find'b' then o.buffer  = true end
    if opts:find'R' then o.remap   = true end
    if opts:find'u' then o.unique  = true end
    if opts:find'W' then o.nowait  = true end
    if opts:find'S' then o.script  = true end
  end
  if desc then o.desc = desc end
  if bnr then o.buffer = bnr end

  vim.keymap.set(modes, lhs, rhs, o)
end

return utils

