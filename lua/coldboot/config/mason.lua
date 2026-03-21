local settings = require 'coldboot.settings'

if vim.g.vscode then
  return
end

local ok, mason = pcall(require, 'mason')
if not ok then
  return
end

mason.setup {
  ui = { border = 'rounded' },
}

-- Auto-install tools/servers listed in settings via mason-tool-installer.
-- This avoids custom registry plumbing and keeps the list user-configurable.
local ok_installer, installer = pcall(require, 'mason-tool-installer')
if ok_installer then
  installer.setup {
    ensure_installed = settings.mason.ensure_installed,
    auto_update = false,
    run_on_start = true,
    start_delay = 0,
    debounce_hours = 24,
  }
else
  -- Fallback: no auto-installer available, but mason UI still works.
end
