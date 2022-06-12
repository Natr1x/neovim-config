local mock = require('luassert.mock')
local match = require('luassert.match')
-- local stub = require('luassert.stub')

describe("bind", function ()
  local bind = require('profile.util.keybinder')
  local snapshot, keymap

  before_each(function ()
    snapshot = assert:snapshot()
    keymap = mock(vim.keymap, true)
  end)
  after_each(function ()
    snapshot:revert()
  end)

  local function standard_tests(bind_arg, ...)
    local expected_binding_count = 0
    local matchers = {...}
    for _, t in ipairs(bind_arg) do
      expected_binding_count = expected_binding_count + #t
    end

    it("Should bind the correct number of keybindings", function ()
      bind(bind_arg)
      assert.stub(keymap.set).was_called(expected_binding_count)
    end)


    it("Should call vim.keymap.set with correct arguments", function ()
      bind(bind_arg)
      for i, test in ipairs { "mode/modes", "lhs", "rhs", "opts", } do
        local m = {}; for j = 1, #matchers do m[j] = match._ end
        if #m >= i then m[i] = matchers[i] end
        assert.stub(keymap.set, test).was_called_with(unpack(m))
      end
    end)
  end

  -- Regular bindings
  describe("{{'n', 'o', 'v'}, 'w', ':put'}", function ()
    standard_tests(
      {{ { {'n', 'o', 'v'}, 'w', ':put' } }},
      match.same({'n', 'o', 'v'}), 'w', ':put')
  end)
  describe("{'n', 'w', ':put'}", function ()
    standard_tests( {{ {'n', 'w', ':put'} }}, 'n', 'w', ':put')
  end)

  describe("module = 'testmodule',", function ()
    describe("{'n', 'w', 'dummy_fn'}", function ()
      standard_tests({{
          module = 'profile.util.spec.testmodule',
          {'n', 'w', 'dummy_fn'}
        }}, 'n', 'w',
        require('profile.util.spec.testmodule').dummy_fn,
        match.same({
          desc = 'profile.util.spec.testmodule.dummy_fn'
        }))
    end)

    it("Should not overwrite a desc provided in opts", function ()
      bind {{
          module = 'profile.util.spec.testmodule',
          {'n', 'w', 'dummy_fn', {desc = "Dummy Desc"}}
        }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with(
        'n', 'w',
        require('profile.util.spec.testmodule').dummy_fn,
        match.same({
          desc = 'Dummy Desc'
        }))
    end)

    it("Should not overwrite ", function ()
      bind {{
          module = 'profile.util.spec.testmodule',
          {'n', 'w', 'dummy_fn', {desc = "Dummy Desc"}}
        }}
      assert.stub(keymap.set).was_called()
      assert.stub(keymap.set).was_called_with(
        'n', 'w',
        require('profile.util.spec.testmodule').dummy_fn,
        match.same({
          desc = 'Dummy Desc'
        }))
    end)

  end)

  describe("tbl = {dummy_tbl, 'dummy_tbl'}", function ()
    local dummy_tbl = { dummy_fn = function () end }
    describe("{'n', 'w', 'dummy_fn'}", function ()
      standard_tests({{
          tbl = {dummy_tbl, 'dummy_tbl'},
          {'n', 'w', 'dummy_fn'}
        }}, 'n', 'w',
        dummy_tbl.dummy_fn,
        match.same({
          desc = 'dummy_tbl.dummy_fn'
        }))
    end)
  end)
  -- describe("bind tbl", function ()
  --   local dummy_tbl = { dummy_fn = function () end }
  --   it("Should bind to functions in a supplied table", function ()
  --     bind {{
  --       tbl = { dummy_tbl, 'dummy_tbl', },
  --       {'n', 'w', 'dummy_fn'}
  --     }}
  --     assert.stub(keymap.set).was_called(1)
  --     assert.stub(keymap.set).was_called_with(
  --       match.equals('n'),
  --       match.equals('w'),
  --       match.equals(require('profile.util.spec.testmodule').dummy_fn),
  --       match._,
  --       match.same({
  --         desc = 'profile.util.spec.testmodule.dummy_fn'
  --       }))
  --   end)
  --   it("Should bind and supply an automatic desc to opts", function ()
  --     bind {{
  --       tbl = { dummy_tbl, 'dummy_tbl', },
  --       {'n', 'w', 'dummy_fn'}
  --     }}
  --     assert.stub(keymap.set).was_called(1)
  --     assert.stub(keymap.set).was_called_with(
  --       match.equals('n'),
  --       match.equals('w'),
  --       match._,
  --       match.same({ desc = 'dummy_tbl.dummy_fn' }))
  --   end)
  -- end)
  -- describe("bind module", function ()
  --   it("Should bind module functions with vim.keymap.set", function ()
  --     bind {{
  --       module = 'profile.util.spec.testmodule',
  --       {'n', 'w', 'dummy_fn'}
  --     }}
  --     assert.stub(keymap.set).was_called(1)
  --   end)
  --   it("Should require the module and create opt.desc", function ()
  --     bind {{
  --       module = 'profile.util.spec.testmodule',
  --       {'n', 'w', 'dummy_fn'}
  --     }}
  --     assert.stub(keymap.set).was_called(1)
  --     assert.stub(keymap.set).was_called_with(
  --       match.equals('n'),
  --       match.equals('w'),
  --       match.equals(require('profile.util.spec.testmodule').dummy_fn),
  --       match.same({
  --         desc = 'profile.util.spec.testmodule.dummy_fn'
  --       }))
  --   end)
  -- end)
end)
