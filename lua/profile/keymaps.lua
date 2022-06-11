
-- local mapkey = vim.keymap.set

-- For debugging purposes
local mapkey = function (...)
  local args = {...}
  local str_rep = vim.inspect(args)
  str_rep = str_rep:gsub('\n','')
  str_rep = str_rep:gsub('\t',' ')
  print(str_rep)
end

local function args_string(args)
  local res = vim.inspect(args)
  res = res:gsub('\n','')
  res = res:gsub('[ ]+',' ')
  return ' ' .. res
end

local function bind_table(tbl, tbl_desc, mappings)
  for _, m in ipairs(mappings) do
    local mode, lhs, rhs, opts = unpack(m)
    opts = opts or {}
    opts.desc = opts.desc or mappings.desc or
      tbl_desc .. '.' .. rhs .. ((m.args and args_string(m.args)) or '')
    if m.args then
      local rhs_func = tbl[rhs]
      mapkey(mode, lhs, function ()
        return rhs_func(unpack(m.args))
      end, opts)
    else
      mapkey(mode, lhs, tbl[rhs], opts)
    end
  end
end

local function bind_module(mappings)
  local module = require(mappings.module)
  bind_table(module, mappings.module, mappings)
end

local function bind_regular(mappings)
  for _, m in ipairs(mappings) do
    mapkey(unpack(m))
  end
end

local function bind(mappings)
  for _, m in ipairs(mappings) do
    if m.module then
      bind_module(m)
    elseif m.tbl then
      bind_table(m.tbl[1], m.tbl[2], m)
    else
      bind_regular(m)
    end
  end
end

--Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

bind {
  { -- Keybindings for Hop (Easymotion)
    { {'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>' },
    { {'n', 'o', 'v'}, '<leader>b', ':HopWordBC<cr>' },
    { {'n', 'o', 'v'}, '<leader>k', ':HopLineStartBC<cr>' },
    { {'n', 'o', 'v'}, '<leader>j', ':HopLineStartAC<cr>' },
    { {'n', 'o', 'v'}, '<leader>f', ':HopChar1AC<cr>' },
    { {'n', 'o', 'v'}, '<leader>F', ':HopChar1BC<cr>' },
    { {'n', 'o', 'v'}, '<leader>/', ':HopPatternMW<cr>' },
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
  }
}
local lsp_on_attach = function (_, bufnr)
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

-- vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist)
