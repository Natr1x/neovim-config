-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = 'init.lua'
})

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-surround' -- Surround commands
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  use 'ap/vim-css-color'
  use 'mg979/vim-visual-multi' -- Multiple cursors
  -- Color themes
  use 'folke/tokyonight.nvim'
  use 'gustavo-hms/garbo'
  use 'OmniSharp/omnisharp-vim'
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
  use 'mjlbach/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
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
end)

-- Load options profile first
require 'profile.options'

-- Load keymaps profile but wait to set bindings til after plugins have been
-- setup so their setup does not override them.
local set_bindings = require('profile.keymaps').after_init

-- Run setup for the various plugins
require 'profile.plugins'

-- Set the keybindings from the profile
set_bindings()

-- Set the color scheme
if not COLOR_SET then -- Tokyonight breaks if you set it more than once :/
  COLOR_SET = true
  vim.cmd [[ colorscheme tokyonight ]]
end
