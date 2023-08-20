return {
  {
    'neomake/neomake',
    init = function ()
      vim.cmd [[
        highlight link NeomakeVirtualtextError DiagnosticError
        highlight link NeomakeVirtualtextWarning DiagnosticWarning
      ]]
    end
  },
  { import = 'profile.plugins.extras.cmake' }
}
