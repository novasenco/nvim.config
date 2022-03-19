-- Author: Nova Senco
-- Last Change: 19 March 2022

local M = require'map-utils'

-- allow mapping <m-u>
if vim.fn.has'nvim' == 0 and vim.fn.has'gui_running' == 0 then
  vim.cmd[[ execute "set <m-u>=\<esc>u"
            execute "set <m-U>=\<esc>U" ]]
end

-- select url before cursor
M.nmap('n', '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>')
M.xmap('n', '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>')

-- select url after cursor
M.nmap('n', '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>')
M.xmap('n', '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>')

-- open url under cursor
M.nmap('n', 'gx', [[<cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]])
M.xmap('n', 'gx', '<cmd>call url#V_gx()<cr>')

M.nmap('n', 'gX', [[<cmd>call url#GX('"'..escape(expand('<cfile>')..'"', '\"$'))<cr>]])
M.xmap('n', 'gX', '<cmd>call url#GX()<cr>')

-- maybe move to maps.lua
M.nmap(_, '<leader>u', '<plug>(UrlNext)')
M.xmap(_, '<leader>u', '<plug>(UrlNext)')
M.nmap(_, '<leader>U', '<plug>(UrlPrev)')
M.xmap(_, '<leader>U', '<plug>(UrlPrev)')

