local bind = require('profile.util.keybinder').bind

local function default_attach(_, bufnr)
  local wk = require 'which-key'
  local function nmap(keys, func, desc)
    return { 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc } }
  end

  wk.register({
    ['<LocalLeader>w'] = { name = '+workspace' },
    ['<LocalLeader>c'] = { name = '+code' },
    ['<LocalLeader>r'] = { name = '+refactor' },
    ['<LocalLeader>s'] = { name = '+lspsearch' },
  })

  bind {
    {
      tbl = { vim.lsp.buf, 'vim.lsp.buf' },
      nmap('gD',               'declaration',             '[g]oto [D]eclaration'),
      nmap('<LocalLeader>h',   'hover',                   '[h]over Documentation'),
      nmap('<C-k><C-i>',       'hover',                   'Hover Documentation'),
      nmap('K',                'hover',                   'Hover Documentation'),
      nmap('<C-k><C-k>',       'signature_help',          'Signature Documentation'),
      nmap('<LocalLeader>rn',  'rename',                  '[r]e[n]ame'),
      nmap('<LocalLeader>ca',  'code_action',             '[c]ode [a]ction'),
      nmap('<LocalLeader>wa',  'add_workspace_folder',    '[w]orkspace [a]dd Folder'),
      nmap('<LocalLeader>wr',  'remove_workspace_folder', '[w]orkspace [r]emove folder'),

      -- Uncomment these if telescope is not working
      -- nmap('gd',               'definition',              '[g]oto [d]efinition'),
      -- nmap('gi',               'implementation',          '[g]oto [i]mplementation'),
      -- nmap('<LocalLeader>D',   'type_definition',         'Type [D]efinition'),
    },
    {
      nmap('<LocalLeader>wl', function()
        print ( vim.inspect( vim.lsp.buf.list_workspace_folders() ) )
      end, '[w]orkspace [l]ist folders')
    },
    {
      module = 'telescope.builtin',
      nmap('gR',              'lsp_references',        'search [R]eferences'),
      nmap('<LocalLeader>sr', 'lsp_references',        '[s]earch [r]eferences'),
      nmap('gd',              'lsp_definitions',       '[g]oto [d]efinition'),
      nmap('<LocalLeader>sd', 'lsp_definitions',       '[s]earch [d]efinitions'),
      nmap('<LocalLeader>sD', 'diagnostics',           '[s]earch [d]iagnostics'),
      nmap('<LocalLeader>sc', 'lsp_incoming_calls',    '[s]earch incoming [c]alls'),
      nmap('<LocalLeader>sC', 'lsp_outgoing_calls',    '[s]earch outgoing [C]alls'),
      nmap('gi',              'lsp_implementations',   '[g]oto [i]mplementation'),
      nmap('<LocalLeader>si', 'lsp_implementations',   '[s]earch [i]mplementations'),
      nmap('<LocalLeader>so', 'lsp_document_symbols',  '[s]earch document symb[o]ls' ),
      nmap('<LocalLeader>D',  'lsp_type_definitions',  'search Type [D]efinitions'),
      nmap('<LocalLeader>st', 'lsp_type_definitions',  '[s]earch [t]ype definitions'),
      nmap('<LocalLeader>sw', 'lsp_workspace_symbols', '[s]earch [w]orkspace symbols' ),
      nmap('<LocalLeader>sW', 'lsp_dynamic_workspace_symbols', '[s]earch dynamic [W]orkspace symbols'),
    }
  }

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local function c_and_cpp(client, bufnr)
  default_attach(client, bufnr)

  bind {
    {
      { {'n', 'o', 'v'}, '<M-o>', ':ClangdSwitchSourceHeader<cr>',
        { silent = true, desc = 'LSP: Switch to header / source' } },
    },
  }
end

local specific_attach = {
  c = c_and_cpp,
  cpp = c_and_cpp,
  clangd = c_and_cpp,
  ['rust_analyzer'] = function (client, bufnr)
    default_attach(client, bufnr)
  end
}

local M = {}

function M.get_on_attach_fn(server_name)
  return specific_attach[server_name] or default_attach
end

return M

