local bind = require('profile.util.keybinder')

local M = {}

--Remap space as leader key, done here so plugins can be made aware
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local dap_bindings = {
  { 'n', '<LocalLeader>db',  ':DapToggleBreakpoint<cr>', { silent = true } },
  { 'n', '<LocalLeader>dc',  ':DapContinue<cr>', { silent = true } },
  { 'n', '<LocalLeader>dsi',  ':DapStepInto<cr>', { silent = true } },
  { 'n', '<LocalLeader>dso',  ':DapStepOver<cr>', { silent = true } },
  { 'n', '<LocalLeader>dsO',  ':DapStepOut<cr>', { silent = true } },
}

local function c_and_cpp()
  bind {
    {
      { {'n', 'o', 'v'}, '<M-o>', ':ClangdSwitchSourceHeader<cr>', { silent = true } },
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
    { -- Remap for dealing with word wrap
      { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
      { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },
      -- Keybindings for Hop (Easymotion)
      { {'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>' },
      { {'n', 'o', 'v'}, '<leader>b', ':HopWordBC<cr>' },
      { {'n', 'o', 'v'}, '<leader>k', ':HopLineStartBC<cr>' },
      { {'n', 'o', 'v'}, '<leader>j', ':HopLineStartAC<cr>' },
      { {'n', 'o', 'v'}, '<leader>f', ':HopChar1AC<cr>' },
      { {'n', 'o', 'v'}, '<leader>F', ':HopChar1BC<cr>' },
      { {'n', 'o', 'v'}, '<leader>/', ':HopPatternMW<cr>' },
      -- Keybindings for Vista / Tagbar
      { 'n', '<F8>', ':TagbarToggle<cr>', { silent = true } },
      { 'i', '<F8>', '<Esc>:TagbarToggle<cr>', { silent = true } },
      -- Escape from terminal emulator
      { 't', '<C-o><C-o>', '<C-\\><C-N>' },
    },
    { -- Keybindings for Telescope
      module = 'telescope.builtin',
      { 'n', '<leader><space>', 'buffers' },
      { 'n', '<leader>sf',      'find_files' },
      { 'n', '<leader>sb',      'current_buffer_fuzzy_find' },
      { 'n', '<leader>sh',      'help_tags' },
      { 'n', '<leader>st',      'tags' },
      { 'n', '<leader>sd',      'grep_string' },
      { 'n', '<leader>sp',      'live_grep' },
      { 'n', '<leader>so',      'tags', args = { { only_current_buffer = true } } },
      { 'n', '<leader>?',       'oldfiles' },
    },
    { -- Diagnostic keymaps
      tbl = { vim.diagnostic, 'vim.diagnostic' },
      { 'n', '<LocalLeader>e',  'open_float' },
      { 'n', '[d',              'goto_prev' },
      { 'n', ']d',              'goto_next' },
      { 'n', '<LocalLeader>q',  'setloclist' },
    },
    {
      module = 'profile.util.window_tools',
      { {'n', 'o', 'v' }, '<leader>g', 'move_to' },
      { {'n', 'o', 'v' }, '<leader>T', 'transpose' },
      { {'n', 'o', 'v' }, '<leader>t', 'transpose', args = { true } }
    }
  }
end
M.lsp_on_attach = function (_, bufnr)
  local opts = { buffer = bufnr }
  bind {
    {
      tbl = { vim.lsp.buf, 'vim.lsp.buf' },
      { 'n', 'gD',              'declaration',              opts },
      { 'n', 'gd',              'definition',               opts },
      { 'n', 'K',               'hover',                    opts },
      { 'n', 'gi',              'implementation',           opts },
      { 'n', '<C-k>',           'signature_help',           opts },
      { 'n', '<LocalLeader>D',  'type_definition',          opts },
      { 'n', '<LocalLeader>rn', 'rename',                   opts },
      { 'n', 'gR',              'references',               opts },
      { 'n', '<LocalLeader>ca', 'code_action',              opts },
      { 'n', '<LocalLeader>wa', 'add_workspace_folder',     opts },
      { 'n', '<LocalLeader>wr', 'remove_workspace_folder',  opts },
    },
    {{
      'n', '<LocalLeader>wl',
      function()
        print ( vim.inspect( vim.lsp.buf.list_workspace_folders() ) )
      end,
      { buffer = bufnr, desc = 'vim.lsp.buf.list_workspace_folders' }
    }},
    {
      module = 'telescope.builtin',
      { 'n', '<LocalLeader>so', 'lsp_document_symbols',  opts },
      { 'n', '<LocalLeader>sO', 'lsp_workspace_symbols', opts },
    }
  }
  vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.formatting, {})
end

return M
