# Application Configuration and Operating Policy

Rather than transcribing application settings, this document describes each application's current role, the reasons for its configuration, and its application path. The repository files linked in each section are the configuration source of truth.

## Assumptions

macOS is the current primary environment. NixOS-WSL is an auxiliary target environment for using the shared user environment while working with Unity and similar tools on Windows. Maintaining WSL at the same frequency or level as macOS is not currently decided.

Home Manager exposes most shared configuration as out-of-store symlinks from `~/dotfiles`. Edits to linked dotfiles can therefore be read by their applications without waiting for Nix to be reapplied. Installation state and macOS-specific configuration are applied through Nix, nix-darwin, and Homebrew modules.

## Current roles

| Area | Current role | Source of truth or application path |
| --- | --- | --- |
| Shell | Fish is the primary shell. Zsh is not currently used. | [`config.fish`](../.config/fish/config.fish), [`dotfiles.nix`](../.config/nix/home/common/dotfiles.nix) |
| Terminal | WezTerm is the primary terminal. | [`wezterm/`](../.config/wezterm/) |
| Session management | Herdr is used; tmux is not currently used. | [`herdr/config.toml`](../.config/herdr/config.toml) |
| Terminal candidate | Ghostty is being evaluated. | [`ghostty/config`](../.config/ghostty/config) |
| Editor | Neovim is the primary editor and is set through environment variables. | [`nvim/`](../.config/nvim/), [`default.nix`](../.config/nix/home/common/default.nix) |
| Backup editor | VS Code configuration remains as a backup but is not currently used on macOS or WSL. | [`vscode/`](../.config/vscode/) |
| Window management | AeroSpace manages macOS window placement. | [`aerospace.toml`](../.config/aerospace/aerospace.toml) |
| Japanese input | macSKK is combined with azoo-key-skkserv, Karabiner, and macism. | [`macskk.nix`](../.config/nix/home/darwin/macskk.nix), [`karabiner.json`](../.config/karabiner/karabiner.json) |
| File operations | Yazi and gomi make ordinary deletion recoverable. | [`yazi/`](../.config/yazi/), [`gomi/config.yaml`](../.config/gomi/config.yaml) |
| Git operations | ghq, rebase, delta, lazygit, and czg are used together. | [`.gitconfig`](../.gitconfig), [`git/`](../.config/git/), [`lazygit/`](../.config/lazygit/) |

## Shells

### Fish

Fish is enabled in the shared user environment on macOS and WSL. It is the macOS login shell, WezTerm launch shell, and Neovim external shell; it is also the user's login shell on WSL.

[`config.fish`](../.config/fish/config.fish) disables the interactive greeting and sets XDG directories, `EDITOR`, `GIT_EDITOR`, and `VISUAL`. The Fish Nord theme provides the prompt, while detailed completions and path settings are split into [`config/`](../.config/fish/config/). Short aliases and abbreviations invoke alternative CLIs such as `fd`, `rg`, `eza`, `zoxide`, and `fzf`.

`rm` is aliased to `gomi` to prevent unintended permanent deletion. The `y` function changes to the directory selected when Yazi exits. `fzf` uses Nord colors and previews directories with `eza` and files with `bat`.

Fish is primary because it is the shell used daily on macOS. Preserving feature compatibility with Zsh is not a current operating requirement.

### Zsh

Home-directory `.zshenv`, `.zprofile`, and `.zshrc` files are linked by Home Manager. `.config/zsh` itself is not linked by the current module. This preserves past configuration without deleting it immediately; it does not indicate that Zsh is the current primary shell. Removing or reorganizing Zsh must be treated separately, including its linked home-directory files.

## Terminal and sessions

### WezTerm

WezTerm is the primary terminal on macOS. It starts Fish and configures UDEV Gothic 35NFLG, Nord, translucency, and background blur. Lua configuration is split for the tab bar, pane borders, and workspace switching.

The leader key is `Ctrl-q`. After the leader, `h/j/k/l` moves between panes, `r/d` splits panes, and `n/w` creates or selects workspaces. This aligns with the Vim-style navigation used in Neovim, AeroSpace, and Yazi.

### Herdr

Herdr groups agents, tabs, and panes into workspaces and is used instead of tmux for current session management. The agent panel is ordered by space, agent labels on pane borders are disabled, the terminal theme is used, and automatic theme switching is disabled.

The prefix is `Ctrl-s`. `prefix+Shift-l` opens lazygit in a popup and `prefix+Shift-b` opens the current repository on GitHub. Runtime artifacts such as session JSON, logs, and sockets are not managed in dotfiles because they are not configuration sources of truth.

### tmux

tmux configuration remains in the repository and is linked by Home Manager. It defines `Ctrl-a` as its prefix, pane navigation, and a Nord status line. However, daily use currently relies on Herdr rather than tmux, so this is retained configuration, not the active session-management path.

### Ghostty

