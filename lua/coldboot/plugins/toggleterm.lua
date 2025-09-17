return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle floating terminal' },
      { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle horizontal terminal' },
      { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle vertical terminal' },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section in the documentation
      open_mapping = [[<c-\>]], -- Lazy load on leader key press
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
}
