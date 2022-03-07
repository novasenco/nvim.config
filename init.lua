
local start = require'start'
start.autoqf = true
start:init()

if pcall(require, 'plugins') then
  vim.api.nvim_create_autocmd('User', {
    pattern='PackerComplete',
    callback=function()
      require'lsp'
    end
  })
end

