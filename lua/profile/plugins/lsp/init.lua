
-- Servers here will be automatically installed and setup with these settings
local servers = {
  clangd = {
    arguments = {
      '--query-driver="/usr/bin/gcc,/usr/bin/g++,/usr/bin/arm-none-eabi-gcc,/usr/bin/arm-none-eabi-g*,/opt/st/stm32cubeide_1.13.2/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.11.3.rel1.linux64_1.1.1.202309131626/tools/bin/arm-none-eabi-gcc,/usr/bin/arm-none-eabi-g*,/opt/st/stm32cubeide_1.13.2/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.11.3.rel1.linux64_1.1.1.202309131626/tools/bin/arm-none-eabi-g++,/usr/bin/avr-gcc"',
    },
  },
  -- omnisharp = {},
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

  -- julials = {
  --   julia = {
  --     lint = { call = false }
  --   }
  -- }

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

      -- local lsp_bindings = require 'profile.keymaps.lsp'
      -- local set_lsp_keybindings = lsp_bindings.get_on_attach_fn('rust_analyzer')
      -- require("rust-tools").setup {
      --   server = {
      --     on_attach = set_lsp_keybindings,
      --   },
      --   dap = {
      --     adapter = require('mason-nvim-dap.mappings.adapters').codelldb
      --   }
      -- }

    end

  }
end

vim.g.rustaceanvim = function ()
  local lsp_bindings = require 'profile.keymaps.lsp'
  local set_lsp_keybindings = lsp_bindings.get_on_attach_fn('rust_analyzer')
  return {
    -- Plugin configuration
    -- tools = {
    -- },
    -- LSP configuration
    server = {
      on_attach = set_lsp_keybindings,
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
          completion = {
            postfix = {
              enable = false,
            },
            autoimport = {
              enable = false,
            },
            callable = {
              snippets = "none",
            },
          },
        },
      },
    },
    -- DAP configuration
    -- dap = {
    -- },
  }
end


return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', opts = {} },
      -- {
      --   'williamboman/mason-lspconfig.nvim',
      --   opts = { ensure_installed = vim.tbl_keys(servers), },
      --   config = mason_lspconfig_setup,
      --
      --   dependencies = {
      --     -- Additional lua configuration, makes nvim stuff amazing!
      --     { 'folke/neodev.nvim', opts = {} },
      --   },
      -- },

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
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },

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
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        -- build = "nmake install_jsregexp"  -- Disable this for now.
      },
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
