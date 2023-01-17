-- Install packer
local ensure_packer = function ()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-surround' -- Surround commands
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  use 'ap/vim-css-color'
  use 'mg979/vim-visual-multi' -- Multiple cursors
  use 'michaeljsmith/vim-indent-object'
  -- Color themes
  use 'folke/tokyonight.nvim'
  use 'gustavo-hms/garbo'
  -- use 'OmniSharp/omnisharp-vim'
  use 'kyazdani42/nvim-web-devicons'
  use 'inkarkat/vim-ReplaceWithRegister'
  use 'preservim/tagbar'
  use { -- Replaces Easymotion
    'phaazon/hop.nvim', branch = 'v1', -- optional but strongly recommended
  }
  use {
    'junegunn/fzf',
    run = ":call fzf#install()"
  }
  use 'junegunn/fzf.vim'
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use 'mjlbach/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
     run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
     ts_update()
    end,
  }
  use 'nvim-treesitter/nvim-treesitter-context'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use { -- Collection of configurations for built-in LSP client
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  -- Debug Adapter Protocol
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use "Shatur/neovim-cmake"
  -- Custom helpers
  use 'gbrlsnchs/winpick.nvim' -- Used in lua/profile/util/window_tools.lua

  if packer_bootstrap then
    require('packer').sync()
  end
end)

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
