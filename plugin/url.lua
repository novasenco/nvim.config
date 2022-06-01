-- Author: Nova Senco
-- Last Change: 02 April 2022

local map = require'utils.map'

-- allow mapping <m-u>
if vim.fn.has'nvim' == 0 and vim.fn.has'gui_running' == 0 then
  vim.cmd[[ execute "set <m-u>=\<esc>u"
            execute "set <m-U>=\<esc>U" ]]
end

-- select url before cursor
map.n('n', '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>')
map.x('n', '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>')

-- select url after cursor
map.n('n', '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>')
map.x('n', '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>')

-- open url under cursor
map.n('n', 'gx', [[<cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]])
map.x('n', 'gx', '<cmd>call url#V_gx()<cr>')

map.n('n', 'gX', [[<cmd>call url#GX('"'..escape(expand('<cfile>')..'"', '\"$'))<cr>]])
map.x('n', 'gX', '<cmd>call url#GX()<cr>')

-- maybe move to maps.lua
map.n(_, '<leader>u', '<plug>(UrlNext)')
map.x(_, '<leader>u', '<plug>(UrlNext)')
map.n(_, '<leader>U', '<plug>(UrlPrev)')
map.x(_, '<leader>U', '<plug>(UrlPrev)')

