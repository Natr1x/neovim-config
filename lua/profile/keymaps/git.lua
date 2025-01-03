--- Git related keybindings
local bind = require('profile.util.keybinder').bind

local M = {}

M.after_init = function ()
  local wk = require 'which-key'

  local function nmap(keys, func, desc)
    return { 'n', keys, func, { desc = desc } }
  end

  wk.add({
    { "<LocalLeader>g", group = "git" },
    { "<LocalLeader>gs", group = "gitsearch" },
    { "<leader>sG", group = "gitsearch" },
  })

  bind({
    { -- Telescope git things
      module = 'telescope.builtin',
      nmap('<leader>sGf', 'git_files',    '[s]earch [G]it [f]iles'),
      nmap('<leader>sGt', 'git_stash',    '[s]earch [G]it s[t]ash'),
      nmap('<leader>sGs', 'git_status',   '[s]earch [G]it [s]tatus'),
      nmap('<leader>sGc', 'git_bcommits', '[s]earch [G]it buffer [c]ommits'),
      nmap('<leader>sGC', 'git_commits',  '[s]earch [G]it [C]ommits'),
      nmap('<leader>sGb', 'git_branches', '[s]earch [G]it [b]ranches'),

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
  local function vmap(keys, func, desc)
    local function range_args()
      local start = vim.api.nvim_buf_get_mark(0, "<")
      local ending = vim.api.nvim_buf_get_mark(0, ">")
      return {
        {
          start[1],
          ending[1],
        },
      }
    end
    return {
      'v', keys, func, { buffer = bufnr, desc = desc },
      args = range_args
    }
  end

  wk.add({
    { '<LocalLeader>gh', group = 'hunk' },
    { '<LocalLeader>gb', group = 'buffer' },
  })

  bind {{
    module = 'gitsigns',
    nmap('<LocalLeader>gi', 'blame_line', '[g][i]t blame line'),
    nmap('<LocalLeader>ghv', 'preview_hunk', '[g]it [h]unk pre[v]iew'),
    nmap('<LocalLeader>ghV', 'preview_hunk_inline', '[g]it [h]unk pre[V]iew inline'),
    nmap('<LocalLeader>ghp', 'prev_hunk', '[g]it [h]unk [p]revious'),
    nmap('<LocalLeader>ghn', 'next_hunk', '[g]it [h]unk [n]ext'),
    nmap('<LocalLeader>ghs', 'stage_hunk', '[g]it [h]unk [s]tage'),
    vmap('<LocalLeader>ghs', 'stage_hunk', '[g]it [h]unk [s]tage'),
    nmap('<LocalLeader>ghr', 'reset_hunk', '[g]it [h]unk [r]eset'),

    nmap('<LocalLeader>gbs', 'stage_buffer', '[g]it [b]uffer [s]tage'),
    nmap('<LocalLeader>gbr', 'reset_buffer', '[g]it [b]uffer [r]eset'),

    -- TODO: make 'select_hunk' into text object:
    -- nmap('<LocalLeader>ghs', 'select_hunk', '[g]it [h]unk [s]elect (under cursor)'),
  }}
end

return M
