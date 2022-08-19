-- Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'onedark',
    theme = 'tokyonight',
    component_separators = {
      right = '',
      left = '',
      -- left = '|',
    },
    section_separators = {
      right = '',
      left = '',
    },
  },
  tabline = {
    lualine_a = { { 'tabs', mode = 1 } },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { { 'buffers', mode = 4 } }
  }
}

--Enable Comment.nvim
require('Comment').setup()

-- Setup Hop (Easymotion)
require('hop').setup()

require("nvim-lsp-installer").setup {}

-- Indent blankline
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
require('telescope').load_extension 'fzf' -- Enable telescope fzf native

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'gRN',
      scope_incremental = 'gRC',
      node_decremental = 'gRM',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- Lua plugin for creating window navigation tools
local winpick = require 'winpick'
winpick.setup {
  border = "double",
  filter = nil, -- Can be used to ignore certain windows
  prompt = "Pick a window: ",
  format_label = winpick.defaults.format_label, -- formatted as "<label>: <buffer name>"
  chars = nil,
}

-- LSP settings
require 'profile.setups.lsp'

