
-- Servers here will be automatically installed and setup with these settings
local servers = {
  clangd = {
    'clangd',
    '--query-driver="/usr/bin/gcc,/usr/bin/g++,/usr/bin/arm-none-eabi-gcc,/usr/bin/arm-none-eabi-g*"',
  },
  omnisharp = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },

  julials = {
    julia = {
      lint = { call = false }
    }
  }
}

--- Generates a default setup table to pass to servers setup function
local function default_setup_handler(server_name)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  local lsp_bindings = require 'profile.keymaps.lsp'
  local set_lsp_keybindings = lsp_bindings.get_on_attach_fn(server_name)

  return {
    capabilities = capabilities,
    on_attach = function (client, buffnr)
      if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {})
      end
      set_lsp_keybindings(client, buffnr)
    end,
    settings = servers[server_name],
  }
end

local function mason_lspconfig_setup(_, opts)
  local mason_lspconfig = require 'mason-lspconfig'
  mason_lspconfig.setup(opts)
  mason_lspconfig.setup_handlers {
    function(server_name)
      local setup = default_setup_handler(server_name)
      require('lspconfig')[server_name].setup(setup)
    end,

    ['omnisharp'] = function ()
      local setup = default_setup_handler('omnisharp')
      setup.handles = {
        ['textDocument/definition'] = require('omnisharp_extended').handler
      }
    end,

    ['rust_analyzer'] = function ()
      local lsp_bindings = require 'profile.keymaps.lsp'
      local set_lsp_keybindings = lsp_bindings.get_on_attach_fn('rust_analyzer')
      require("rust-tools").setup {
        server = {
          on_attach = set_lsp_keybindings,
        },
        dap = {
          adapter = require('mason-nvim-dap.mappings.adapters').codelldb
        }
      }
    end
  }
end

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', opts = {} },
      {
        'williamboman/mason-lspconfig.nvim',
        opts = { ensure_installed = vim.tbl_keys(servers), },
        config = mason_lspconfig_setup,

        dependencies = {
          -- Additional lua configuration, makes nvim stuff amazing!
          { 'folke/neodev.nvim', opts = {} },
        },
      },

      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        tag = "legacy",
        event = "LspAttach",
        opts = {}
      },
    },
  },

  -- Rust tools
  'simrat39/rust-tools.nvim',

  -- Better function overload handling
  'Issafalcon/lsp-overloads.nvim',

  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    ft = 'cs',
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'L3MON4D3/LuaSnip', opts = {} },
      'saadparwaiz1/cmp_luasnip'
    },

    main = 'cmp',
    opts = function (_, opts)
      local luasnip = require 'luasnip'

      opts.snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      }

      opts.mapping = require 'profile.keymaps.completion'

      opts.sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }

      return opts
    end
  },
}
