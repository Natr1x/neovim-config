
-- This is only here because I could not get the doxygen's 'field'
-- to work with multiline descriptions.
---@class CppDebugSettings
local cppdbg_settings = {
  ---@type "string"
  ---Absolute path to extension/debugAdapters/bin/OpenDebugAD7 in 
  ---vscode-cpptools from https://github.com/microsoft/vscode-cpptools/release
  vscode_cpptools_path = nil,

  ---@type "string"
  vscode_cortex_debug_path = nil,
}

local function dap_config()
  local dap = require 'dap'
  local dapui = require 'dapui'

  require('mason-nvim-dap').setup {
    automatic_setup = true,
  }

  require('mason-nvim-dap').setup_handlers()

  local bind = require('profile.util.keybinder')
  bind {
    require('profile.keymaps').dap_bindings,
  }

  -- Dap UI setup
  -- For more information, see |:help nvim-dap-ui|
  dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
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
  }

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close
end

local M = {
  ---@brief Table with Debug Adapter Protocol specific settings.
  ---
  ---These are intended to be set in lua/profile/machine_local.lua
  settings = {
    ---@brief Specifies settings for cppdbg using vscode-cpptools.
    ---Intended to be set in lua/profile/machine_local.lua
    ---
    ---@param settings CppDebugSettings
    cppdbg = function (settings)
      local dap = require 'dap'

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = settings.vscode_cpptools_path
      }

      dap.adapters['cortex-debug'] = {
        id = 'cortex-debug',
        type = 'executable',
        command = 'node',
        args = { settings.vscode_cortex_debug_path },
      }
    end
  },
  ---@brief 'config' to use for the dap plugin
  dap_config = dap_config,
}
return M
