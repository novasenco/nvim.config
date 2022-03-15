-- Author: Nova Senco
-- Last Change: 10 March 2022

local utils = {}

function utils:map(mode, sopts, lhs, rhs, desc)
  -- map function; eg map('n', 'sne', '
  local opts = {}
  if sopts then
    if sopts:find's' then opts.silent  = true end
    if sopts:find'n' then opts.noremap = true end
    if sopts:find'e' then opts.expr    = true end
    if sopts:find'u' then opts.unique  = true end
    if sopts:find'W' then opts.nowait  = true end
    if sopts:find'S' then opts.script  = true end
  end
  if desc then opts.desc = desc end
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function utils:nvomap(...) utils:map('', ...) end
function utils:nmap(...) utils:map('n', ...) end
function utils:vmap(...) utils:map('v', ...) end
function utils:xmap(...) utils:map('x', ...) end
function utils:smap(...) utils:map('s', ...) end
function utils:omap(...) utils:map('o', ...) end
function utils:icmap(...) utils:map('!', ...) end
function utils:imap(...) utils:map('i', ...) end
function utils:lmap(...) utils:map('l', ...) end
function utils:cmap(...) utils:map('c', ...) end
function utils:tmap(...) utils:map('t', ...) end

return utils

