return {
  'kyazdani42/nvim-web-devicons', -- Nerd font icons

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    }
  },

  { -- Set statusbar
    'nvim-lualine/lualine.nvim', opts = {
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
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', },
    opts = {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
        },
      },
    },
    config = function (_, opts)
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup(opts)

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    end
  },

  { -- Custom helpers
    'gbrlsnchs/winpick.nvim', -- Used in lua/profile/util/window_tools.lua
    opts = function ()
      local winpick = require 'winpick'
      return {
        border = "double",
        filter = nil, -- Can be used to ignore certain windows
        prompt = "Pick a window: ",
        format_label = winpick.defaults.format_label, -- formatted as "<label>: <buffer name>"
        chars = nil,
      }
    end,
  },
}
