local bind = require('profile.util.keybinder')

local function default_attach(_, bufnr)
  local function nmap(keys, func, desc)
    return { 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc } }
  end

  bind {
    {
      tbl = { vim.lsp.buf, 'vim.lsp.buf' },
      nmap('gD',               'declaration',             '[g]oto [D]eclaration'),
      nmap('gd',               'definition',              '[g]oto [d]efinition'),
      nmap('<LocalLeader>h',   'hover',                   '[h]over Documentation'),
      nmap('<C-k><C-i>',       'hover',                   'Hover Documentation'),
      nmap('gi',               'implementation',          '[g]oto [i]mplementation'),
      nmap('<C-k><C-k>',       'signature_help',          'Signature Documentation'),
      nmap('<LocalLeader>D',   'type_definition',         'Type [D]efinition'),
      nmap('<LocalLeader>rn',  'rename',                  '[r]e[n]ame'),
      nmap('<LocalLeader>ca',  'code_action',             '[c]ode [a]ction'),
      nmap('<LocalLeader>wa',  'add_workspace_folder',    '[w]orkspace [a]dd Folder'),
      nmap('<LocalLeader>wr',  'remove_workspace_folder', '[w]orkspace [r]emove folder'),
    },
    {
      nmap('<LocalLeader>wl', function()
        print ( vim.inspect( vim.lsp.buf.list_workspace_folders() ) )
      end, '[w]orkspace [l]ist folders')
    },
    {
      module = 'telescope.builtin',
      nmap('gR',              'lsp_references',        'search [R]eferences'),
      nmap('<LocalLeader>so', 'lsp_document_symbols',  '[s]earch document symb[o]ls' ),
      nmap('<LocalLeader>sO', 'lsp_workspace_symbols', '[s]earch workspace symb[o]ls' ),
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
}

local M = {}

function M.get_on_attach_fn(server_name)
  return specific_attach[server_name] or default_attach
end

return M

