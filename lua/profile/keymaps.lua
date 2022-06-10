
-- local mapkey = vim.keymap.set

-- For debugging purposes
local mapkey = function (...)
    local args = {...}
    local str_rep = vim.inspect(args)
    str_rep = str_rep:gsub('\n','')
    str_rep = str_rep:gsub('\t',' ')
    print(str_rep)
end

local function args_string(args)
    local res = vim.inspect(args)
    res = res:gsub('\n','')
    res = res:gsub('[ ]+',' ')
    return ' ' .. res
end

local function bind_table(tbl, tbl_desc, mappings)
    for _, m in ipairs(mappings) do
        local mode, lhs, rhs, opts = unpack(m)
        opts = opts or {}
        opts.desc = opts.desc or mappings.desc or
            tbl_desc .. '.' .. rhs .. ((m.args and args_string(m.args)) or '')
        if m.args then
            local rhs_func = tbl[rhs]
            mapkey(mode, lhs, function ()
                return rhs_func(unpack(m.args))
            end, opts)
        else
            mapkey(mode, lhs, tbl[rhs], opts)
        end
    end
end

local function bind_module(mappings)
    local module = require(mappings.module)
    bind_table(module, mappings.module, mappings)
end

local function bind(mappings)
    for _, m in ipairs(mappings) do
        if m.module then
            bind_module(m)
        elseif m.tbl then
            bind_table(m.tbl[1], m.tbl[2], m)
        else
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
bind({{
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
}})

-- vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<LocalLeader>q', vim.diagnostic.setloclist)
