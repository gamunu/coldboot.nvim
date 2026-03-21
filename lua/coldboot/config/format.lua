local settings = require 'coldboot.settings'

if vim.g.vscode then
  return
end

local ok, conform = pcall(require, 'conform')
if not ok then
  return
end

conform.setup {
  format_on_save = settings.format.format_on_save,
  formatters_by_ft = settings.format.formatters_by_ft,
}

vim.api.nvim_create_user_command('Format', function(args)
  conform.format {
    async = false,
    lsp_format = 'fallback',
    timeout_ms = settings.format.format_on_save.timeout_ms,
    range = args.count > 0 and { start = { args.line1, 0 }, ['end'] = { args.line2, 0 } } or nil,
  }
end, { range = true, desc = 'Format current buffer (Conform/LSP)' })
