# Files

- [Agent and Codex environment](agent-environment.md) - Repository instruction surfaces, Codex configuration, local and external agent skills, selection rules, transformations, and installed runtime paths.
- [Shared Home Manager environment](common-home.md) - Shared user configuration imported by macOS, NixOS-WSL, and standalone WSL Home Manager outputs, including linked dotfiles, programs, packages, secrets, and skills.
- [macOS nix-darwin environment](macos.md) - Primary Apple Silicon target assembled by nix-darwin, Home Manager, Homebrew, host modules, and macOS-specific activation workarounds.
- [Local Nix packages and overlays](packages-and-overlays.md) - Repository-local package definitions exposed through flake overlays and consumed by shared or platform-specific configuration.
- [NixOS-WSL environment](wsl.md) - Auxiliary x86_64-linux target that combines NixOS-WSL, host settings, shared Home Manager modules, and WSL-specific browser and home-directory behavior.
