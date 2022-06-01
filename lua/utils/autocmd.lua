-- Author: Nova Senco
-- Last Change: 11 April 2022

local utils = {}

function utils.autocmd(evt, cmd, pat, aug)
  -- create autocmd for event `evt` using `cmd` command (lua function or ex
  -- command string) matching pattern `pat` (opt) for augroup `aug` (opt)
  --
  -- Eg: require'utils.autocmd'.autocmd('VimEnter', function() print'Entered vim' end)
  -- Eg: reuire'utils.autocmd'.autocmd('FileType', "unsil echom 'lua filetype set'", 'lua', 'MyAugroup')
  local ex, cb -- ex command or lua callback
  if type(cmd) == 'function' then cb = cmd else ex = cmd end
  vim.api.nvim_create_autocmd(evt, {group=aug, command=ex, callback=cb, pattern=pat})
  -- if evt == 'BufWinEnter,WinEnter,CmdlineLeave' then
  --   vim.cmd[[autocmd WinEnter]]
  --   -- doesn't have it in the WinEnter
  -- end
end

function utils.build(aug, skipcreate)
  -- build autocmd for augroup (auto-create if skipcreate isn't true)
  --
  -- Eg: local au = require'utils.autocmd'.build('MyAugroup')
  --     au('FileType', function() print('vim filetype set') end, 'vim')
  if not skipcreate then
    vim.api.nvim_create_augroup(aug, { clear=true })
  end
  return function(evt, cmd, pat) utils.autocmd(evt, cmd, pat, aug) end
end

return utils

