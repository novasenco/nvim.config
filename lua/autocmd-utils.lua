-- Author: Nova Senco
-- Last Change: 18 March 2022

local utils = {}

function utils.autocmd(evt, cmd, pat, aug)
  -- create autocmd for event `evt` using `cmd` command (lua function or ex
  -- command string) matching pattern `pat` (opt) for augroup `aug` (opt)
  local ex, cb -- ex command or lua callback
  if type(cmd) == 'function' then cb = cmd else ex = cmd end
  vim.api.nvim_create_autocmd(evt, {group=aug, command=ex, callback=cb, pattern=pat})
end

function utils.build_autocmd(aug, skipcreate)
  -- build autocmd for augroup (auto-create if skipcreate isn't true)
  if not skipcreate then
    vim.api.nvim_create_augroup(aug, { clear=true })
  end
  return function(evt, cmd, pat) utils.autocmd(evt, cmd, pat, aug) end
end

return utils

