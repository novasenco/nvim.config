-- Author: Nova Senco
-- Last Change: 19 March 2022

local conf = vim.fn.stdpath('config')
vim.o.rtp = conf..',/usr/share/nvim/runtime,'..conf..'/after'
vim.cmd'sil! colo nokto-init'

local start = require'start'.config{ autoqf=true }

start.init() -- load /lua/init/*.lua

local s,_ = pcall(require, 'plugins')
if s then
  vim.api.nvim_create_autocmd('User', {
    pattern='PackerComplete',
    callback=function()
      start.loadall{
        'lsp',
      }
      vim.cmd'syntax on'
    end
  })
end

