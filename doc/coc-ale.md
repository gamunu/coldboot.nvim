# IDE setup (Coc.nvim + ALE)

This config uses:

- **coc.nvim** for language servers, completion, code actions, rename, etc.
- **ALE** for linting/fixing and displaying diagnostics (Coc sends diagnostics to ALE).

## Where things are configured

- Plugin + keymaps: `lua/coldboot/plugins/coc_ale.lua`
- Coc settings (inlay hints, insert/replace mode, etc): `coc-settings.json`

## Keymaps (kept from the previous LSP setup)

Navigation / actions:

- `gd` definition
- `gD` declaration
- `gI` implementation
- `gr` references
- `K` hover
- `<C-k>` signature help
- `<leader>rn` rename
- `<leader>ca` code action (normal/visual)
- `<leader>D` type definition
- `<leader>ds` document symbols (`:CocList outline`)
- `<leader>ws` workspace symbols (`:CocList -I symbols`)

Formatting:

- `<leader>f` format buffer (Coc format, falls back to `:ALEFix`)
- `:Format` same as above
- `:ColdbootFormatToggle` toggles ALE fix-on-save

## Completion (IntelliJ-like)

In insert mode:

- `<C-n>` / `<C-p>`: if completion menu is visible, move selection; otherwise trigger completion.
- `<CR>`: accept completion **without overwriting** text to the right of the caret (“insert”).
- `<Tab>`: accept completion and **overwrite** the word to the right of the caret (“replace”).

## Inlay hints

Inlay hints are enabled via `coc-settings.json`.

- Toggle for the current buffer: `:CocCommand document.toggleInlayHint`

## Useful commands

- `:CocInfo` show Coc status
- `:CocConfig` edit Coc settings
- `:ALEInfo` show ALE status
- `:Mason` install/update LSP binaries (this config auto-installs `gopls`, `rust-analyzer`, `pyright`)

## Notes on external tools

ALE fixers/linters call external binaries (e.g. `eslint`, `prettier`, `golangci-lint`, `rustfmt`, `black`, `ruff`).
Install them per project (recommended) or globally so ALE can run them.
