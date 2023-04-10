local keymaps = require 'profile.keymaps.git'

return {
  'tpope/vim-fugitive', -- Git commands in nvim
  'tpope/vim-rhubarb',  -- Fugitive-companion to interact with github

  -- Add git related info in the signs columns and popups
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = keymaps.gitsigns_attach,
    }
  },
}
