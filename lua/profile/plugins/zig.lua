--- Zig specific stuff

return {
  'ziglang/zig.vim',
  init = function()
    vim.g.zig_fmt_autosave = 0
  end,
}
