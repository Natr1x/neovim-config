local k = require('profile.util.keybinder')
local bind = k.bind
local wk = require 'which-key'

wk.register({
  ['<leader>s'] = { name = '+search' },
})

local M = {}

-- Not sure why I do this but there was probably a reason
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

M.after_init = function ()
  local git_keymaps = require 'profile.keymaps.git'

  local function silent_map(keys, func, desc)
    return {
      {'n', 'o', 'v'}, keys, func, { silent = true, desc = desc, }
    }
  end

  local function nmap(keys, func, desc, args)
    if args then
      return { 'n', keys, func, { desc = desc }, args = args }
    end

    return { 'n', keys, func, { desc = desc } }
  end

  -- local testop = k.as_opfunc(function (mtype, start, finish)
  --   print(vim.inspect({'inner call', mtype = mtype, start = start, finish = finish}))
  -- end)
  --
  -- bind {{
  --   { 'n', '<f12>', testop, { desc = "Test operator binding", expr = true } },
  -- }}

  bind {
    {
      -- Remap for dealing with word wrap
      { 'n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } },
      { 'n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } },

      -- Keybindings for Hop (Easymotion)
      silent_map('<leader>w', ':HopWordAC<cr>',       'Hop to [w]ord'),
      silent_map('<leader>b', ':HopWordBC<cr>',       'Hop to word [b]ackwards'),
      silent_map('<leader>k', ':HopLineStartBC<cr>',  '[k] Hop lines Upwards'),
      silent_map('<leader>j', ':HopLineStartAC<cr>',  '[j] Hop lines Downwards'),
      silent_map('<leader>f', ':HopChar1AC<cr>',      'Hop to [f]ind forwards'),
      silent_map('<leader>F', ':HopChar1BC<cr>',      'Hop to [F]ind backwards'),
      silent_map('<leader>/', ':HopPatternMW<cr>',    '[/] Hop to pattern'),

      -- Keybindings for Vista / Tagbar
      { 'n', '<F8>', ':TagbarToggle<cr>', { silent = true, desc = 'Toggle Tagbar' } },
      { 'i', '<F8>', '<Esc>:TagbarToggle<cr>', { silent = true, desc = 'Toggle Tagbar' } },

      -- Escape from terminal emulator
      { 't', '<C-o><C-o>', '<C-\\><C-N>', { desc = 'Enter normal mode from terminal' } },
    },

    { -- Keybindings for Telescope
      module = 'telescope.builtin',
      nmap('<leader>?',       'oldfiles',                   '[?] Find recently opened files'),
      nmap('<leader><space>', 'buffers',                    '[ ] Find existing buffers'),
      nmap('<leader>sf',      'find_files',                 '[s]earch [f]iles'),
      nmap('<leader>sb',      'current_buffer_fuzzy_find',  '[s]earch current [b]uffer'),
      nmap('<leader>sh',      'help_tags',                  '[s]earch [h]elp'),
      nmap('<leader>sw',      'grep_string',                '[s]earch current [w]ord'),
      nmap('<leader>sp',      'live_grep',                  '[s]earch by [p]attern'),
      nmap('<leader>sd',      'diagnostics',                '[s]earch [d]iagnostics'),
      nmap('<leader>st',      'tags',                       '[s]earch all [t]ags'),
      nmap('<leader>so',      'tags',                       '[s]earch symb[o]ls in current buffer',
        { { only_current_buffer = true } }),
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

  git_keymaps.after_init()
end

return M
-- vim: ts=2 sts=2 sw=2 et
