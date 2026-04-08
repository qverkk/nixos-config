# tmux module

This directory keeps tmux config portable between NixOS and non-Nix hosts.

## Layout

- `home.nix`: Home Manager wiring (`programs.tmux`) and script installation into
  `~/.config/tmux/scripts/`.
- `tmux.conf`: interactive tmux settings and keybindings.
- `scripts/`: shell scripts called by tmux hooks and popup bindings.

## Script responsibilities

- `rename-new-session.sh`: `session-created` hook; enforces session names like
  `<project>__<worktree-slug>`.
- `worktree-new.sh`: `prefix + f`; pick/create git branch worktree under
  `<repo>/.workflow/`, then switch to a tmux session for that branch.
- `fzf-switch-session.sh`: `prefix + s`; fuzzy session picker.
- `fzf-switch-window.sh`: `prefix + w`; fuzzy window picker.
- `fzf-list-keys.sh`: `prefix + ?`; searchable keybinding list.
- `copy-to-system.sh`: copy-mode yank target; auto-detects wl-copy/pbcopy/xclip/xsel.

## Conventions

- Keep scripts POSIX `sh` compatible (`#!/usr/bin/env sh`, no bash arrays).
- Do not hardcode Nix store paths in `tmux.conf` or scripts.
- Put behavior in scripts, keep `home.nix` focused on wiring.
