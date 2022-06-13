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
    describe("without args", function ()
      standard_tests({{
          module = 'profile.util.spec.testmodule',
          {'n', 'w', 'dummy_fn'},
        }}, 'n', 'w',
        require('profile.util.spec.testmodule').dummy_fn,
        match.same({
          desc = 'profile.util.spec.testmodule.dummy_fn'
        }))

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

      it("Should not change anything in provided opts besides desc", function ()
        bind {{
            module = 'profile.util.spec.testmodule',
            {'n', 'w', 'dummy_fn', {silent = true}},
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          require('profile.util.spec.testmodule').dummy_fn,
          match.all_of(match.same({
            desc = 'profile.util.spec.testmodule.dummy_fn',
            silent = true
          })))
      end)
    end)

    describe("with args", function ()
      standard_tests({{
          module = 'profile.util.spec.testmodule',
          {'n', 'w', 'dummy_fn', args = 'test arg'},
        }}, 'n', 'w',
        match.none_of(match.equals(require('profile.util.spec.testmodule').dummy_fn)),
        match.same({
          desc = 'profile.util.spec.testmodule.dummy_fn "test arg"'
        }))

      it("Should not overwrite a desc provided in opts", function ()
        bind {{
            module = 'profile.util.spec.testmodule',
            {'n', 'w', 'dummy_fn', {desc = "Dummy Desc"}, args = 'test arg'}
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          match.none_of(match.equals(require('profile.util.spec.testmodule').dummy_fn)),
          match.same({
            desc = 'Dummy Desc'
          }))
      end)

      it("Should not change anything in provided opts besides desc", function ()
        bind {{
            module = 'profile.util.spec.testmodule',
            {'n', 'w', 'dummy_fn', {silent = true}, args = 'test arg'},
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          match.none_of(match.equals(require('profile.util.spec.testmodule').dummy_fn)),
          match.all_of(match.same({
            desc = 'profile.util.spec.testmodule.dummy_fn "test arg"',
            silent = true
          })))
      end)
    end)
  end)

  describe("tbl = {dummy_tbl, 'dummy_tbl'}", function ()
    local dummy_tbl = {
      dummy_fn = function () end,
      afun = function () end,
      bfun = function () end,
      cfun = function () end,
      dfun = function () end,
    }
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

    describe("multiple bindings", function ()
      it("Should set correct desc even if multiple bindings are provided with the same opts", function ()
        local opts = { silent = true }
        bind {
          {
            tbl = { dummy_tbl, 'dummy_tbl' },
            { 'n', 'a', 'afun', opts },
            { 'n', 'b', 'bfun', opts },
            { 'n', 'c', 'cfun', opts },
            { 'n', 'd', 'dfun', opts, args = 'test arg' },
          }
        }
        assert.stub(keymap.set).was_called(4)
        assert.stub(keymap.set, 'afun desc is dummy_tbl.afun').was_called_with(
          'n', 'a', dummy_tbl.afun, match.same({
            desc = 'dummy_tbl.afun',
            silent = true
        }))
        assert.stub(keymap.set, 'bfun desc is dummy_tbl.bfun').was_called_with(
          'n', 'b', dummy_tbl.bfun, match.same({
            desc = 'dummy_tbl.bfun',
            silent = true
        }))
        assert.stub(keymap.set, 'cfun desc is dummy_tbl.cfun').was_called_with(
          'n', 'c', dummy_tbl.cfun, match.same({
            desc = 'dummy_tbl.cfun',
            silent = true
        }))
        assert.stub(keymap.set, 'dfun desc is dummy_tbl.dfun').was_called_with(
          'n', 'd', match._, match.same({
            desc = 'dummy_tbl.dfun "test arg"',
            silent = true
        }))
      end)
    end)

    describe("without args", function ()
      standard_tests({{
          tbl = { dummy_tbl, 'dummy_tbl' },
          {'n', 'w', 'dummy_fn'},
        }}, 'n', 'w',
        dummy_tbl.dummy_fn,
        match.same({
          desc = 'dummy_tbl.dummy_fn'
        }))

      it("Should not overwrite a desc provided in opts", function ()
        bind {{
            tbl = { dummy_tbl, 'dummy_tbl' },
            {'n', 'w', 'dummy_fn', {desc = "Dummy Desc"}}
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          dummy_tbl.dummy_fn,
          match.same({
            desc = 'Dummy Desc'
          }))
      end)

      it("Should not change anything in provided opts besides desc", function ()
        bind {{
            tbl = { dummy_tbl, 'dummy_tbl' },
            {'n', 'w', 'dummy_fn', {silent = true}},
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          dummy_tbl.dummy_fn,
          match.all_of(match.same({
            desc = 'dummy_tbl.dummy_fn',
            silent = true
          })))
      end)
    end)

    describe("with args", function ()
      standard_tests({{
          tbl = { dummy_tbl, 'dummy_tbl' },
          {'n', 'w', 'dummy_fn', args = 'test arg'},
        }}, 'n', 'w',
        match.none_of(match.equals(dummy_tbl.dummy_fn)),
        match.same({
          desc = 'dummy_tbl.dummy_fn "test arg"'
        }))

      it("Should not overwrite a desc provided in opts", function ()
        bind {{
            tbl = { dummy_tbl, 'dummy_tbl' },
            {'n', 'w', 'dummy_fn', {desc = "Dummy Desc"}, args = 'test arg'}
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          match.none_of(match.equals(dummy_tbl.dummy_fn)),
          match.same({
            desc = 'Dummy Desc'
          }))
      end)

      it("Should not change anything in provided opts besides desc", function ()
        bind {{
            tbl = { dummy_tbl, 'dummy_tbl' },
            {'n', 'w', 'dummy_fn', {silent = true}, args = 'test arg'},
          }}
        assert.stub(keymap.set).was_called()
        assert.stub(keymap.set).was_called_with(
          'n', 'w',
          match.none_of(match.equals(dummy_tbl.dummy_fn)),
          match.all_of(match.same({
            desc = 'dummy_tbl.dummy_fn "test arg"',
            silent = true
          })))
      end)
    end)
  end)
end)