Ghostty is managed through Homebrew and its configuration file is linked. Its current `config` is empty because the application is still being evaluated. As a possible WezTerm replacement, the evaluation covers Fish, macSKK, UDEV Gothic, a Nord-equivalent appearance, and Vim-style keys. WezTerm remains the primary terminal until that evaluation finishes.

## Interaction model and appearance

### Cross-application key bindings

Where possible, Neovim, WezTerm, Herdr, AeroSpace, and Yazi use Vim-style `h/j/k/l` navigation. Karabiner-Elements remaps Caps Lock to left Control. This keeps movement and mode switching familiar across applications. [ADR 0008](adr/0008-share-vim-style-navigation-across-apps.md) records the rationale.

### Colors and fonts

Nord is a preferred color scheme used to align the appearance of multiple applications; its dark background and contrast also aid everyday readability. UDEV Gothic is a preferred font, in part because it makes Japanese text and icons easy to read.

Nord-derived settings are used in Neovim, WezTerm, VS Code, Fish, fzf, bat, btop, Yazi, lazygit, delta, and tmux. UDEV Gothic-family fonts are installed with Nix and selected in Neovim, WezTerm, and VS Code.

## Window management

AeroSpace provides tiled window management on macOS. `Alt-h/j/k/l` moves focus and `Alt-Shift-h/j/k/l` moves windows. It switches between tiling and accordion layouts, floating only windows that need it.

Workspace initials identify their use: `B` for browsers, `C` for communication, `M` for music, `N` for notes, and `T` for terminals. Numbered workspaces remain available for work without a fixed purpose. Vivaldi, Slack, Discord, Obsidian, WezTerm, and YouTube Music are placed automatically in their corresponding workspaces at launch. Finder, System Settings, and browser picture-in-picture windows float.

JankyBorders starts after AeroSpace and marks the focused window with a border. A picture-in-picture follow script runs when switching workspaces.

## Keyboard and Japanese input

### Karabiner-Elements

Caps Lock is remapped to left Control. Pressing left Command alone sends alphanumeric mode; pressing right Command alone sends kana mode. Holding Command retains normal Command behavior. The standalone Command remapping is disabled in remote desktop applications so that the remote keyboard takes precedence.

### macSKK and azoo-key-skkserv

macSKK is the center of Japanese input; [ADR 0007](adr/0007-build-japanese-input-around-macskk.md) records why multiple tools are involved. Its settings are declared through nix-darwin `CustomUserPreferences`, while dictionaries and kana input rules are copied into the application container during activation. Dictionaries include general, place-name, personal-name, proper-noun, and emoji SKK dictionaries. [`kana-rule.conf`](../.config/macSKK/Settings/kana-rule.conf) is the source of truth for kana rules.

macSKK also configures Control-based movement and editing keys to align with the shell and editor. The SKK server is enabled at `127.0.0.1:1178`, and azoo-key-skkserv starts at login. macSKK and azoo-key-skkserv are managed by per-user macOS launchd jobs.

Neovim uses macism to return macSKK to alphanumeric input when Neovim loses focus, preventing Japanese input state from lingering after an application switch.

## Editors and development tools

### Neovim

Neovim is the primary editor and is assigned to `EDITOR`, `GIT_EDITOR`, and `VISUAL`. Its configuration is split into `config`, `plugins`, `after`, and snippets, and features load lazily. Plugin resolution is pinned in [`lazy-lock.json`](../.config/nvim/lazy-lock.json), with automatic update checks disabled at startup. [ADR 0011](adr/0011-manage-neovim-plugins-with-lazy-nvim.md) records why plugins are not integrated into Nix packages.

The mapleader is Space and maplocalleader is `,`. `Ctrl-h/j/k/l` moves windows; deletions and changes use the black-hole register. `x` operations cut to the system clipboard without polluting the register used by normal deletion. Fish is Neovim's external shell, and an autocmd returns macSKK to alphanumeric input.

LSP and development tools are split across layers. Nix supplies shared CLI and foundational tools on macOS and WSL, lazy.nvim manages Neovim plugins, Mason installs editor-specific LSP servers and tools at runtime, and Conform formats on save with LSP formatting as a fallback. [ADR 0012](adr/0012-separate-neovim-tool-responsibilities.md) records this boundary. `uv` in Mason's `generic_tools` duplicates a shared Nix package and is a future cleanup item. Copilot and Sidekick are configured as Neovim AI features, but their use is selected per task.

### VS Code

VS Code configuration remains in the repository as a backup and is currently unused on macOS and WSL. It retains UDEV Gothic, Nord-derived colors, Vim-style `Ctrl-h/j/k/l`, vscode-neovim integration, and Windows Git Bash terminal settings. It is not included in the current Home Manager dotfile links. Before using it again, first decide which target environments should receive the configuration.

### Runtime management

