-- Author: Nova Senco
-- Last Change: 19 March 2022

local lspconfig = require'lspconfig'
local M = require'map-utils'

-- global keymaps {{{1

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
M.nmap('ns', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>')
M.nmap('ns', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
M.nmap('ns', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
M.nmap('ns', '<leader>E', '<cmd>lua vim.diagnostic.setloclist()<cr>')

-- }}}

-- on_attach function {{{1

local function on_attach(_, bnr)
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  M.bnmap(bnr, 'ns', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<cr>')
  M.bnmap(bnr, 'ns', 'gd',         '<cmd>lua vim.lsp.buf.definition()<cr>')
  M.bnmap(bnr, 'ns', 'K',          '<cmd>lua vim.lsp.buf.hover()<cr>')
  M.bnmap(bnr, 'ns', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<cr>')
  M.bnmap(bnr, 'ns', '<c-k>',      '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  M.bnmap(bnr, 'ns', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>')
  M.bnmap(bnr, 'ns', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>')
  M.bnmap(bnr, 'ns', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>')
  M.bnmap(bnr, 'ns', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  M.bnmap(bnr, 'ns', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
  M.bnmap(bnr, 'ns', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  M.bnmap(bnr, 'ns', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>')
  M.bnmap(bnr, 'ns', '<leader>f',  '<cmd>lua vim.lsp.buf.formatting()<cr>')

end -- }}}

-- c {{{1

lspconfig.clangd.setup { on_attach = on_attach }

-- lua {{{1

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
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
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
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
}
