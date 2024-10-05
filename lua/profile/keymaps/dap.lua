local bind = require('profile.util.keybinder').bind
local wk = require 'which-key'

local function nmap(keys, func, desc)
  return { 'n', keys, func, { desc = 'DAP: ' .. desc } }
end

wk.add({
  { "<LocalLeader>d", group = "debug" },
  { "<LocalLeader>ds", group = "step" },
  { "<LocalLeader>du", group = "debugui" },
})

bind {{
    module = 'dap',
    nmap('<LocalLeader>db', 'toggle_breakpoint', 'Toggle [d]ebug [b]reakpoint'),
    nmap('<LocalLeader>dc', 'continue', '[d]ebug [c]ontinue'),
    nmap('<LocalLeader>dl', 'run_last', '[d]ebug run [l]ast'),
    nmap('<LocalLeader>dr', 'run_to_cursor', '[d]ebug [r]un to cursor'),
    nmap('<LocalLeader>dsi',  'step_into', '[d]ebug [s]tep [i]nto'),
    nmap('<LocalLeader>dso',  'step_over', '[d]ebug [s]tep [o]ver'),
    nmap('<LocalLeader>dsO',  'step_out', '[d]ebug [s]tep [O]ut'),
  },
  {
    nmap('<LocalLeader>dB', function ()
      require('dap').set_breakpoint(vim.fn.input, 'Breakpoint condition: ')
    end, 'DAP: Set conditional [d]ebug [B]reakpoint'),
  },
  {
    module = 'dapui',
    nmap('<LocalLeader>duc', 'close', '[d]ebug [u]i [c]lose'),
    nmap('<LocalLeader>duo', 'close', '[d]ebug [u]i [o]pen'),
    nmap('<LocalLeader>duf', 'close', '[d]ebug [u]i [f]loat element'),
  },
}

-- @TODO: Setup dap binding for this "dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')"
