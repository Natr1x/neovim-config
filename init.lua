
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

require('lazy').setup({
  'tpope/vim-surround', -- Surround commands
  'tpope/vim-sleuth',   -- Detect tabstop and shiftwidth

  { 'folke/which-key.nvim', opts = {}, },

  { 'numToStr/Comment.nvim', opts = {} }, -- "gc" to comment visual regions/lines

  'ludovicchabant/vim-gutentags', -- Automatic tags management
  'ap/vim-css-color',
  'mg979/vim-visual-multi', -- Multiple cursors
  'michaeljsmith/vim-indent-object',

  -- Color themes
  'folke/tokyonight.nvim',

  'inkarkat/vim-ReplaceWithRegister',
  'preservim/tagbar',

  { -- Replaces Easymotion
    'phaazon/hop.nvim',
    opts = {},
    branch = 'v1', -- optional but strongly recommended
  },

  { -- Adds a number of commands using fzf
    'junegunn/fzf.vim',
    dependencies = {
      'junegunn/fzf', -- Sets up fzf on the system
      build = ":call fzf#install()"
    },
  },

  -- Merges the modules as if the were written in this object
  { import = 'profile.plugins' },

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
-- require 'profile.plugins'

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
