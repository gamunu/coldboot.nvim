-- Compatibility shim so init.lua can keep using Lazy imports.
-- New layout encourages a single plugins entrypoint (`coldboot/plugins.lua`).
return {
  { import = 'coldboot.plugins' },
}
