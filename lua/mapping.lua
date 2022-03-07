
local mapping = {}

local M = function(mode, sopts, lhs, rhs, desc)
  -- map function; eg M('n', 'sne', '
  opts = {}
  if sopts then
    if sopts:find's' then opts.silent        = true end
    if sopts:find'n' then opts.noremap       = true end
    if sopts:find'e' then opts.expr          = true end
    if sopts:find'u' then opts.unique        = true end
    if sopts:find'W' then opts.nowait        = true end
    if sopts:find'S' then opts.script        = true end
  end
  if desc then opts.desc = desc end
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

mapping.nvomap = function(...) M('', ...) end
mapping.nmap = function(...) M('n', ...) end
mapping.vmap = function(...) M('v', ...) end
mapping.xmap = function(...) M('x', ...) end
mapping.smap = function(...) M('s', ...) end
mapping.omap = function(...) M('o', ...) end
mapping.icmap = function(...) M('!', ...) end
mapping.imap = function(...) M('i', ...) end
mapping.lmap = function(...) M('l', ...) end
mapping.cmap = function(...) M('c', ...) end
mapping.tmap = function(...) M('t', ...) end

return mapping

