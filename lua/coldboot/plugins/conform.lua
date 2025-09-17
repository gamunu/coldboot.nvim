return {
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
    keys = {
      {
        -- Customize or remove this keymap to your liking
        '<leader>f',
        function()
          require('conform').format {
            async = true,
            lsp_fallback = true,
          }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        go = { 'goimports', 'gofmt' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        fish = { 'fish_indent' },
        toml = { 'taplo' },
        terraform = { 'terraform_fmt' },
        hcl = { 'terraform_fmt' },
        dockerfile = { 'dockerfmt' },
        sql = { 'sqlformat' },
        xml = { 'xmlformat' },
      },
      -- Set up format-on-save
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
