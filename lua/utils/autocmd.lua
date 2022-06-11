-- Author: Nova Senco
-- Last Change: 06 June 2022

local utils = {}

function utils.autocmd(evt, cmd, pat, aug)
  -- create autocmd for event `evt` using `cmd` command (lua function or ex
  -- command string) matching pattern `pat` (opt) for augroup `aug` (opt). I
  -- recommend using utils.build to more easily store in an augroup.
  --
  -- Eg: require'utils.autocmd'.autocmd('FileType', function()
  --       print('lua filetype set')
  --     end, 'lua', 'MyAugroup')
  --
  --     This is the same as this vim-script:
  --        :autocmd MyAugroup FileType lua unsilent echom 'lua filetype set'
  --
  -- `evt`:
  --    autocmd group as a string or table; eg: 'FileType'; if it is a string
  --    and has a comma, it will be split on commas into a table for
  --    nvim_create_autocmd()
  --
  -- `cmd`:
  --    ex command as a strnig or callback as a lua function
  --
  -- `pat` (optional):
  --    the autocmd pattern; egs: 'lua', '*.lua', etc
  --
  -- `aug` (optional):
  --    the augroup with which to associate this autocmd

  local ex, cb -- ex command or lua callback
  if type(cmd) == 'function' then cb = cmd else ex = cmd end
  if type(evt) == 'string' and evt:match',' then
    local evts = evt
    evt = {}
    for e in evts:gmatch'[^,]+' do
      evt[#evt + 1] = e
    end
  end
  vim.api.nvim_create_autocmd(evt, {group=aug, command=ex, callback=cb, pattern=pat})
end

function utils.build(aug, skipcreate)
  -- build autocmd for augroup (auto-create if skipcreate isn't true)
  --
  -- Eg: local au = require'utils.autocmd'.build('MyAugroup')
  --     au('FileType', function() print('vim filetype set') end, 'vim')
  --
  --     This is the same as the following vim-script:
  --        augroup MyAugroup
  --          autocmd!
  --          autocmd FileType vim unsilent echo 'vim filetype set'
  --        augroup end

  if not skipcreate then
    vim.api.nvim_create_augroup(aug, { clear=true })
  end
  return function(evt, cmd, pat) utils.autocmd(evt, cmd, pat, aug) end
end

return utils

