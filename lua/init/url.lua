-- Author: Nova Senco
-- Last Change: 07 March 2022

local m = require'mapping'

-- allow mapping <m-u>
if vim.fn.has('nvim') == 0 and vim.fn.has('gui_running') == 0 then
  vim.cmd[[ execute "set <m-u>=\<esc>u"
            execute "set <m-U>=\<esc>U" ]]
end

-- select url before cursor
m.nmap('n', '<m-U>', '<cmd>call maps#UrlSelect(0, v:count1)<cr>')
m.xmap('n', '<m-U>', '<cmd>call maps#UrlSelect(0, v:count1)<cr>')

-- select url after cursor
m.nmap('n', '<m-u>', '<cmd>call maps#UrlSelect(1, v:count1)<cr>')
m.xmap('n', '<m-u>', '<cmd>call maps#UrlSelect(1, v:count1)<cr>')

-- https://duckduckgo.com
m.nmap('n', 'gx', [[<cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]])
m.xmap('n', 'gx', '<cmd>call url#V_gx()<cr>')

m.nmap('n', 'gX', [[<cmd>call maps#GX('"'..escape(expand('<cfile>'), '\"$'))<cr>]])
m.xmap('n', 'gX', '<cmd>call maps#GX()<cr>')
