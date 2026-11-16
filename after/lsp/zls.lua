---@brief
--- https://github.com/zigtools/zls
---
--- Zig LSP implementation + Zig Language Server

---@type vim.lsp.Config
return {
  cmd = { '/home/natrix/tools/zls/zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig', '.git' },
  workspace_required = false,
}
