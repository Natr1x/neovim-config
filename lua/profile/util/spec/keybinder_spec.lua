local mock = require('luassert.mock')
local match = require('luassert.match')
-- local stub = require('luassert.stub')

describe("keybinder", function ()
  local bind = require('profile.util.keybinder')
  describe("bind", function ()
    local snapshot
    before_each(function ()
      snapshot = assert:snapshot()
    end)
    after_each(function ()
      snapshot:revert()
    end)
    it("Should pass {{ {{'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>'} }} to vim.keymap.set", function ()
      local keymap = mock(vim.keymap, true)
      bind {{ { {'n', 'o', 'v'}, '<leader>w', ':HopWordAC<cr>' } }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with(
        match.same({'n', 'o', 'v'}), '<leader>w', ':HopWordAC<cr>')
    end)
    it("Should pass {{ {'n', '<leader>w', ':HopWordAC<cr>'} }} to vim.keymap.set", function ()
      local keymap = mock(vim.keymap, true)
      bind {{ {'n', '<leader>w', ':HopWordAC<cr>' } }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with('n', '<leader>w', ':HopWordAC<cr>')
    end)
  end)
end)
