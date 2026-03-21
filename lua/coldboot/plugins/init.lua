-- Single plugin-spec entrypoint.
-- Keep plugin specs here; keep behavior in `lua/coldboot/config/*`.
return { -- Git related plugins
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    keys = {
      {
        '<leader>gs',
        function()
          require('neogit').open()
        end,
        desc = '[G]it [S]tatus',
      },
    },
    opts = {
      kind = 'tab',
      integrations = {
        diffview = true,
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
      { '<leader>gD', '<cmd>DiffviewClose<cr>', desc = '[G]it [D]iff close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it file [H]istory' },
    },
    opts = function()
      local actions = require 'diffview.actions'
      local fold_descs = {
        za = 'Toggle fold',
        zA = 'Toggle fold recursively',
        ze = 'Eliminate all folds',
        zE = 'Eliminate all folds',
        zo = 'Open fold',
        zc = 'Close fold',
        zO = 'Open fold recursively',
        zC = 'Close fold recursively',
        zr = 'Reduce folding',
        zm = 'Fold more',
        zR = 'Open all folds',
        zM = 'Close all folds',
        zv = 'Open folds to reveal cursor',
        zx = 'Reapply foldlevel and open to cursor',
        zX = 'Reapply foldlevel',
        zn = 'Disable folding',
        zN = 'Enable folding',
        zi = 'Toggle foldenable',
      }

      local fold_keymaps = {}
      for _, map in ipairs(actions.compat.fold_cmds) do
        local mode, lhs, rhs = map[1], map[2], map[3]
        local desc = fold_descs[lhs] or 'Fold command'
        fold_keymaps[#fold_keymaps + 1] = { mode, lhs, rhs, { desc = desc } }
      end

      return {
        keymaps = {
          view = fold_keymaps,
        },
      }
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  {
    'neovim/nvim-lspconfig',
  },
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonLog' },
    opts = {
      ui = {
        border = 'rounded',
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
  },
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
  {
    'stevearc/oil.nvim',
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, '.')
        end,
        is_always_hidden = function(name, bufnr)
          return false
        end,
        natural_order = true,
        sort = {
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
      },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
      { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle horizontal terminal' },
      { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle vertical terminal' },
    },
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = 'float',
      float_opts = {
        border = 'curved',
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = true,
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = {
          position = 'bottom',
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<C-l>',
          accept_word = false,
          accept_line = false,
          next = '<C-]>',
          prev = false,
          dismiss = '<C-x>',
        },
      },
      filetypes = {
        ['*'] = true,
        ['.'] = false,
      },
      copilot_node_command = 'node',
      server_opts_overrides = {},
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require 'coldboot.config.dap'
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      automatic_installation = false,
      handlers = {},
      ensure_installed = {
        'delve',
        'python',
        'js-debug-adapter',
      },
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  'tpope/vim-sleuth',
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = function()
      local settings = require 'coldboot.settings'
      return {
        settings = {
          tsserver_file_preferences = settings.ts.tsserver_file_preferences,
        },
        handlers = {
          ['textDocument/inlayHint'] = vim.lsp.handlers['textDocument/inlayHint'],
        },
      }
    end,
  },
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = {
          text = '+',
        },
        change = {
          text = '~',
        },
        delete = {
          text = '_',
        },
        topdelete = {
          text = '‾',
        },
        changedelete = {
          text = '~',
        },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, {
          buffer = bufnr,
          desc = 'Preview git hunk',
        })

        -- don't override the built-in diff keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, {
          expr = true,
          buffer = bufnr,
          desc = 'Jump to next hunk',
        })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, {
          expr = true,
          buffer = bufnr,
          desc = 'Jump to previous hunk',
        })
      end,
    },
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.ruvbox_material_background = 'hard'
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {},
  }, -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {},
  }, -- Fuzzy Finder (files, lsp, etc)
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'c',
          'cpp',
          'go',
          'lua',
          'python',
          'rust',
          'html',
          'tsx',
          'javascript',
          'json',
          'yaml',
          'typescript',
          'vimdoc',
          'vim',
          'hcl',
          'terraform',
          'markdown_inline',
          'toml',
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end,
  },
}
