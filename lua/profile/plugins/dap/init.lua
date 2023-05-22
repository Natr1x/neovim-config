return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    {
      'jay-babu/mason-nvim-dap.nvim',
      dev = true,
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
