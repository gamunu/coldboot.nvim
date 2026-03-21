local settings = require 'coldboot.settings'

if vim.g.vscode then
  return
end

local ok, lint = pcall(require, 'lint')
if not ok then
  return
end

lint.linters_by_ft = settings.lint.linters_by_ft

local group = vim.api.nvim_create_augroup('ColdbootLint', { clear = true })
vim.api.nvim_create_autocmd(settings.lint.events, {
  group = group,
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_user_command('Lint', function()
  lint.try_lint()
end, { desc = 'Run configured linters' })
