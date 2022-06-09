

local function bind(mappings)
    local module = require(mappings.module)
    for _, m in ipairs(mappings) do
        local mode, lhs, rhs, opts = unpack(m)
        opts = opts or {}
        opts.desc = opts.desc or mappings.desc or mappings.module .. '.' .. rhs
        if m.args then
            vim.keymap.set(mode, lhs, function ()
                return module[rhs](unpack(m.args))
            end, opts)
        else
            vim.keymap.set(mode, lhs, module[rhs], opts)
        end
    end
end

--Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keybindings for Hop (Easymotion)
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>b', ':HopWordBC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>k', ':HopLineStartBC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>j', ':HopLineStartAC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>f', ':HopChar1AC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>F', ':HopChar1BC<cr>')
-- vim.keymap.set({'n', 'o', 'v'}, '<leader>/', ':HopPatternMW<cr>')

-- Keybindings for Telescope
-- local teleb = require('telescope.builtin')

-- vim.keymap.set('n', '<leader><space>',  teleb.buffers)
-- vim.keymap.set('n', '<leader>sf',       teleb.find_files)
-- vim.keymap.set('n', '<leader>sb',       teleb.current_buffer_fuzzy_find)
-- vim.keymap.set('n', '<leader>sh',       teleb.help_tags)
-- vim.keymap.set('n', '<leader>st',       teleb.tags)
-- vim.keymap.set('n', '<leader>sd',       teleb.grep_string)
-- vim.keymap.set('n', '<leader>sp',       teleb.live_grep)
-- vim.keymap.set('n', '<leader>so',       function() teleb.tags { only_current_buffer = true } end)
-- vim.keymap.set('n', '<leader>?',        teleb.oldfiles)

bind({
    module = 'telescope.builtin',
    {'n', '<leader><space>',  'buffers'},
    {'n', '<leader>sf',       'find_files'},
    {'n', '<leader>sb',       'current_buffer_fuzzy_find'},
    {'n', '<leader>sh',       'help_tags'},
    {'n', '<leader>st',       'tags'},
    {'n', '<leader>sd',       'grep_string'},
    {'n', '<leader>sp',       'live_grep'},
    {'n', '<leader>so',       'tags', args = { { only_current_buffer = true } }},
    {'n', '<leader>?',        'oldfiles'},
})
