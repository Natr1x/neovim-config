--- Git related keybindings
local bind = require('profile.util.keybinder')

local M = {}

M.after_init = function ()
  local wk = require 'which-key'

  local function nmap(keys, func, desc)
    return { 'n', keys, func, { desc = desc } }
  end

  wk.register({
    ['<LocalLeader>g'] = { name = '+git' },
    ['<leader>sg'] = { name = '+gitsearch' },
    ['<LocalLeader>gs'] = { name = '+gitsearch' },
  })

  bind({
    { -- Telescope git things
      module = 'telescope.builtin',
      nmap('<leader>sgf', 'git_files',    '[s]earch [g]it [f]iles'),
      nmap('<leader>sgt', 'git_stash',    '[s]earch [g]it s[t]ash'),
      nmap('<leader>sgs', 'git_status',   '[s]earch [g]it [s]tatus'),
      nmap('<leader>sgc', 'git_bcommits', '[s]earch [g]it buffer [c]ommits'),
      nmap('<leader>sgC', 'git_commits',  '[s]earch [g]it [C]ommits'),
      nmap('<leader>sgb', 'git_branches', '[s]earch [g]it [b]ranches'),

      nmap('<LocalLeader>gsf', 'git_files',    '[g]it [s]earch [f]iles'),
      nmap('<LocalLeader>gst', 'git_stash',    '[g]it [s]earch s[t]ash'),
      nmap('<LocalLeader>gss', 'git_status',   '[g]it [s]earch [s]tatus'),
      nmap('<LocalLeader>gsc', 'git_bcommits', '[g]it [s]earch buffer [c]ommits'),
      nmap('<LocalLeader>gsC', 'git_commits',  '[g]it [s]earch [C]ommits'),
      nmap('<LocalLeader>gsb', 'git_branches', '[g]it [s]earch [b]ranches'),
    }
  })
end

M.gitsigns_attach = function (bufnr)
  local wk = require 'which-key'
  local function nmap(keys, func, desc)
    return { 'n', keys, func, { buffer = bufnr, desc = desc } }
  end

  wk.register({
    ['<LocalLeader>gh'] = { name = '+hunk' },
    ['<LocalLeader>gb'] = { name = '+buffer' },
  })

  bind {{
    module = 'gitsigns',
    nmap('<LocalLeader>gi', 'blame_line', '[g][i]t blame line'),
    nmap('<LocalLeader>ghv', 'preview_hunk', '[g]it [h]unk pre[v]iew'),
    nmap('<LocalLeader>ghV', 'preview_hunk_inline', '[g]it [h]unk pre[V]iew inline'),
    nmap('<LocalLeader>ghp', 'prev_hunk', '[g]it [h]unk [p]revious'),
    nmap('<LocalLeader>ghn', 'next_hunk', '[g]it [h]unk [n]ext'),
    nmap('<LocalLeader>ghs', 'stage_hunk', '[g]it [h]unk [s]tage'),
    nmap('<LocalLeader>ghr', 'reset_hunk', '[g]it [h]unk [r]eset'),

    nmap('<LocalLeader>gbs', 'stage_buffer', '[g]it [b]uffer [s]tage'),
    nmap('<LocalLeader>gbr', 'reset_buffer', '[g]it [b]uffer [r]eset'),

    -- TODO: make 'select_hunk' into text object:
    -- nmap('<LocalLeader>ghs', 'select_hunk', '[g]it [h]unk [s]elect (under cursor)'),
  }}
end

return M
