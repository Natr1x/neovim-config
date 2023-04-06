return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    { 'jay-babu/mason-nvim-dap.nvim', opts = { automatic_setup = true, } },

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },

  config = function()
    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    require('mason-nvim-dap').setup_handlers()

    require 'profile.keymaps.dap'

    -- Install golang specific config
    -- require('dap-go').setup()
  end,
}
