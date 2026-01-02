if vim.g.vscode then
  return
end

require 'coldboot.config.ui'
require 'coldboot.config.mason'
require 'coldboot.config.lsp'
require 'coldboot.config.lint'
require 'coldboot.config.format'
