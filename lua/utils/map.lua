-- Author: Nova Senco
-- Last Change: 03 April 2022

local utils = {}

function utils.map(mode, sopts, lhs, rhs, desc)
  -- map function
  -- Eg: map('n', 'sne', '<leader>s', [[':vimgrep! "'.escape(expand('<cword>'), '\"').'"<cr>:copen<cr>']])
  -- Equiavlent: nnoremap <silent> <expr> ':vimgrep! "'.escape(expand('<cword>'), '\"').'"<cr>:copen<cr>'
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

local maps = {['!']='ic', ['']='nvo'}
setmetatable(maps, {__index=function(_,x) return x end})
local modes = 'nvxso!ilct'
for i = 0, #modes do
  local mode = modes:sub(i, i)
  utils[maps[mode]]      = function(sopts, lhs, rhs, desc) utils.map(mode, sopts, lhs, rhs, desc)  end
  utils['b'..maps[mode]] = function(sopts, lhs, rhs, desc) utils.bmap(mode, sopts, lhs, rhs, desc) end
end

return utils

