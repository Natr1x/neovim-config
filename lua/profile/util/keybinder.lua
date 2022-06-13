local function mapkey(...)
  vim.keymap.set(...)
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

local function bind_regular(mappings)
  for _, m in ipairs(mappings) do
    mapkey(unpack(m))
  end
end

local function bind(mappings)
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

return bind

