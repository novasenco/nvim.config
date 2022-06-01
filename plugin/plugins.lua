-- Author: Nova Senco
-- Last Change: 15 April 2022

local sync
local packer
local au = require'utils.autocmd'.build'NovaPlugins'

-- plugins {{{1
local function plugins(use)

  use { -- packer {{{2
    -- required to avoid annoyances
    'wbthomason/packer.nvim', as='packer'
  }

  use { -- closer {{{2
    '9mm/vim-closer', as='closer'
  }

  use { -- matchup {{{2
    'andymass/vim-matchup', as='matchup',
    event='VimEnter'
  }

  use { -- lspconfig {{{2
    'neovim/nvim-lspconfig', as='lspconfig',
    -- see $HOME/.config/nvim/lua/init/lsp.lua
  }

  use { -- table-mode {{{2
    'dhruvasagar/vim-table-mode', as='table-mode',
    ft={'tex'},
    opt=true
  }

  -- use { -- firenvim {{{2
  --   'glacambre/firenvim',
  --   run=function() vim.fn['firenvim#install'](0) end,
  --   opt=true,
  -- }

  -- use { -- vimtex {{{2
  --   'lervag/vimtex',
  --   ft={'tex'},
  --   tag='v1.6',
  --   opt=true
  -- }
  use { -- tex-conceal {{{2
    'KeitaNakamura/tex-conceal.vim', as='tex-conceal',
    ft={'tex'},
    opt=true
  }

  use { -- treesitter {{{2
    'nvim-treesitter/nvim-treesitter', as='treesitter',
        config=function()
          if TreesitterInstalled then return end -- in case this file re-sourced
          local ok, treecfg = pcall(require, 'nvim-treesitter.configs')
          if not ok then return end
          treecfg.setup {
            -- "all", "maintained", or a list of languages
            ensure_installed = { 'c', 'cpp', 'make', 'bash', 'html', 'css',
              'typescript', 'regex', 'json', 'json5', 'bibtex', 'haskell',
              'ocaml', 'vim', 'commonlisp', 'rasi', 'yaml', 'toml' },
            sync_install = false,
            -- ignore_install = {},
            highlight = {
              enable = true,
              -- disable = {},
              additional_vim_regex_highlighting = false,
            },
            incremental_selection = { enable = true },
            textobjects = { enable = true },
          }
          TreesitterInstalled = true
        end
      }

  use { -- playground {{{2
    'nvim-treesitter/playground',
    opt=true
  }

  -- use { -- vim-pasta {{{2
  --   'sickill/vim-pasta', as='pasta'
  -- }

  use { -- markdown {{{2
    'tpope/vim-markdown', as='markdown',
    ft={'markdown'}
  }

  use { -- repeat {{{2
    'tpope/vim-repeat', as='repeat-tpope'
  }

  use { -- replace with register {{{2
    'vim-scripts/ReplaceWithRegister' , as='replace-with-register'
  }

  use { -- tabular {{{2
    'godlygeek/tabular'
  }

  -- fzf {{{2
  use { 'junegunn/fzf' }
  use { 'junegunn/fzf.vim' }

  use { -- goyo {{{2
    'junegunn/goyo.vim', as='goyo',
        opt=true
      }

  use { -- zen-mode {{{2
    'folke/zen-mode.nvim', as='zen-mode'
  }

  use { -- sandwhich {{{2
    'machakann/vim-sandwich', as='sandwich'
  }

  use { -- vimspector {{{2
    'puremourning/vimspector',
    opt=true
  }

  use { -- exchange {{{2
    'tommcdo/vim-exchange', as='exchange'
  }

  use { -- abolish {{{2
    'tpope/vim-abolish', as='abolish',
    opt=true
  }
  use { -- commentary {{{2
    'tpope/vim-commentary', as='commentary'
  }
  use { -- fugitive {{{2
    'tpope/vim-fugitive', as='fugitive'
  }
  use { -- gv {{{2
    'junegunn/gv.vim', as='gv'
  }


  use { -- helpful {{{2
    'tweekmonster/helpful.vim', as='helpful',
    opt=true
  }

  use { -- telescope {{{2
    'nvim-telescope/telescope.nvim', as='telescope',
    opt=true,
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { -- luasnips {{{2
    'L3MON4D3/LuaSnip'
  }

  use { -- snap {{{2
    'novasenco/snap'
  }
  use { -- vimix {{{2
    'novasenco/vimix'
  }
  use { -- nokto {{{2
    'novasenco/nokto',
    config=vim.cmd'sil! colo nokto',            -- default colorscheme
    run=function() vim.cmd'sil! colo nokto' end -- :colo nokto after installed
  }
  use { -- gruvbox8
    'lifepillar/gruvbox8'
  }

  -- use { -- preserve/markdown {{{2
  --   'preservim/vim-markdown', as='preserve-markdown' }
  -- }

  -- use { -- ptppt {{{2
  --   'novasenco/ptppt.vim', as='ptppt',
  -- }

  -- }}}

  -- auto-sync {{{2
  if sync then
    packer.update()
    packer.compile()
  else
    packer.install()
  end -- }}}

end

-- auto-install and -setup {{{1

local install_path = vim.fn.stdpath('config')..'/pack/packer/start/packer'

if vim.fn.isdirectory(install_path) == 0 then
  sync = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}) and true
  -- os.execute 'git clone --depth 1 https://github.com/wbthomason/packer.nvim pack/packer/start/packer '..install_path
  -- sync = true
  vim.cmd'packadd packer'
end

packer = require'packer'

-- load colorscheme after plugins if colorscheme not yet installed {{{1
if vim.g.colors_name == 'default' then
  au('User', 'silent! colorscheme nokto', 'PackerComplete')
end

-- lsp loading failed; reload plugins loaded {{{1
if not require'lsp' then
  au('User', function()
    package.loaded.lsp = nil
    require'lsp'
  end, 'PackerComplete')
end

-- packer startup {{{1
packer.startup({
  plugins,
  config = {
    package_root = vim.fn.stdpath('config')..'/pack',
    compile_path = vim.fn.stdpath('config')..'/pack/packer_compiled.lua',
    working_sym = '↻',
    log = { level = 'fatal' },
  }
})

