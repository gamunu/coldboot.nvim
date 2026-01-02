local settings = require 'coldboot.settings'
local util = require 'coldboot.config.util'

if vim.g.vscode then
  return
end

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
}

local function terraform_root(fname)
  return util.root_dir(fname, {
    prefer_git_root = settings.terraform.prefer_git_root,
    fallback_markers = settings.terraform.fallback_markers,
  })
end

-- Disable ts_ls (handled by typescript-tools.nvim).
if settings.lsp.disable and settings.lsp.disable.ts_ls then
  vim.lsp.config.ts_ls = { cmd = { 'false' }, filetypes = {} }
end

-- gopls: inlay hints
vim.lsp.config.gopls = vim.tbl_deep_extend('force', vim.lsp.config.gopls or {}, {
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        rangeVariableTypes = true,
        constantValues = true,
      },
    },
  },
})

-- terraformls: root + diffview avoidance + freeze workspace folders
vim.lsp.config.terraformls = vim.tbl_deep_extend('force', vim.lsp.config.terraformls or {}, {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars' },
  init_options = {
    ignoreSingleFileWarning = true,
  },
  root_dir = function(fname, bufnr)
    if util.is_diffview_buffer(bufnr) then
      return nil
    end
    if type(fname) == 'string' and fname:match '^diffview://' then
      return nil
    end
    return terraform_root(fname)
  end,
})

vim.lsp.config.tflint = vim.tbl_deep_extend('force', vim.lsp.config.tflint or {}, {
  filetypes = { 'terraform' },
  root_dir = function(fname, bufnr)
    if util.is_diffview_buffer(bufnr) then
      return nil
    end
    if type(fname) == 'string' and fname:match '^diffview://' then
      return nil
    end
    return terraform_root(fname)
  end,
})

-- Common LspAttach behavior: keymaps + inlay hints + terraform workspace freeze
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('ColdbootLspAttach', { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Never keep terraform tooling attached in Diffview buffers.
    if util.is_diffview_buffer(bufnr) and (client.name == 'terraformls' or client.name == 'tflint') then
      pcall(vim.lsp.buf_detach_client, bufnr, client.id)
      return
    end

    if settings.lsp.inlay_hints and settings.lsp.inlay_hints.enable then
      if client.server_capabilities and client.server_capabilities.inlayHintProvider then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        vim.schedule(function()
          vim.cmd 'redraw'
        end)
      end

      local toggle_key = settings.lsp.inlay_hints.toggle_key
      if toggle_key and vim.fn.maparg(toggle_key, 'n') == '' then
        vim.keymap.set('n', toggle_key, function()
          local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
          vim.schedule(function()
            vim.cmd 'redraw'
          end)
        end, { buffer = bufnr, desc = 'Toggle inlay hints' })
      end
    end

    if settings.terraform.freeze_workspace_folders and (client.name == 'terraformls' or client.name == 'tflint') then
      client.server_capabilities.workspace = client.server_capabilities.workspace or {}
      client.server_capabilities.workspace.workspaceFolders = false
      client.server_capabilities.workspace.workspaceFoldersChangeNotifications = false
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')

    local fzf_ok, fzf = pcall(require, 'fzf-lua')
    if fzf_ok then
      map('n', 'gd', fzf.lsp_definitions, 'Goto definition')
      map('n', 'gD', fzf.lsp_declarations, 'Goto declaration')
      map('n', 'gI', fzf.lsp_implementations, 'Goto implementation')
      map('n', 'gr', fzf.lsp_references, 'Goto references')
      map('n', '<leader>D', fzf.lsp_typedefs, 'Type definition')
      map('n', '<leader>ds', fzf.lsp_document_symbols, 'Document symbols')
      map('n', '<leader>ws', fzf.lsp_workspace_symbols, 'Workspace symbols')
    else
      map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
      map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
      map('n', 'gI', vim.lsp.buf.implementation, 'Goto implementation')
      map('n', 'gr', vim.lsp.buf.references, 'Goto references')
      map('n', '<leader>D', vim.lsp.buf.type_definition, 'Type definition')
      map('n', '<leader>ds', vim.lsp.buf.document_symbol, 'Document symbols')
      map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('ColdbootLspFileType', { clear = true }),
  callback = function(event)
    local ft = vim.bo[event.buf].filetype

    if ft == 'terraform' or ft == 'terraform-vars' then
      if util.is_diffview_buffer(event.buf) then
        return
      end

      local clients = vim.lsp.get_clients { bufnr = event.buf, name = 'terraformls' }
      if #clients == 0 then
        pcall(vim.lsp.start, vim.lsp.config.terraformls, { bufnr = event.buf })
      end

      return
    end
  end,
})

vim.lsp.enable(settings.lsp.servers)
