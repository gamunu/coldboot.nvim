local M = {}

function M.is_virtual_uri(uri)
  return type(uri) == 'string' and uri:match '^%w[%w+.-]*://' ~= nil
end

function M.is_diffview_buffer(bufnr)
  if type(bufnr) ~= 'number' or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  if type(ft) == 'string' and ft:match '^Diffview' then
    return true
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  return type(name) == 'string' and name:match '^diffview://' ~= nil
end

function M.root_dir(fname, opts)
  if type(fname) ~= 'string' or fname == '' then
    return nil
  end

  opts = opts or {}

  if opts.prefer_git_root then
    local git_root = vim.fs.root(fname, { '.git' })
    if git_root then
      return git_root
    end
  end

  if opts.fallback_markers and #opts.fallback_markers > 0 then
    local marker_root = vim.fs.root(fname, opts.fallback_markers)
    if marker_root then
      return marker_root
    end
  end

  return vim.fs.dirname(fname)
end

return M
