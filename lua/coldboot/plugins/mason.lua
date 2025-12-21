return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonLog' },
    opts = {
      ui = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      local ok, mason = pcall(require, 'mason')
      if not ok then
        return
      end

      mason.setup(opts)

      local registry_ok, registry = pcall(require, 'mason-registry')
      if not registry_ok then
        return
      end

      -- Keep this list small: just the server binaries Coc commonly uses.
      local ensure_installed = {
        -- LSP Servers
        'gopls',
        'rust-analyzer',
        'pyright',
        'typescript-language-server',
        'eslint-lsp',
        'dockerfile-language-server',
        'terraform-ls',

        -- Linters & Formatters
        'black',
        'isort',
        'ruff',
        'goimports',
        'golangci-lint',
        'prettier',
        'hadolint',
        'tflint',
      }

      local function install(pkg_name)
        local pkg = registry.get_package(pkg_name)
        if pkg:is_installed() then
          return
        end
        pkg:install()
      end

      if registry.refresh then
        registry.refresh(function()
          for _, pkg_name in ipairs(ensure_installed) do
            pcall(install, pkg_name)
          end
        end)
      else
        for _, pkg_name in ipairs(ensure_installed) do
          pcall(install, pkg_name)
        end
      end
    end,
  },
}
