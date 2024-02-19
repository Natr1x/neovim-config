return {
  'mfussenegger/nvim-dap',

  config = function (_, _)
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
      args = {}
    }
  end,

  dependencies = {
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    {
      'jay-babu/mason-nvim-dap.nvim',
      opts = {
        automatic_setup = true,
        handlers = {
          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          function (config)
            require('mason-nvim-dap').default_setup(config)
            require 'profile.keymaps.dap'
          end
        }
      }
    },

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
}
