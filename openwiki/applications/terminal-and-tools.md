---
type: application subsystem
title: Terminal and shell configuration
description: Linked shell, terminal, editor-adjacent, and command-line configuration managed through shared Home Manager links.
tags: [terminal, shell, cli]
---

# Terminal and shell configuration

The shared `dotfiles.nix` module links Fish, WezTerm, Ghostty, tmux, Oh My Posh, Git, GitHub CLI, lazygit, bat, btop, gomi, yazi, and related directories from `~/dotfiles` into XDG configuration paths. Home Manager owns the link declarations; each application consumes its linked directory at runtime. Neovim has a dedicated page because its lazy.nvim bootstrap and restore lifecycle are independently validated.

Fish’s `config.fish`, `tool_setup.fish`, `config/`, `conf.d/`, and `functions/` form the shell startup/function layers. The flake’s `fish-syntax` check runs `fish -n` over these paths. `scripts/nvim-restore.sh` is separately ShellCheck-covered, while WezTerm has a workflow that loads its configuration under a virtual display.

`.zshrc`, `.zshenv`, and `.zprofile` are linked as home files even though Fish is the configured primary shell. Do not infer that every repository `.config` directory is active: `.config/zsh`, `.config/vscode`, `.config/chezmoi`, and `.config/homebrew` are not linked by the common module.

## Change recipe and checks

For a terminal or shell change, edit the owning repository configuration, confirm its link in `.config/nix/home/common/dotfiles.nix`, and run `nix flake check`. Use the Fish syntax check for Fish files, the WezTerm workflow or its local equivalent for WezTerm, and a headless Neovim check for editor changes. The checkout path remains the key invariant: Home Manager expects `~/dotfiles`.
