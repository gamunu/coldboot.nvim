-- NOTE  : this is where the neovim plugins are defined
-- if you are looking for vscode specific plugins look for the coldboot/vscode
-- directory
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
  'tpope/vim-sleuth', -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  -- LSP Configuration is now in lua/coldboot/plugins/lsp.lua
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
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
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
  },
}
