
vim.opt.hlsearch       =  false   --Don't keep highligt for every search
vim.opt.mouse          =  'a'     --Enable mouse mode
vim.opt.breakindent    =  true
vim.opt.undofile       =  true
vim.opt.ignorecase     =  true    --Caseinsensitive search if no capitals
vim.opt.smartcase      =  true
vim.opt.updatetime     =  250
vim.opt.termguicolors  =  true
vim.opt.completeopt    =  'menuone,noselect,longest'
vim.opt.wildmode       =  { 'longest:full', 'full' }
vim.opt.wildoptions    =  { 'pum' }

vim.opt.number          = true  -- Show current line number
vim.opt.relativenumber  = true  -- Show relative line numbers
vim.opt.spr             = true  -- Splits to the right when splitting vertically

vim.opt.shiftwidth      = 4     -- Tabs are 4 spaces wide
vim.opt.tabstop         = 4     -- Tabs stop every 4 columns even if smaller than above
vim.opt.expandtab       = true  -- Tabs are automatically turned into spaces
vim.opt.smarttab        = true  -- Tabs try to follow indentation

vim.opt.cursorline      = true  -- Highlights the linenumber the cursor is currently on

vim.wo.signcolumn      =  'yes'
vim.wo.number          =  true
vim.wo.relativenumber  =  true

-- TokyoNight Theme specific options
vim.g.tokyonight_style                =  "night"
vim.g.tokyonight_transparent          =  true
vim.g.tokyonight_transparent_sidebar  =  false
vim.g.tokyonight_sidebars             = { "vista_kind", "vista", "tagbar", "packer" }
vim.g.tokyonight_colors               = { comment = '#4b8e44' }
