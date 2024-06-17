return {
  'jay-babu/mason-nvim-dap.nvim',
  opts = {
    automatic_setup = true,
    handlers = {
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      function(config)
        require('mason-nvim-dap').default_setup(config)
        require 'profile.keymaps.dap'
      end
    }
  },

  dependencies = {
    {
      'mfussenegger/nvim-dap',

      config = function(_, _)
        local dap = require('dap')
        dap.adapters.probe_rs = {
          type = 'server',
          port = '${port}',
          id = 'probe-rs-debug',
          executable = {
            command = '~/.cargo/bin/probe-rs',
            args = { 'dap-server', '--port', '${port}' }
          }
        }

        dap.adapters["arm-none-eabi-gdb"] = {
          type = 'executable',
          command = 'arm-none-eabi-gdb',
          args = { '-i', 'dap' }
        }

        dap.configurations.c = {
          {
            name = "Attach to Server",
            type = "arm-none-eabi-gdb",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          },
          {
            name = "Launch file cppdbg",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
          },
        }
      end,
    },

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
}
