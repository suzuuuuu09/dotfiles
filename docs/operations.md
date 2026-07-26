# Operating Procedures

This document describes how to bootstrap target environments, apply configuration changes, and verify changed areas. It does not transcribe individual application settings; it identifies the source of truth and application path to consult when making changes.

## Prerequisites

This repository is for a personal environment, not a general-purpose dotfiles template. User names, host names, and application locations contain environment-specific values.

Home Manager links are built assuming a checkout at `~/dotfiles`. Cloning elsewhere requires changing the Nix module that defines `dotfilesPath` at the same time.

Target environments that enable SOPS-managed configuration need the corresponding age private key at `~/.config/sops/age/keys.txt`. Never add the private key to the repository.

## Bootstrap

Enable flakes in Nix, then clone the repository to its fixed path.

```bash
git clone https://github.com/suzuuuuu09/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix flake check
```

On macOS, build the configuration before applying it with nix-darwin.

```bash
nix build --no-link .#darwinConfigurations.suzuMac.system
sudo darwin-rebuild switch --flake .#suzuMac
```

On NixOS-WSL, build the system closure before applying the NixOS configuration.

```bash
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#suzuWsl
```

To evaluate only the WSL Home Manager portion, use `homeConfigurations.nixos` or `homeConfigurations."nixos@suzuWsl"`. Both outputs refer to the same Home Manager configuration.

## Applying changes

How a change is applied depends on whether the file is a linked dotfile or a Nix module.

| Changed target | Application method | Direct verification |
| --- | --- | --- |
| Linked dotfile | Reload or restart the target application | Application-specific syntax check or startup confirmation |
| `home/common/` | Switch the target environment's Home Manager or system | `nix flake check` and the target configuration build |
| `home/darwin/`, `hosts/mac/` | `darwin-rebuild switch` | macOS system build |
| `home/wsl/`, `hosts/wsl/` | `nixos-rebuild switch` | WSL system build |
| `flake.nix`, `flake.lock`, overlays | Switch all affected configurations | Flake checks and both macOS and WSL builds |
| `skills/`, agent skill sources | Switch a configuration including Home Manager | After Nix evaluation, inspect `~/.agents/skills` |

Because these are out-of-store symlinks, a linked dotfile is reflected at its destination without waiting for a Nix rebuild. Reapply Home Manager after changing packages, link definitions, SOPS templates, or agent-skill configuration.

## Updating Nix dependencies

When updating flake inputs, update the lockfile and then build both target environments.

```bash
nix flake update
nix flake check
nix build --no-link .#darwinConfigurations.suzuMac.system
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
```

`flake.lock` records the resolution of Nix, Home Manager, nix-darwin, NixOS-WSL, and external agent skills. After updating it, verify both macOS and WSL as well as the configurations closest to the changed input. [ADR 0015](adr/0015-pin-and-automate-dependency-updates.md) records the decision to pin dependencies and leave update proposals to Renovate.

## Updating Homebrew

Homebrew-managed applications are declared in `.config/nix/home/darwin/homebrew.nix`. Applying the macOS configuration refreshes Homebrew metadata and upgrades managed formulae, casks, and Mac App Store applications. Cleanup remains disabled so applications outside the managed set are not removed.

Apply the macOS configuration to update the managed Homebrew packages.

```bash
darwin-rebuild switch --flake .#suzuMac
```

`manualCasks` remain outside automated installation, updates, and removal. Self-updating casks use their own update mechanism; a cask that cannot update itself and whose current version Homebrew cannot detect may be marked `greedy` individually in `managedCasks`.

## Restoring Neovim plugins

Neovim plugin resolution is pinned in `.config/nvim/lazy-lock.json`. The CI-equivalent restoration procedure is:

```bash
nix shell nixpkgs#neovim nixpkgs#git -c \
  ./scripts/nvim-restore.sh ~/.config/nvim

nix shell nixpkgs#neovim nixpkgs#git -c \
  nvim --headless "+qa"
```

The restoration script uses Lazy.nvim to restore the state in the lockfile. When updating plugins, review the changed lockfile as part of the diff. [ADR 0011](adr/0011-manage-neovim-plugins-with-lazy-nvim.md) records why plugins are restored through lazy.nvim instead of Nix.

## Verification by change area

The repository-wide default verification is `nix flake check`.

```bash
nix flake check
```

For a limited change, run the directly affected verification first. Add the target configuration build when changing a flake or common module.

| Change area | Minimum verification |
| --- | --- |
| Nix | `nix flake check` |
| macOS system | `nix build --no-link .#darwinConfigurations.suzuMac.system` |
| NixOS-WSL | `nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel` |
| Neovim | `nvim --headless "+qa"` after restoring plugins |
| WezTerm | Load the configuration as in `.github/workflows/wezterm-linter.yaml` |
| Homebrew manifest | `nix build --no-link .#darwinConfigurations.suzuMac.system` |
| GitHub Actions | The flake's `actionlint` check |
| Python skill scripts | The flake's `ruff` check |

`nix fmt` rewrites files. When the worktree already has uncommitted changes, confirm its scope before running it.

## Secrets

Manage `.config/nix/secrets/secrets.yaml` only in encrypted form. Do not open it during routine investigation, review, or documentation work.

Home Manager generates `.wakatime.cfg` from a SOPS placeholder. Neither the generated file nor the age private key is managed by Git.

GitHub Actions tokens and private keys are supplied to workflows through GitHub Secrets. Do not put secret values in workflows, logs, or local template files.

## Troubleshooting

When a configuration change does not take effect, first verify its application path.

1. Use `readlink` to confirm that the target points to `~/dotfiles`.
2. Check whether the target appears in `.config/nix/home/common/dotfiles.nix` or in a Darwin-specific link definition.
3. Reload the target application if it uses a linked dotfile.
4. Build the target configuration and switch it after a successful build if it uses a Nix module.

When Nix evaluation fails, build the macOS and WSL outputs separately. If only one fails, inspect platform or host module changes before `home/common/`.

When Neovim fails to start, restore plugins from the lockfile and then run headless startup. If a Homebrew application does not update, confirm that it is a managed application and check whether it relies on its own updater or needs an individual `greedy` setting.

If an agent skill is missing, inspect the sources and selection rules in `.config/nix/home/common/agent-skills.nix`, then reapply a configuration that includes Home Manager.
