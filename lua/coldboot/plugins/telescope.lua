return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      {
        '<leader>?',
        function()
          require('fzf-lua').oldfiles()
        end,
        desc = '[?] Find recently opened files',
      },
      {
        '<leader><space>',
        function()
          require('fzf-lua').buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          require('fzf-lua').blines()
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>gf',
        function()
          require('fzf-lua').git_files()
        end,
        desc = 'Search [G]it [F]iles',
      },
      {
        '<leader>sf',
        function()
          require('fzf-lua').files()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sh',
        function()
          require('fzf-lua').help_tags()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sw',
        function()
          require('fzf-lua').grep_cword()
        end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function()
          require('fzf-lua').diagnostics_workspace()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function()
          require('fzf-lua').resume()
        end,
        desc = '[S]earch [R]esume',
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local fzf = require 'fzf-lua'

      fzf.setup {
        files = {
          fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        },
        grep = {
          rg_opts = [[--column --line-number --no-heading --color=never --smart-case --hidden --glob !.git/]],
        },
      }
    end,
  },
}
