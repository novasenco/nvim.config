-- Author: Nova Senco
-- Last Change: 05 June 2022

local map = require'utils.map'.set

-- allow mapping <m-u>
if vim.fn.has'nvim' == 0 and vim.fn.has'gui_running' == 0 then
  vim.cmd[[ execute "set <m-u>=\<esc>u"
            execute "set <m-U>=\<esc>U" ]]
end

-- select url before cursor
map('nx', '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>', 'n')

-- select url after cursor
map('nx', '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>', 'n')

-- open url under cursor
map('n', 'gx', [[<cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]], 'n')
map('x', 'gx', '<cmd>call url#V_gx()<cr>', 'n')

map('n', 'gX', [[<cmd>call url#GX('"'..escape(expand('<cfile>')..'"', '\"$'))<cr>]], 'n')
map('x', 'gX', '<cmd>call url#GX()<cr>', 'n')

-- maybe move to maps.lua
map('nx', '<leader>u', '<plug>(UrlNext)', nil)
map('nx', '<leader>U', '<plug>(UrlPrev)', nil)

