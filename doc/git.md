# Git in Neovim (Neogit + Diffview)

This config uses **Neogit** as the Git UI (replacing Fugitive) and **Diffview** for diffs + merge conflict resolution.

## Entry points (this config)

- `\<leader>gs` → open Neogit status
- `\<leader>gd` → open Diffview
- `\<leader>gD` → close Diffview
- `\<leader>gh` → Diffview file history
- `\<leader>hp` → preview hunk (Gitsigns)

## Neogit: status, stage, commit

Open status: `\<leader>gs`

Common keys in the status buffer:

- `s` stage item under cursor
- `S` stage all unstaged
- `u` unstage item under cursor
- `U` unstage all staged
- `x` discard item under cursor
- `<c-r>` refresh
- `c` open commit popup (then pick an action)

## Neogit: merge + rebase

From Neogit status (`\<leader>gs`):

- `m` opens the merge popup (merge actions)
- `r` opens the rebase popup (rebase actions, continue/abort when in progress)

Neogit shows the available actions/keys in the popup window; follow those prompts.

## Conflicts (Diffview)

When you have conflicts, open Diffview: `\<leader>gd` and select a conflicted file.

In Diffview’s merge tool:

- Next/prev conflict: `]x` / `[x`
- Choose for the current conflict:
  - `\<leader>co` = choose ours
  - `\<leader>ct` = choose theirs
  - `\<leader>cb` = choose base
  - `\<leader>ca` = choose all (keep both)
  - `dx` = delete conflict region

After resolving:

1. Save (`:w`)
2. Stage in Neogit (`\<leader>gs`, then `s`/`S`)
3. Use Neogit’s rebase popup (`r`) to continue, or commit (via `c`) if you’re finishing a merge.

## Undo / back out

- Undo an edit: `u` (redo: `<c-r>`)
- Undo a conflict choice you just applied: `u`
- Discard file/hunk from Neogit status: `x`
- Abort an in-progress rebase/merge: use the `r`/`m` popup actions (Neogit will show “abort/continue” options when applicable).

