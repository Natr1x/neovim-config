local bind = require('profile.util.keybinder')

bind {{
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
}}

-- @TODO: Setup dap binding for this "dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')"
