# Distribute dotfiles through out-of-store symlinks

Home Manager creates out-of-store symlinks from `~/dotfiles` to their destinations instead of copying configuration files into the Nix store. The repository is the configuration source of truth, so changes are reflected immediately; placing it at the short, stable path `~/dotfiles`, outside the usual ghq layout, also makes it available from the earliest setup stage. Consequently, this repository does not support applying configuration from arbitrary checkout paths or distributing it solely from the Nix store.
