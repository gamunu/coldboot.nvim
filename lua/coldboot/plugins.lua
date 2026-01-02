-- Single entrypoint for all non-vscode plugins.
-- Keep plugin definitions here; keep behavior in `lua/coldboot/config/*`.
return {
  { import = 'coldboot.plugins' },
}
