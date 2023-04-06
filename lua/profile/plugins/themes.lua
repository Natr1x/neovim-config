return {
  {
    'folke/tokyonight.nvim', opts = {
      style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
      transparent = true, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value `:help attr-list`
        comments = "NONE",
        keywords = "italic",
        functions = "NONE",
        variables = "NONE",
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },

      -- Set a darker background on sidebar-like windows.
      -- For example: `["qf", "vista_kind", "terminal", "packer"]`
      sidebars = { "vista_kind", "tagbar", "packer" },

      -- Adjusts the brightness of the colors of the **Day** style.
      -- Number between 0 and 1, from dull to vibrant colors
      day_brightness = 0.3,

      -- Hide inactive statuslines and replace them with a thin border instead.
      -- Should work with the standard **StatusLine** and **LuaLine**.
      hide_inactive_statusline = false,
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- fucntion will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors)
        colors.comment = '#4b8e44'
      end,

      --- You can override specific highlights to use other groups or a hex color
      --- fucntion will be called with a Highlights and ColorScheme table
      ---@param highlights table<string, Highlight>
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        highlights.TreesitterContextLineNumber = { fg = 'red', bg = colors.bg_dark }
        highlights.lualine_tabs_inactive = { bg = colors.bg_dark, fg = colors.fg_gutter }
        highlights.lualine_c_inactive = { fg = 'red' }
      end,
    }

  }
}
