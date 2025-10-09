-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the coldboot.nvim README for more information

-- Register and clipboard keymaps
vim.keymap.set('n', '<leader>vr', ':registers<CR>', { desc = '[V]iew [R]egisters' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = '[P]aste from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = '[P]aste before from system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })

-- Register history access (using <leader>v for View/registers)
vim.keymap.set('n', '<leader>vp', '"1p', { desc = '[V]iew history [P]aste (most recent delete)' })
vim.keymap.set('n', '<leader>v1', '"1p', { desc = '[V]iew history paste [1]' })
vim.keymap.set('n', '<leader>v2', '"2p', { desc = '[V]iew history paste [2]' })
vim.keymap.set('n', '<leader>v3', '"3p', { desc = '[V]iew history paste [3]' })
vim.keymap.set('n', '<leader>v4', '"4p', { desc = '[V]iew history paste [4]' })
vim.keymap.set('n', '<leader>v5', '"5p', { desc = '[V]iew history paste [5]' })

-- Quick access to yank register
vim.keymap.set('n', '<leader>vy', '"0p', { desc = '[V]iew [Y]ank paste' })

-- View history registers
vim.keymap.set('n', '<leader>vh', ':reg 0-9<CR>', { desc = '[V]iew [H]istory registers' })

return {}
