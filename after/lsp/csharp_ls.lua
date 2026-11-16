---@brief
---
--- https://github.com/razzmatazz/csharp-language-server
---
--- Language Server for C#.
---
--- csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.
---
--- This is mostly copied from nvim-lspconfig



-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
local function strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

local project_endings = { ".sln", ".slnx", ".csproj" }
local function match_root_indicator(name, path)
  for _, p in ipairs(project_endings) do
    if name:sub(-#p) == p then
      return true
    end
  end
  return false
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'csharp-ls' }, dispatchers, {
      -- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
      -- If cmd_cwd is provided, use it instead.
      cwd = config.cmd_cwd or config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  root_dir = function(bufnr, on_dir)
    local file_path = vim.api.nvim_buf_get_name(bufnr)
    local root_files = vim.fs.find(match_root_indicator, {
      path = strip_archive_subpath(file_path),
      type = 'file',
      upward = true,
    })
    if root_files[1] then
      on_dir(vim.fs.dirname(root_files[1]))
    else
      on_dir(nil)
    end
  end,
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  get_language_id = function(_, ft)
    if ft == 'cs' then
      return 'csharp'
    end
    return ft
  end,
}
