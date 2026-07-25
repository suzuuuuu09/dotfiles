# Share Home Manager configuration across macOS and WSL

Build macOS and NixOS-WSL from one flake and share CLI, Fish, Neovim, dotfiles, and Agent Skills through the `home/common` Home Manager configuration. Separate repositories and configurations per operating system would reduce conditionals, but would split updates and verification of the same user environment, so that approach is not adopted. Put OS-specific configuration in `home/darwin`, `home/wsl`, and `hosts`, and put only behavior needed on both environments in `home/common`.
