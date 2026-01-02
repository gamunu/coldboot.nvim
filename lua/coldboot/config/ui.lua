if vim.g.vscode then
  return
end

vim.o.laststatus = 2
vim.o.showmode = false

local M = {}

-- Mode names and highlight groups
local modes = {
  ['n'] = { name = 'NORMAL', hl = 'StatusLineMode' },
  ['i'] = { name = 'INSERT', hl = 'StatusLineModeInsert' },
  ['v'] = { name = 'VISUAL', hl = 'StatusLineModeVisual' },
  ['V'] = { name = 'V-LINE', hl = 'StatusLineModeVisual' },
  [''] = { name = 'V-BLOCK', hl = 'StatusLineModeVisual' },
  ['c'] = { name = 'COMMAND', hl = 'StatusLineModeCommand' },
  ['R'] = { name = 'REPLACE', hl = 'StatusLineModeReplace' },
  ['t'] = { name = 'TERMINAL', hl = 'StatusLineModeTerminal' },
}

function M.mode()
  local mode = vim.fn.mode()
  local m = modes[mode] or { name = mode, hl = 'StatusLine' }
  return '%#' .. m.hl .. '# ' .. m.name .. ' %#StatusLine#'
end

function M.git()
  local branch = vim.b.gitsigns_head
  if not branch or branch == '' then
    return ''
  end
  return '  ' .. branch .. ' '
end

function M.diagnostics()
  local counts = vim.diagnostic.count(0)
  if not counts or vim.tbl_isempty(counts) then
    return ''
  end

  local parts = {}
  local severity = vim.diagnostic.severity
  if (counts[severity.ERROR] or 0) > 0 then
    table.insert(parts, 'E' .. counts[severity.ERROR])
  end
  if (counts[severity.WARN] or 0) > 0 then
    table.insert(parts, 'W' .. counts[severity.WARN])
  end
  return #parts > 0 and ' ' .. table.concat(parts, ' ') .. ' ' or ''
end

function M.lsp()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return ''
  end
  return ' LSP '
end

function M.statusline()
  return table.concat {
    M.mode(),
    M.git(),
    M.diagnostics(),
    M.lsp(),
    '%<', -- truncate point
    ' %f%m%r', -- filename, modified, readonly
    '%=', -- right align
    '%{&filetype} ', -- filetype
    '%l:%c ', -- line:col
    '%p%% ', -- percentage
  }
end

-- Set up highlight groups
local function setup_highlights()
  vim.api.nvim_set_hl(0, 'StatusLineMode', { link = 'Cursor' })
  vim.api.nvim_set_hl(0, 'StatusLineModeInsert', { link = 'DiffChange' })
  vim.api.nvim_set_hl(0, 'StatusLineModeVisual', { link = 'DiffAdd' })
  vim.api.nvim_set_hl(0, 'StatusLineModeReplace', { link = 'DiffDelete' })
  vim.api.nvim_set_hl(0, 'StatusLineModeCommand', { link = 'DiffText' })
  vim.api.nvim_set_hl(0, 'StatusLineModeTerminal', { link = 'DiffText' })
end

setup_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_highlights,
})

vim.o.statusline = "%{%v:lua.require('coldboot.config.ui').statusline()%}"

return M