Nix is the source of truth for runtimes; [ADR 0005](adr/0005-manage-language-runtimes-with-nix.md) records this boundary. Common Nix packages include Node.js, Bun, Python, and uv to provide the same foundation on macOS and WSL. The `latest` setting in [`mise/config.toml`](../.config/mise/config.toml), Fish mise activation, and PATH configuration for nvm, nodebrew, and pyenv remain as former or fallback settings and are not maintained to the same level as Nix. Because current Fish configuration activates mise when it exists, moving to Nix-only runtime management requires separate cleanup.

## Supporting applications

[`nord-detailed.omp.json`](../.config/oh-my-posh/themes/nord-detailed.omp.json) is the Fish prompt theme and displays OS, shell, memory, Node.js, Python, AWS, CMake, and other status using Nord colors. Zsh specifies the same theme name, but Fish remains the primary shell.

[`lazygit/config.yml`](../.config/lazygit/config.yml) uses a Japanese UI and delta's Nord pager and can be launched as a Herdr popup. Its file view invokes `czg` and `czg ai` to assist with commit messages. [`gh/config.yml`](../.config/gh/config.yml) defaults to HTTPS and interactive prompts and aliases `gh co` to `gh pr checkout`. This document does not handle the contents of credential-bearing `hosts.yml`.

[`bat/config`](../.config/bat/config) uses Nord syntax highlighting, while [`btop/btop.conf`](../.config/btop/btop.conf) uses the Nord theme, true color, and a transparent background. They align terminal support displays with the WezTerm and Neovim color scheme.

[`cxr/img.yaml`](../.config/cxr/img.yaml) generates an OpenCV project template for image-processing assignments that are still in use. [`vde/layout/config.yml`](../.config/vde/layout/config.yml) defines a Report layout that places Neovim and tdf side by side, but vde is no longer used. cxr is treated as a current purpose-specific tool and vde as retained backup configuration; neither defines the primary environment's interaction model.

## File operations

Yazi is a file manager that shows hidden files and uses `h/j/k/l` to navigate directories and files. It integrates previews, fzf, and zoxide and launches from Fish's `y` function. Text opens with `$EDITOR`, with separate open operations for macOS, Linux, and Windows.

Yazi's `d` moves items to the trash; only `D` permanently deletes them. Fish also redirects `rm` to gomi, so ordinary deletion follows a recoverable path. This is a safety measure that limits permanent deletion to an explicit operation.

## Git and repository operations

The ghq root is fixed at `~/ghq` to standardize repository locations. Normal pulls use rebase with autostash enabled. delta displays diffs, lazygit is the entry point for interactive review and operation, and czg and czg ai assist with commit messages.

This Git operating policy standardizes repository locations, keeps history linear, and supports diff review and commit creation. The main Git configuration is the home-directory [`.gitconfig`](../.gitconfig); [`git/`](../.config/git/) contains attributes and ignore rules. When changing Git configuration, confirm whether it is read from the home file or the XDG directory.

## macOS application management

macOS GUI applications are not all subject to the same automation. [`homebrew.nix`](../.config/nix/home/darwin/homebrew.nix) separates Homebrew packages into managed and manual sets. Applying the macOS configuration updates managed formulae, casks, and Mac App Store applications, while cleanup remains disabled so manually maintained applications are not removed. Self-updating casks use their own updater, and only exceptional casks are marked `greedy` individually.

macSKK, azoo-key-skkserv, AeroSpace, WezTerm, Ghostty, and Herdr have macOS-specific installation paths. Karabiner-Elements, Vivaldi, Slack, Discord, Obsidian, and VS Code have their presence recorded in the manifest but are excluded from automated management. [ADR 0002](adr/0002-split-nix-and-homebrew-responsibilities.md) records why Nix and Homebrew responsibilities are separated.

Finder shows hidden files and external disks and opens new windows in the home directory. The Dock automatically hides and pins daily-use applications such as WezTerm, communication, note-taking, and utilities. These macOS defaults are managed in [`system.nix`](../.config/nix/home/darwin/system.nix).

## Files that are not configuration sources of truth

Presence in the repository does not mean a file is currently linked to an application. Before editing `.config/chezmoi`, `.config/homebrew`, `.config/macSKK`, `.config/vscode`, or `.config/zsh`, check the current Home Manager link definitions and activation paths. macSKK kana input rules are copied into the application container by macSKK activation rather than linked directly. VS Code and Zsh configurations remain, but are not treated as active primary-environment application configuration. Unused settings are retained as backups rather than deleted immediately, without preserving compatibility or operational verification with the active setup.

## Change checklist

First, use this document to confirm the application's current role. Next, inspect the source-of-truth file in the table and its Home Manager or nix-darwin application path. After changing only a linked dotfile, reload or restart the relevant application. After changing a Nix module, Homebrew manifest, macSKK activation, or agent skill, evaluate the target configuration before switching it. Before enabling a configuration marked unused, under evaluation, or retained as backup, update its current role first.

See [Architecture and Responsibilities](architecture.md) for repository-wide responsibilities and verification coverage, and [Operating Procedures](operations.md) for application commands and verification by change area.
