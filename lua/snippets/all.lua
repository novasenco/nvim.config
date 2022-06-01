local ls = require'luasnip'
local lsx = require'luasnip.extras'
-- local lsf = require'luasnip.extras.fmt'

local snip = ls.snippet
local part = lsx.partial

return {
  snip('date', part(os.date, '%d %B %Y')),
}
