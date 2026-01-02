local M = {}

M.lsp = {
  inlay_hints = {
    enable = true,
    toggle_key = '<leader>ih',
  },

  -- Servers managed by native `vim.lsp.enable()`.
  -- TS/JS is handled by typescript-tools.nvim, so ts_ls is intentionally not here.
  servers = {
    'gopls',
    'pyright',
    'rust_analyzer',
    'dockerls',
    'terraformls',
    'tflint',
    'yamlls',
    'jsonls',
    'bashls',
  },

  disable = {
    ts_ls = true,
  },
}

M.terraform = {
  prefer_git_root = true,
  fallback_markers = {
    '.terraform',
    '.tflint.hcl',
    '.terraform.lock.hcl',
    'terraform.tfstate',
    'terraform.tfstate.d',
  },
  skip_filetypes = {
    'DiffviewFiles',
    'DiffviewFileHistory',
    'DiffviewFilePanel',
  },
  freeze_workspace_folders = true,
}

M.ts = {
  tsserver_file_preferences = {
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  },
}

M.lint = {
  -- BufWritePost only (user confirmed)
  events = { 'BufWritePost' },
  linters_by_ft = {
    go = { 'golangcilint' },
    javascript = { 'eslint' },
    typescript = { 'eslint' },
    javascriptreact = { 'eslint' },
    typescriptreact = { 'eslint' },
    python = { 'ruff' },
    dockerfile = { 'hadolint' },
    terraform = { 'tflint' },
  },
}

M.format = {
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    go = { 'goimports', 'gofmt' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    python = { 'isort', 'black' },
    rust = { 'rustfmt' },
    terraform = { 'terraform_fmt' },
  },
}

M.mason = {
  -- Install these via Mason (auto-on-start).
  ensure_installed = {
    -- LSP servers
    'gopls',
    'rust-analyzer',
    'pyright',
    'dockerfile-language-server',
    'terraform-ls',
    'tflint',
    'yaml-language-server',
    'json-lsp',
    'bash-language-server',

    -- Linters/formatters
    'golangci-lint',
    'ruff',
    'hadolint',
    'prettier',
    'black',
    'isort',
    'goimports',
  },
}

return M
