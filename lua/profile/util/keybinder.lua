local M = {}

local K = vim.keymap.set

local function mapkey(...)
  vim.keymap.set(...)
end

local function args_string(args)
  local res = vim.inspect(args)
  res = res:gsub('\n','')
  res = res:gsub('[ ]+',' ')
  return ' ' .. res
end

---Stores opfunc callbacks that can be globally accessed which is required
---for them to be assigned to vim.o.operatorfunc
M.opfuncs = {}

local function dummy_function()
  local level = vim.log.levels.WARN
  vim.notify("This is a dummy opfunc that should have been overridden", level)
end

---Generates a unique index that can be used in M.opfuncs
---@return string Index key for M.opfuncs with the patter 'cb_{id}'
local function generate_op_id()
  local id = 'cb_' .. tostring(vim.fn.rand())
  while M.opfuncs[id] do
    id = 'cb_' .. tostring(vim.fn.rand())
  end
  -- Set to dummy immediately to mark the id as used
  M.opfuncs[id] = dummy_function
  return id
end

---Creates a callback which registers the provided function as an opfunc
---which is called with a taken from the operand.
---@param inner_func function Function to be called with a range.
---@param before function? Function to be called before opfunc is set.
---@return function Callback suitable for mapping in normal mode.
local function as_opfunc(inner_func, before)
  local id = generate_op_id()

  local function opfunc(mtype)
    if mtype == nil then
      if before then before() end
      vim.o.opfunc = "v:lua.require'profile.util.keybinder'.opfuncs." .. id
      return 'g@'
    end

    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')

    print(vim.inspect({'outer call', start = start, finish = finish}))

    inner_func(mtype, start, finish)
  end

  M.opfuncs[id] = opfunc
  return opfunc
end

local MODE_MAP = { ['v'] = 'char', ['V'] = 'line', [''] = 'block' }

---Creates a callback which calls the provided with a range taken from visual.
---@param inner_func function Function to be called with a range.
---@param before function? Function to be called before anything else.
---@return function Callback suitable for mapping in visual mode.
local function as_visualfunc(inner_func, before)
  local function visualfunc()
    if before then before() end
    local mtype = MODE_MAP[vim.fn.visualmode()]
    local start = vim.api.nvim_buf_get_mark(0, '<')
    local finish = vim.api.nvim_buf_get_mark(0, '>')

    inner_func(mtype, start, finish)
  end

  return visualfunc
end

---Creates a callback which calls the provided function with a range taken from
---the current cursor position and vim.v.count.
---@param inner_func function Function to be called with a range.
---@param before function? Function to be called before anything else.
---@return function Callback suitable for mapping in normal mode.
local function as_countfunc(inner_func, before)
  local function countfunc()
    if before then before() end
    local count = vim.api.nvim_get_vvar('count')
    local start = vim.api.nvim_win_get_cursor(0)
    local finish = start + count

    inner_func('line', start, finish)
  end

  return countfunc
end

local function range_binding(lead_keys, count_key, cb, opts, before)
  vim.validate {
    lead_keys = { lead_keys, 'string' },
    count_key = { count_key, 'string' },
    cb = { cb, 'function' },
    opts = { opts, 'table' },
    before = { opts, 'function', true },
  }
  local opfunc = as_opfunc(cb, before)
  local visualfunc = as_visualfunc(cb, before)
  local countfunc = as_countfunc(cb, before)

end

local function bind_table(tbl, tbl_desc, mappings)
  if type(tbl) == "function" then
    tbl = tbl()
  end
  for _, m in ipairs(mappings) do
    local mode, lhs, rhs, opts = unpack(m)
    opts = opts or {}
    opts.desc = opts.desc or mappings.desc or
      tbl_desc .. '.' .. rhs .. ((m.args and args_string(m.args)) or '')
    if m.args then
      local rhs_func = tbl[rhs]
      if type(m.args) == "function" then
        mapkey(mode, lhs, function ()
          return rhs_func(unpack(m.args()))
        end, opts)
      else
        mapkey(mode, lhs, function ()
          return rhs_func(unpack(m.args))
        end, opts)
      end
    else
      mapkey(mode, lhs, tbl[rhs], opts)
    end
  end
end

local function bind_module(mappings)
  local module = require(mappings.module)
  bind_table(module, mappings.module, mappings)
end

local function bind_regular(mappings)
  for _, m in ipairs(mappings) do
    mapkey(unpack(m))
  end
end

function M.bind(mappings)
  for _, m in ipairs(mappings) do
    if m.module then
      bind_module(m)
    elseif m.tbl then
      bind_table(m.tbl[1], m.tbl[2], m)
    else
      bind_regular(m)
    end
  end
end

return M
