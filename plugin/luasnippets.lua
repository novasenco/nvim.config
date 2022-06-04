
require'luasnip.loaders.from_lua'.lazy_load{paths=vim.fn.stdpath'config'..'/lua/snippets'}
local ls = require'luasnip'

ls.config.set_config({
	history = true,
	update_events = 'TextChanged,TextChangedI',
	delete_check_events = 'TextChanged',
	ext_opts = {
		[require'luasnip.util.types'.choiceNode] = {
			active = { virt_text = { { 'choiceNode', 'Comment' } }, },
		},
	},
	ext_base_prio = 300,
	ext_prio_increase = 1,
	enable_autosnippets = true,
	store_selection_keys = '<m-l>',
})

-- local fd = vim.loop.fs_opendir(vim.fn.stdpath'config'..'/lua/snippets')
-- local fs = vim.loop.fs_readdir(fd)
-- while fs do
--   for _,f in ipairs(fs) do
--     local ft = f.name:match'%w+.lua$'
--     if ft and f.type == 'file' then
--       ft = ft:sub(1, #ft-4)
--       local p = 'snippets.'..ft
--       package.loaded[p] = nil
--       local s,t = pcall(require, p)
--       if s then
--         if type(t) == 'table' then
--           ls.add_snippets(ft, t, {key=ft})
--         end
--       else
--         print(t)
--       end
--     end
--   end
--   fs = vim.loop.fs_readdir(fd)
-- end

