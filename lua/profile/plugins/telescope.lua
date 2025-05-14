local fzf_native = false

return {
  -- UI to select things (files, grep results, open buffers...)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-telescope/telescope-file-browser.nvim",
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        cond = function()
          fzf_native = vim.fn.executable 'cmake' == 1
          return fzf_native
        end,
      },
    },

    config = function (_, opts)
      require('telescope').setup(opts)
      -- Enable telescope fzf native

      if fzf_native then
        require('telescope').load_extension 'fzf'
      end
      -- Telescope file browser
      require('telescope').load_extension 'file_browser'
    end,

    opts = function ()
      local fb_actions = require('telescope').extensions.file_browser.actions
      -- local actions = require('telescope.actions')
      return {
        defaults = {
          mappings = {
            i = {
              -- ['<C-u>'] = false,
              -- ['<C-d>'] = false,
              ['<M-h>'] = 'which_key',
            },
          },
        },
        extensions = {
          file_browser = {
            mappings = {
              n = {
                ['c'] = {
                  fb_actions.create,
                  type = "action",
                  opts = { nowait = true }
                }
              }
            },
            cwd_to_path = true,
          },
        },
      }
    end
  },
}
