-- Author: Nova Senco
-- Last Change: 12 March 2022

local conf = vim.fn.stdpath('config')
vim.o.rtp = conf..',/usr/share/nvim/runtime,'..conf..'/after'

local start = require'start'
start.autoqf = true

start:init()

local s,_ = pcall(require, 'plugins')
if s then
  vim.api.nvim_create_autocmd('User', {
    pattern='PackerComplete',
    callback=function()
      start:loadall{
        'lsp',
      }
      vim.cmd'syntax on'
    end
  })
end

