local mock = require('luassert.mock')
local match = require('luassert.match')
-- local stub = require('luassert.stub')

describe("keybinder", function ()
  local bind = require('profile.util.keybinder')
  describe("bind_regular", function ()
    local snapshot
    before_each(function ()
      snapshot = assert:snapshot()
    end)
    after_each(function ()
      snapshot:revert()
    end)
    it("Should pass {{ {{'n', 'o', 'v'}, 'w', ':put'} }} to vim.keymap.set", function ()
      local keymap = mock(vim.keymap, true)
      bind {{ { {'n', 'o', 'v'}, 'w', ':put' } }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with(
        match.same({'n', 'o', 'v'}), 'w', ':put')
    end)
    it("Should pass {{ {'n', 'w', ':put'} }} to vim.keymap.set", function ()
      local keymap = mock(vim.keymap, true)
      bind {{ {'n', 'w', ':put' } }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with('n', 'w', ':put')
    end)
  end)
  describe("bind_module", function ()
    local snapshot
    before_each(function ()
      snapshot = assert:snapshot()
    end)
    after_each(function ()
      snapshot:revert()
    end)
    it("Should bind module functions with vim.keymap.set", function ()
      local keymap = mock(vim.keymap, true)
      bind {{
        module = 'profile.util.spec.testmodule',
        {'n', 'w', 'dummy_fn' }
      }}
      assert.stub(keymap.set).was_called()
    end)
    it("Should require the module and create opt.desc", function ()
      local keymap = mock(vim.keymap, true)
      bind {{
        module = 'profile.util.spec.testmodule',
        {'n', 'w', 'dummy_fn' }
      }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with(
        match.equals('n'),
        match.equals('w'),
        match.equals(require('profile.util.spec.testmodule').dummy_fn),
        match.same({
          desc = 'profile.util.spec.testmodule.dummy_fn'
        }))
    end)
  end)
end)
