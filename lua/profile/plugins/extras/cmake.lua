local function cmake_opts()
  local Path = require('plenary.path')
  local CMakeProjectConfig = require 'cmake.project_config'

  return {
    cmake_executable = 'cmake', -- CMake executable to run.

    save_before_build = false, -- Save all buffers before building.

    -- JSON file to store information about selected target.
    -- E.g. run arguments and build type.
    -- parameters_file = 'neovim.json',

    -- The default values in `parameters_file`.
    -- default_parameters = { run_dir = '', args = {}, build_type = 'Debug' },

    -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}`
    -- will be expanded with the corresponding text values.
    -- Could be a function that return the path to the build directory.
    build_dir = tostring(Path:new('{cwd}', 'build')),

    -- Folder with samples.
    -- `samples` folder from the plugin directory is used by default.
    -- samples_path = tostring(script_path:parent():parent():parent() / 'samples'),

    -- Default folder for creating project.
    default_projects_path = tostring(Path:new(vim.loop.os_homedir(), 'labb')),

    -- Default arguments that will be always passed at cmake configure step.
    -- By default tells cmake to generate `compile_commands.json`.
    -- configure_args = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },

    -- Default arguments that will be always passed at cmake build step.
    -- build_args = {},

    -- Callback that will be called each time data is received by the current process.
    -- Accepts the received data as an argument.
    -- on_build_output = nil,

    -- quickfix = {
    --   pos = 'botright', -- Where to open quickfix
    --   height = 10, -- Height of the opened quickfix.
    --   only_on_error = false, -- Open quickfix window only if target build failed.
    -- },

    -- Copy compile_commands.json to current working directory.
    copy_compile_commands = false,

    -- DAP configuration.
    dap_configurations = {
      cppdbg = {
        type = "cppdbg",
        request = "launch",
        stopAtEntry = true,
      },
      windows_gdb_from_wsl = {
        type = 'cppdbg',
        request = 'launch',
        stopAtEntry = true,
        MIMode = 'gdb',
        miDebuggerServerAddress = function ()
          local host = vim.fn.systemlist({'grep', '-Po', '(?<=^nameserver )[\\.\\d]+', '/etc/resolv.conf'})
          return host[1] .. ':3333'
        end,
        miDebuggerPath = '/usr/bin/gdb-multiarch',
        miDebuggerArgs = '-exec load',
      },
      pico_debug = {
        type = 'cortex-debug',
        request = 'launch',
        servertype = 'openocd',
        runToMain = true,
        device = 'RP2040',
        postRestartCommands = {
          'break main',
          'continue'
        },
        configFiles = {
          'interface/picoprobe.cfg',
          'target/rp2040.cfg'
        },
        executable = function ()
          local project_config = CMakeProjectConfig.new()
          local _, target, _ = project_config:get_current_target()
          return target and target.filename
        end,
        -- @TODO: Set paths in a relative way
        gdbPath = '/mnt/c/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/11.2 2022.02/bin/arm-none-eabi-gdb.exe',
        svdFile = '/home/osksod/documents/nep-projects/lightlab/liquinex/external/pico-sdk/src/rp2040/hardware_regs/rp2040.svd',
        searchDir = {
          '/mnt/c/Users/osksod/Documents/tools/pico-tools/openocd-branch-rp2040-f8w14ec-windows/tcl'
        }
      }
    },
    dap_configuration = 'cppdbg_vscode',

    -- Command to run after starting DAP session.
    -- You can set it to `false` if you don't want to open anything
    dap_open_command = false,
    }
end

return {
  {
    "Shatur/neovim-cmake", opts = cmake_opts,
    dependencies = { 'nvim-lua/plenary.nvim' }
  }
}
