-- -- Install packer
-- local ensure_packer = function ()
--   local fn = vim.fn
--   local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
--   if fn.empty(fn.glob(install_path)) > 0 then
--     fn.system({
--       'git', 'clone', '--depth', '1',
--       'https://github.com/wbthomason/packer.nvim', install_path
--     })
--     vim.cmd [[packadd packer.nvim]]
--     return true
--   end
-- end
--
-- local packer_bootstrap = ensure_packer()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- require('packer').startup(function(use)
require('lazy').setup({
  'wbthomason/packer.nvim', -- Package manager
  'tpope/vim-fugitive', -- Git commands in nvim
  'tpope/vim-rhubarb', -- Fugitive-companion to interact with github
  'tpope/vim-surround', -- Surround commands
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  'ludovicchabant/vim-gutentags', -- Automatic tags management
  'ap/vim-css-color',
  'mg979/vim-visual-multi', -- Multiple cursors
  'michaeljsmith/vim-indent-object',
  -- Color themes
  'folke/tokyonight.nvim',
  'gustavo-hms/garbo',
  -- use 'OmniSharp/omnisharp-vim'
  'kyazdani42/nvim-web-devicons',
  'inkarkat/vim-ReplaceWithRegister',
  'preservim/tagbar',
  { -- Replaces Easymotion
    'phaazon/hop.nvim', branch = 'v1', -- optional but strongly recommended
  },
  {
    'junegunn/fzf',
    build = ":call fzf#install()"
  },
  'junegunn/fzf.vim',
  -- UI to select things (files, grep results, open buffers...)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      'nvim-telescope/telescope.nvim',
    }
  },
  'mjlbach/onedark.nvim', -- Theme inspired by Atom
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Add git related info in the signs columns and popups
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  'nvim-treesitter/nvim-treesitter-context',
  'nvim-treesitter/playground',
  -- Additional textobjects for treesitter
  -- use 'nvim-treesitter/nvim-treesitter-textobjects'
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion plugin
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip', -- Snippets plugin

  -- Better function overload handling
  'Issafalcon/lsp-overloads.nvim',

  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    ft = 'cs',
  },

  'folke/which-key.nvim',

  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- Installers
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    config = require('profile.setups.dap').dap_config
  },
  "Shatur/neovim-cmake",
  -- Custom helpers
  'gbrlsnchs/winpick.nvim', -- Used in lua/profile/util/window_tools.lua

  -- if packer_bootstrap then
  --   require('packer').sync()
  -- end
})

-- Load options profile first
require 'profile.options'

-- Load keymaps profile but wait to set bindings til after plugins have been
-- setup so their setup does not override them.
local set_bindings = require('profile.keymaps').after_init

-- Run setup for the various plugins
require 'profile.plugins'

-- Set up machine specific settings
require 'profile.machine_local'

-- Set the keybindings from the profile
set_bindings()

-- Setup custom autocmds
vim.cmd [[
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver20,a:blinkon500,a:blinkoff500
augroup END
]]

-- Set the color scheme
if not COLOR_SET then -- Tokyonight breaks if you set it more than once :/
  COLOR_SET = true
  vim.cmd [[ colorscheme tokyonight ]]
end
