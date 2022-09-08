local dap = require 'dap'

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
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

local dapui = require 'dapui'
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
return M
