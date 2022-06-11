
local latest_arg = 'None yet'

return {
  get_latest = function ()
    return latest_arg
  end,
  dummy_fn_arg = function (dummy_argument)
    latest_arg = dummy_argument
    return 'Dummy function was called with: ' .. dummy_argument
  end,
  dummy_fn = function ()
    latest_arg = 'Dummy was called with no arg'
  end
}
