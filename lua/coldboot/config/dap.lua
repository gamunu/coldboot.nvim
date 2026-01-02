if vim.g.vscode then
  return
end

local ok_dap, dap = pcall(require, 'dap')
if not ok_dap then
  return
end

local ok_ui, dapui = pcall(require, 'dapui')
if ok_ui then
  dapui.setup()

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end

pcall(function()
  require('nvim-dap-virtual-text').setup()
end)

pcall(function()
  require('dap-go').setup()
end)

pcall(function()
  local js_debug_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'node',
      args = { js_debug_path, '${port}' },
    },
  }

  dap.configurations.javascript = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.typescript = dap.configurations.javascript
  dap.configurations.javascriptreact = dap.configurations.javascript
  dap.configurations.typescriptreact = dap.configurations.javascript
end)

local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('<F5>', dap.continue, 'DAP continue')
map('<F10>', dap.step_over, 'DAP step over')
map('<F11>', dap.step_into, 'DAP step into')
map('<F12>', dap.step_out, 'DAP step out')
map('<leader>db', dap.toggle_breakpoint, 'DAP toggle breakpoint')
map('<leader>dB', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, 'DAP conditional breakpoint')
map('<leader>dr', dap.repl.open, 'DAP open REPL')
map('<leader>dl', dap.run_last, 'DAP run last')

if ok_ui then
  map('<leader>du', dapui.toggle, 'DAP UI toggle')
end

map('<leader>dt', dap.terminate, 'DAP terminate')
