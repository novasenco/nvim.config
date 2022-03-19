-- Author: Nova Senco
-- Last Change: 18 March 2022

local utils = {}

function utils.map(mode, sopts, lhs, rhs, desc)
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

function utils.bmap(mode, bnr, sopts, lhs, rhs, desc)
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
  vim.api.nvim_buf_set_keymap(bnr, mode, lhs, rhs, opts)
end

function utils.nvomap(sopts, lhs, rhs, desc) utils.map('', sopts, lhs, rhs, desc) end
function utils.nmap(sopts, lhs, rhs, desc)   utils.map('n', sopts, lhs, rhs, desc) end
function utils.vmap(sopts, lhs, rhs, desc)   utils.map('v', sopts, lhs, rhs, desc) end
function utils.xmap(sopts, lhs, rhs, desc)   utils.map('x', sopts, lhs, rhs, desc) end
function utils.smap(sopts, lhs, rhs, desc)   utils.map('s', sopts, lhs, rhs, desc) end
function utils.omap(sopts, lhs, rhs, desc)   utils.map('o', sopts, lhs, rhs, desc) end
function utils.icmap(sopts, lhs, rhs, desc)  utils.map('!', sopts, lhs, rhs, desc) end
function utils.imap(sopts, lhs, rhs, desc)   utils.map('i', sopts, lhs, rhs, desc) end
function utils.lmap(sopts, lhs, rhs, desc)   utils.map('l', sopts, lhs, rhs, desc) end
function utils.cmap(sopts, lhs, rhs, desc)   utils.map('c', sopts, lhs, rhs, desc) end
function utils.tmap(sopts, lhs, rhs, desc)   utils.map('t', sopts, lhs, rhs, desc) end

function utils.bnvomap(bnr, sopts, lhs, rhs, desc) utils.bmap('', bnr, sopts, lhs, rhs, desc) end
function utils.bnmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('n', bnr, sopts, lhs, rhs, desc) end
function utils.bvmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('v', bnr, sopts, lhs, rhs, desc) end
function utils.bxmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('x', bnr, sopts, lhs, rhs, desc) end
function utils.bsmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('s', bnr, sopts, lhs, rhs, desc) end
function utils.bomap(bnr, sopts, lhs, rhs, desc)   utils.bmap('o', bnr, sopts, lhs, rhs, desc) end
function utils.bicmap(bnr, sopts, lhs, rhs, desc)  utils.bmap('!', bnr, sopts, lhs, rhs, desc) end
function utils.bimap(bnr, sopts, lhs, rhs, desc)   utils.bmap('i', bnr, sopts, lhs, rhs, desc) end
function utils.blmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('l', bnr, sopts, lhs, rhs, desc) end
function utils.bcmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('c', bnr, sopts, lhs, rhs, desc) end
function utils.btmap(bnr, sopts, lhs, rhs, desc)   utils.bmap('t', bnr, sopts, lhs, rhs, desc) end

return utils

