-- LSP, and completion setups

-- local lspconfig = require 'lspconfig'

-- nvim-cmp supports additional completion capabilities
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
-- -- Enable the following language servers
-- local servers = {
--   'rust_analyzer',
--   'pyright',
--   'tsserver',
--   'vimls'
-- }
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--   }
-- end
--
-- local omnisharp_bin = '/home/osksod/tools/omnisharp/Omnisharp'
--
-- lspconfig.omnisharp.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = {
--     omnisharp_bin,
--   }
-- }
--
-- lspconfig.clangd.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   cmd = {
--     'clangd',
--     '--query-driver="/usr/bin/gcc,/usr/bin/g++,/usr/bin/arm-none-eabi-gcc,/usr/bin/arm-none-eabi-g*"',
--   }
-- }
--
-- -- Example custom server
-- -- Make runtime files discoverable to the server
-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, 'lua/?.lua')
-- table.insert(runtime_path, 'lua/?/init.lua')
--
-- lspconfig.sumneko_lua.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--         -- Setup your lua path
--         path = runtime_path,
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { 'vim' },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file('', true),
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

local set_lsp_keybindings = require('profile.keymaps').lsp_on_attach

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
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
}
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local setup = {
      capabilities = capabilities,
      on_attach = function (client, buffnr)
        if client.server_capabilities.signatureHelpProvider then
          require('lsp-overloads').setup(client, {})
        end
        set_lsp_keybindings(client, buffnr)
      end,
      settings = servers[server_name],
    }
    if server_name == 'omnisharp' then
      setup.handles = {
        ['textDocument/definition'] = require('omnisharp_extended').handler
      }
    end
    require('lspconfig')[server_name].setup(setup)
  end,
}

-- nvim-cmp setup with luasnip setup
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

