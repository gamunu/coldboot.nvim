-- Copilot.lua setup - a more customizable alternative to the official GitHub Copilot plugin
return {
  -- Main Copilot plugin
  {
    "zbirenbaum/copilot.lua",
    enabled = false, -- Disable Copilot
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },
        layout = {
          position = "bottom", -- | top | left | right
          ratio = 0.4
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        ["*"] = true,
        ["."] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 16.x
      server_opts_overrides = {},
    },
  },
  -- Configuration for copilot-cmp
  {
    "zbirenbaum/copilot-cmp",
    enabled = false, -- Disable Copilot completion
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      -- Load copilot_cmp after copilot is loaded
      require("copilot_cmp").setup()
    end,
  },
}