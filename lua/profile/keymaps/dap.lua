local bind = require('profile.util.keybinder').bind
local wk = require 'which-key'

local function nmap(keys, func, desc, args)
  if type(args) == 'table' then
    return { 'n', keys, func, { desc = 'DAP: ' .. desc }, args = args }
  else
   return { 'n', keys, func, { desc = 'DAP: ' .. desc } }
 end
end

wk.add({
  { "<LocalLeader>d", group = "debug" },
  { "<LocalLeader>ds", group = "step" },
  { "<LocalLeader>s", group = "step" },
})

bind {{
    module = 'dap',
    nmap('<LocalLeader>db', 'toggle_breakpoint', 'Toggle [d]ebug [b]reakpoint'),
    nmap('<LocalLeader>dc', 'continue', '[d]ebug [c]ontinue'),
    nmap('<LocalLeader>dl', 'run_last', '[d]ebug run [l]ast'),
    nmap('<LocalLeader>dt', 'terminate', '[d]ebug [t]erminate session'),
    nmap('<LocalLeader>dr', 'run_to_cursor', '[d]ebug [r]un to cursor'),
    nmap('<LocalLeader>dsi',  'step_into', '[d]ebug [s]tep [i]nto'),
    nmap('<LocalLeader>dso',  'step_over', '[d]ebug [s]tep [o]ver'),
    nmap('<LocalLeader>dsO',  'step_out', '[d]ebug [s]tep [O]ut'),
    nmap('<LocalLeader>si',  'step_into', '[s]tep [i]nto'),
    nmap('<LocalLeader>so',  'step_over', '[s]tep [o]ver'),
    nmap('<LocalLeader>sO',  'step_out', '[s]tep [O]ut'),
  },
  {
    nmap('<LocalLeader>dB', function ()
      require('dap').set_breakpoint(vim.fn.input, 'Breakpoint condition: ')
    end, 'DAP: Set conditional [d]ebug [B]reakpoint'),
  },
  {
    module = 'dapui',
    nmap('<LocalLeader>du', 'toggle', '[d]ebug [u]i toggle'),
    nmap('<LocalLeader>dh', 'toggle', '[d]ebug ui toggle left panel', {1}),
    nmap('<LocalLeader>dj', 'toggle', '[d]ebug ui toggle bottom tray', {2}),
    nmap('<LocalLeader>dl', 'toggle', '[d]ebug ui toggle right panel', {3}),
  },
}

-- @TODO: Setup dap binding for this "dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')"
