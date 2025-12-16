return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    init = function()
      vim.g.coc_global_extensions = {
        'coc-tsserver',
        'coc-eslint',
        'coc-prettier',
        'coc-json',
        'coc-pyright',
        'coc-go',
        'coc-rust-analyzer',
      }

      local map = function(mode, lhs, rhs, desc, opts)
        opts = opts or {}
        opts.silent = opts.silent ~= false
        opts.remap = opts.remap ~= false
        opts.desc = desc
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      local term = function(keys)
        return vim.api.nvim_replace_termcodes(keys, true, false, true)
      end

      local delete_keyword_suffix = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.fn.col '.'
        local suffix_len = 0

        local i = col
        while i <= #line do
          local ch = line:sub(i, i)
          if ch:match '[%w_]' then
            suffix_len = suffix_len + 1
            i = i + 1
          else
            break
          end
        end

        if suffix_len == 0 then
          return ''
        end

        return string.rep(term '<Del>', suffix_len)
      end

      map('n', 'gd', '<Plug>(coc-definition)', 'Goto definition')
      map('n', 'gD', '<Plug>(coc-declaration)', 'Goto declaration')
      map('n', 'gI', '<Plug>(coc-implementation)', 'Goto implementation')
      map('n', 'gr', '<Plug>(coc-references)', 'Goto references')
      map('n', '<leader>rn', '<Plug>(coc-rename)', 'Rename')
      map('n', '<leader>ca', '<Plug>(coc-codeaction)', 'Code action')
      map('x', '<leader>ca', '<Plug>(coc-codeaction-selected)', 'Code action (selection)')
      map('n', '<leader>D', '<Plug>(coc-type-definition)', 'Type definition')
      map('n', '<leader>ds', '<cmd>CocList outline<cr>', 'Document symbols', { remap = false })
      map('n', '<leader>ws', '<cmd>CocList -I symbols<cr>', 'Workspace symbols', { remap = false })

      map('n', 'K', function()
        if vim.fn.exists '*CocActionAsync' == 1 then
          vim.fn.CocActionAsync 'doHover'
        else
          vim.cmd 'normal! K'
        end
      end, 'Hover')

      map('n', '<C-k>', '<Plug>(coc-signature-help)', 'Signature help')

      -- Completion: IntelliJ-like acceptance
      -- - Enter: accept with "insert" behavior (doesn't overwrite suffix)
      -- - Tab: accept with "replace" behavior (delete suffix, then confirm)
      vim.keymap.set('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], {
        silent = true,
        expr = true,
      })

      vim.keymap.set('i', '<Tab>', function()
        if vim.fn['coc#pum#visible']() == 1 then
          return delete_keyword_suffix() .. vim.fn['coc#pum#confirm']()
        end
        return term '<Tab>'
      end, { silent = true, expr = true })

      vim.keymap.set('i', '<S-Tab>', function()
        if vim.fn['coc#pum#visible']() == 1 then
          return vim.fn['coc#pum#prev'](1)
        end
        return term '<S-Tab>'
      end, { silent = true, expr = true })

      vim.keymap.set('i', '<C-n>', function()
        if vim.fn['coc#pum#visible']() == 1 then
          return vim.fn['coc#pum#next'](1)
        end
        vim.fn['coc#refresh']()
        return ''
      end, { silent = true, expr = true })

      vim.keymap.set('i', '<C-p>', function()
        if vim.fn['coc#pum#visible']() == 1 then
          return vim.fn['coc#pum#prev'](1)
        end
        vim.fn['coc#refresh']()
        return ''
      end, { silent = true, expr = true })

      map('n', '<leader>f', function()
        if vim.fn.exists '*CocActionAsync' == 1 then
          vim.fn.CocActionAsync 'format'
          return
        end
        if vim.fn.exists ':ALEFix' == 2 then
          vim.cmd 'ALEFix'
        end
      end, 'Format buffer', { remap = false })

      vim.api.nvim_create_user_command('Format', function()
        if vim.fn.exists '*CocActionAsync' == 1 then
          vim.fn.CocActionAsync 'format'
          return
        end
        if vim.fn.exists ':ALEFix' == 2 then
          vim.cmd 'ALEFix'
        end
      end, { desc = 'Format current buffer (Coc/ALE)' })
    end,
  },
  {
    'dense-analysis/ale',
    init = function()
      vim.g.ale_disable_lsp = 1
      vim.g.ale_use_neovim_diagnostics_api = 1
      vim.g.ale_completion_enabled = 0

      vim.g.ale_fix_on_save = 1
      vim.g.ale_fixers = {
        go = { 'gofmt', 'goimports' },
        javascript = { 'eslint', 'prettier' },
        typescript = { 'eslint', 'prettier' },
        javascriptreact = { 'eslint', 'prettier' },
        typescriptreact = { 'eslint', 'prettier' },
        rust = { 'rustfmt' },
        python = { 'isort', 'black' },
      }

      vim.g.ale_linters = {
        go = { 'golangci-lint' },
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
        rust = { 'clippy' },
        python = { 'ruff' },
      }

      local format_is_enabled = vim.g.ale_fix_on_save == 1
      vim.api.nvim_create_user_command('ColdbootFormatToggle', function()
        format_is_enabled = not format_is_enabled
        vim.g.ale_fix_on_save = format_is_enabled and 1 or 0
        print('Setting autoformatting to: ' .. tostring(format_is_enabled))
      end, {})
    end,
  },
}
