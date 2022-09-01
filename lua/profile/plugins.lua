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

-- DAP settings
require 'profile.setups.dap'

-- Commented options are defaults
-- local Path = require('plenary.path')
require('cmake').setup({
  cmake_executable = 'cmake', -- CMake executable to run.

  save_before_build = false, -- Save all buffers before building.

  -- JSON file to store information about selected target.
  -- E.g. run arguments and build type.
  -- parameters_file = 'neovim.json',

  -- The default values in `parameters_file`.
  -- default_parameters = { run_dir = '', args = {}, build_type = 'Debug' },

  -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}`
  -- will be expanded with the corresponding text values.
  -- Could be a function that return the path to the build directory.
  -- build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')),

  -- Folder with samples.
  -- `samples` folder from the plugin directory is used by default.
  -- samples_path = tostring(script_path:parent():parent():parent() / 'samples'),

  -- Default folder for creating project.
  -- default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'Projects')),

  -- Default arguments that will be always passed at cmake configure step.
  -- By default tells cmake to generate `compile_commands.json`.
  -- configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },

  -- Default arguments that will be always passed at cmake build step.
  -- build_args = {},

  -- Callback that will be called each time data is received by the current process.
  -- Accepts the received data as an argument.
  -- on_build_output = nil,

  -- quickfix = {
  --   pos = 'botright', -- Where to open quickfix
  --   height = 10, -- Height of the opened quickfix.
  --   only_on_error = false, -- Open quickfix window only if target build failed.
  -- },

  -- Copy compile_commands.json to current working directory.
  copy_compile_commands = false,

  -- DAP configuration. By default configured to work with `lldb-vscode`.
  dap_configuration = {
    type = "cppdbg",
    request = "launch",
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },

  -- Command to run after starting DAP session.
  -- You can set it to `false` if you don't want to open anything
  dap_open_command = false,
})
