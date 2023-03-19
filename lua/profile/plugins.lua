---@class Highlight
---@field fg string|nil
---@field bg string|nil
---@field sp string|nil
---@field style string|nil

-- Setup the tokyonight theme
require("tokyonight").setup({
  style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value `:help attr-list`
    comments = "NONE",
    keywords = "italic",
    functions = "NONE",
    variables = "NONE",
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },

  -- Set a darker background on sidebar-like windows.
  -- For example: `["qf", "vista_kind", "terminal", "packer"]`
  sidebars = { "vista_kind", "tagbar", "packer" },

  -- Adjusts the brightness of the colors of the **Day** style.
  -- Number between 0 and 1, from dull to vibrant colors
  day_brightness = 0.3,

  -- Hide inactive statuslines and replace them with a thin border instead.
  -- Should work with the standard **StatusLine** and **LuaLine**.
  hide_inactive_statusline = false,
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- fucntion will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors)
    colors.comment = '#4b8e44'
  end,

  --- You can override specific highlights to use other groups or a hex color
  --- fucntion will be called with a Highlights and ColorScheme table
  ---@param highlights table<string, Highlight>
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    highlights.TreesitterContextLineNumber = { fg = 'red', bg = colors.bg_dark }
    highlights.lualine_tabs_inactive = { bg = colors.bg_dark, fg = colors.fg_gutter }
    highlights.lualine_c_inactive = { fg = 'red' }
  end,
})

-- local theme = require'lualine.themes.tokyonight'


-- Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    -- theme = theme,
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
    lualine_a = {
      {
        'tabs',
        mode = 1,
        tabs_color = { active = {}, inactive = 'lualine_tabs_inactive' }
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'buffers',
        mode = 4,
        buffers_color = { active = {}, inactive = 'lualine_tabs_inactive' }
      }
    }
  },
  extensions = { 'quickfix', 'fugitive', 'nvim-dap-ui' },
}

--Enable Comment.nvim
require('Comment').setup()

-- Setup Hop (Easymotion)
require('hop').setup()

-- require("nvim-lsp-installer").setup {}

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
local fb_actions = require('telescope').extensions.file_browser.actions
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    file_browser = {
      mappings = {
        n = {
          ['c'] = {
            fb_actions.create,
            type = "action",
            opts = { nowait = true }
          }
        }
      }
    },
  },
}
-- Enable telescope fzf native
require('telescope').load_extension 'fzf'
-- Telescope file browser
require('telescope').load_extension 'file_browser'

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
    enable = false,
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
local Path = require('plenary.path')
local CMakeProjectConfig = require 'cmake.project_config'
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
  build_dir = tostring(Path:new('{cwd}', 'build')),

  -- Folder with samples.
  -- `samples` folder from the plugin directory is used by default.
  -- samples_path = tostring(script_path:parent():parent():parent() / 'samples'),

  -- Default folder for creating project.
  default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'labb')),

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

  -- DAP configuration.
  dap_configurations = {
    cppdbg = {
      type = "cppdbg",
      request = "launch",
      stopAtEntry = true,
    },
    windows_gdb_from_wsl = {
      type = 'cppdbg',
      request = 'launch',
      stopAtEntry = true,
      MIMode = 'gdb',
      miDebuggerServerAddress = function ()
        local host = vim.fn.systemlist({'grep', '-Po', '(?<=^nameserver )[\\.\\d]+', '/etc/resolv.conf'})
        return host[1] .. ':3333'
      end,
      miDebuggerPath = '/usr/bin/gdb-multiarch',
      miDebuggerArgs = '-exec load',
    },
    pico_debug = {
      type = 'cortex-debug',
      request = 'launch',
      servertype = 'openocd',
      runToMain = true,
      device = 'RP2040',
      postRestartCommands = {
        'break main',
        'continue'
      },
      configFiles = {
        'interface/picoprobe.cfg',
        'target/rp2040.cfg'
      },
      executable = function ()
        local project_config = CMakeProjectConfig.new()
        local _, target, _ = project_config:get_current_target()
        return target and target.filename
      end,
      -- @TODO: Set paths in a relative way
      gdbPath = '/mnt/c/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/11.2 2022.02/bin/arm-none-eabi-gdb.exe',
      svdFile = '/home/osksod/documents/nep-projects/lightlab/liquinex/external/pico-sdk/src/rp2040/hardware_regs/rp2040.svd',
      searchDir = {
        '/mnt/c/Users/osksod/Documents/tools/pico-tools/openocd-branch-rp2040-f8w14ec-windows/tcl'
      }
    }
  },
  dap_configuration = 'cppdbg_vscode',

  -- Command to run after starting DAP session.
  -- You can set it to `false` if you don't want to open anything
  dap_open_command = false,
})
