-- Author: Nova Senco
-- Last Change: 01 June 2022

local lsploaded, lspconfig = pcall(require, 'lspconfig')
if not lsploaded then return false end

local map = require'utils.map'

-- global keymaps {{{1

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map.n('ns', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>')
map.n('ns', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
map.n('ns', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
map.n('ns', '<leader>D', '<cmd>lua vim.diagnostic.setloclist()<cr>')

-- Lsp Setup {{{1

local function on_attach(_, bnr)
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer

  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local function m(l, c) map.bn(bnr, 'ns', l, '<cmd>lua '..c..'<cr>') end
  m('gD',         'vim.lsp.buf.declaration()')
  m('gd',         'vim.lsp.buf.definition()')
  m('K',          'vim.lsp.buf.hover()')
  m('gi',         'vim.lsp.buf.implementation()')
  m('<c-k>',      'vim.lsp.buf.signature_help()')
  m('<leader>wa', 'vim.lsp.buf.add_workspace_folder()')
  m('<leader>wr', 'vim.lsp.buf.remove_workspace_folder()')
  m('<leader>wl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
  m('<leader>bt', 'vim.lsp.buf.type_definition()')
  m('<leader>br',  'vim.lsp.buf.rename()')
  m('<leader>ba',  'vim.lsp.buf.code_action()')
  m('<leader>br', 'vim.lsp.buf.references()')
  m('<leader>bf', 'vim.lsp.buf.formatting()')
end

local function setup(name, cfg)
  if not cfg then cfg = {} end
  cfg.on_attach = on_attach
  lspconfig[name].setup(cfg)
end


-- c {{{2

setup'clangd'
setup'ccls'

-- lua {{{2

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

setup('sumneko_lua', {
  on_new_config = function(cfg, root)
    if root == os.getenv'HOME'..'/.config/awesome' then
      cfg.settings.Lua.diagnostics.globals = {'awesome', 'tag', 'client', 'screen'}
    elseif root == os.getenv'HOME'..'/.config/nvim' then
      cfg.settings.Lua.diagnostics.globals = {'vim'}
    end
  end,
  cmd = { os.getenv'HOME'..'/git/lua-language-server/bin/lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- globals = {'vim', 'awesome', 'tag'},
        disable = {'lowercase-global'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- vim {{{2

setup('vimls', {
  diagnostic = { enable = true },
  indexes = {
    projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
    runtimepath = true,
  },
  iskeyword = "@,48-57,_,192-255,-#",
  runtimepath = "",
  suggest = {
    fromRuntimepath = true,
    fromVimruntime = true
  },
  vimruntime = ""
})

-- }}}1

return true

