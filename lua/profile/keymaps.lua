local bind = require('profile.util.keybinder')

local M = {}

-- Not sure why I do this but there was probably a reason
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local dap_bindings = {
  {
    'n', '<LocalLeader>db',  ':DapToggleBreakpoint<cr>',
    { silent = true, desc = 'Toggle [d]ebug [b]reakpoint' }
  },
  {
    'n', '<LocalLeader>dc',  ':DapContinue<cr>',
    { silent = true, desc = '[debug] [c]ontinue' }
  },
  {
    'n', '<LocalLeader>dsi',  ':DapStepInto<cr>',
    { silent = true, desc = '[d]ebug [s]tep [i]nto' }
  },
  {
    'n', '<LocalLeader>dso',  ':DapStepOver<cr>',
    { silent = true, desc = '[d]ebug [s]tep [o]ver' }
  },
  {
    'n', '<LocalLeader>dsO',  ':DapStepOut<cr>',
    { silent = true, desc = '[d]ebug [s]tep [O]ut' }
  },
}

-- TODO: Setup dap binding for this "dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')"

M.dap_bindings = dap_bindings

local function c_and_cpp()
  bind {
    {
      { {'n', 'o', 'v'}, '<M-o>', ':ClangdSwitchSourceHeader<cr>',
        { silent = true, desc = 'Switch to header / source' } },
    },
    dap_bindings
  }
end

M.ft_specific = {
  c = c_and_cpp,
  cpp = c_and_cpp,
}

M.after_init = function ()
  bind {
    {
      -- Remap for dealing with word wrap
      { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
      { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

      -- Keybindings for Hop (Easymotion)
      {
        {'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>',
        { silent = true, desc = 'Hop to [w]ord', }
      },
      {
        {'n', 'o', 'v'}, '<leader>b', ':HopWordBC<cr>',
        { silent = true, desc = 'Hop to word [b]ackwards', }
      },
      {
        {'n', 'o', 'v'}, '<leader>k', ':HopLineStartBC<cr>',
        { silent = true, desc = '[k] Hop lines Upwards', }
      },
      {
        {'n', 'o', 'v'}, '<leader>j', ':HopLineStartAC<cr>',
        { silent = true, desc = '[j] Hop lines Downwards', }
      },
      {
        {'n', 'o', 'v'}, '<leader>f', ':HopChar1AC<cr>',
        { silent = true, desc = 'Hop to [f]ind forwards', }
      },
      {
        {'n', 'o', 'v'}, '<leader>F', ':HopChar1BC<cr>',
        { silent = true, desc = 'Hop to [F]ind backwards', }
      },
      {
        {'n', 'o', 'v'}, '<leader>/', ':HopPatternMW<cr>',
        { silent = true, desc = '[/] Hop to pattern', }
      },

      -- Keybindings for Vista / Tagbar
      { 'n', '<F8>', ':TagbarToggle<cr>', { silent = true, desc = 'Toggle Tagbar' } },
      { 'i', '<F8>', '<Esc>:TagbarToggle<cr>', { silent = true, desc = 'Toggle Tagbar' } },

      -- Escape from terminal emulator
      { 't', '<C-o><C-o>', '<C-\\><C-N>', { desc = 'Enter normal mode from terminal' } },
    },

    { -- Keybindings for Telescope
      module = 'telescope.builtin',
      { 'n', '<leader>?',       'oldfiles', { desc = '[?] Find recently opened files' } },
      { 'n', '<leader><space>', 'buffers', { desc = '[ ] Find existing buffers' } },
      { 'n', '<leader>sf',      'find_files', { desc = '[s]earch [f]iles' } },
      { 'n', '<leader>sb',      'current_buffer_fuzzy_find', { desc = '[s]earch current [b]uffer' } },
      { 'n', '<leader>sh',      'help_tags', { desc = '[s]earch [h]elp' }  },
      { 'n', '<leader>sw',      'grep_string', { desc = '[s]earch current [w]ord' } },
      { 'n', '<leader>sg',      'live_grep', { desc = '[s]earch by [g]rep' } },
      { 'n', '<leader>sd',      'diagnostics', { desc = '[s]earch [d]iagnostics' } },
      { 'n', '<leader>st',      'tags', { desc = '[s]earch all [t]ags' } },
      { 'n', '<leader>so',      'tags', { desc = '[s]earch symb[o]ls in current buffer' },
        args = { { only_current_buffer = true } },
      },
    },

    -- Keybindings for telescope extensions
    {
      tbl = {
        function ()
          return require('telescope').extensions.file_browser
        end, "telescope-file-browser"
      },
      { 'n', '<leader>e', 'file_browser', { desc = '[e]xplore file directory' },
        args = { { path = "%:p:h" } } }
    },

    { -- Diagnostic keymaps
      tbl = { vim.diagnostic, 'vim.diagnostic' },
      { 'n', '<LocalLeader>e',  'open_float', { desc = "Open floating diagnostic message" } },
      { 'n', '[d',              'goto_prev', { desc = "Go to previous diagnostic message" } },
      { 'n', ']d',              'goto_next', { desc = "Go to next diagnostic message" } },
      { 'n', '<LocalLeader>q',  'setloclist', { desc = "Open diagnostics list" } },
    },

    { -- Custom tool for navigating and reorganising windows
      module = 'profile.util.window_tools',
      { {'n', 'o', 'v' }, '<leader>g', 'move_to', { desc = '[g]o to window' } },
      { {'n', 'o', 'v' }, '<leader>T', 'transpose',
        {
          desc = '[T]rade window (swap location and size with another window)'
        }
      },
      { {'n', 'o', 'v' }, '<leader>t', 'transpose',
        {
          desc = '[t]ranspose window (swap location and size then move to another window)'
        },
        args = { true } }
    }
  }
end

M.lsp_on_attach = function (_, bufnr)
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

return M

-- vim: ts=2 sts=2 sw=2 et
