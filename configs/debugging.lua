local sign = vim.fn.sign_define
local fn = vim.fn
local dap, dapui = require('dap'), require('dapui')
local mason_registry = require('mason-registry')
local icons = require 'custom.configs.icons'

local M = {}

-- These are to override the default highlight groups for catppuccin (see https://github.com/catppuccin/nvim/#special-integrations)
sign('DapBreakpoint', { text = icons.ui.Bug, texthl = 'DapBreakpoint', linehl = '', numhl = '' })
sign('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
sign('DapBreakpointCondition', {
  text = '●',
  texthl = 'DapBreakpointCondition',
  linehl = '',
  numhl = ''
})
sign('DapBreakpointRejected', {
  text = icons.ui.Bug,
  texthl = 'DiagnosticSignError',
  linehl = '',
  numhl = '',
})
sign('DapStopped', {
  text = icons.ui.BoldArrowRight,
  texthl = 'DiagnosticSignWarn',
  linehl = 'Visual',
  numhl = 'DiagnosticSignWarn',
})

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- dap adapters and configurations

-- rust
-- local codelldb_root = mason_registry.get_package('codelldb'):get_install_path() .. '/extension'
-- local codelldb_path = codelldb_root .. '/adapter/codelldb'
-- local liblldb_path = codelldb_root .. '/lldb/lib/liblldb.dylib'

-- javascript
local js_debug_adapter = mason_registry.get_package('js-debug-adapter'):get_install_path() ..
    '/js-debug/src/dapDebugServer.js'

local adapters = {
  -- codelldb = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
  ['pwa-node'] = {
    host = '127.0.0.1',
    port = '${port}',
    type = 'server',
    executable = { command = 'node', args = { js_debug_adapter, '${port}', } }
  },
}

local configurations = {
  -- rust = {
  --   {
  --     name = 'Debug',
  --     type = 'codelldb',
  --     request = 'launch',
  --     preLaunchTask = 'cargo build',
  --     program = function()
  --       return fn.input('Path to executable: ', fn.getcwd() .. '/target/debug/', 'file')
  --     end,
  --     cwd = '${workspaceFolder}',
  --     terminal = 'integrated',
  --     stopOnEntry = false,
  --     showDisassembly = 'never',
  --     runInTerminal = false
  --   }
  -- },
  javascript = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug JavaScript',
      program = '${file}',
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Run this test - Jest',
      runtimeExecutable = 'node',
      runtimeArgs = {
        './node_modules/jest/bin/jest.js',
        '--runInBand',
      },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
      smartStep = true,
    },
  },
  typescript = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug TypeScript',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      outFiles = { '${workspaceFolder}/dist/**/*.js' },
      runtimeExecutable = '${workspaceFolder}/node_modules/.bin/ts-node',
      resolveSourceMapLocations = { '${workspaceFolder}/dist/**/*.js', '${workspaceFolder}/**',
        '!**/node_modules/**' },
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Run this test - Jest',
      runtimeExecutable = 'node',
      runtimeArgs = {
        './node_modules/jest/bin/jest.js',
        '--runInBand',
      },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
      smartStep = true,
      skipFiles = { '<node_internals>/**', 'node_modules/**' },
    },
  }
}

for adapter, config in pairs(adapters) do
  dap.adapters[adapter] = config
end

for lang, configuration in pairs(configurations) do
  dap.configurations[lang] = configuration
end

-- will not work without calling this
dapui.setup()

M.adapters = adapters
M.configurations = configurations

return M
