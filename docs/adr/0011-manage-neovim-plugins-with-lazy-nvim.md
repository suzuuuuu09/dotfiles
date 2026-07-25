# Manage Neovim plugins with lazy.nvim

Install Neovim itself and foundational CLI tools with Nix; load Neovim plugins with lazy.nvim and pin their resolution in `lazy-lock.json`. Managing plugins as Nix packages would keep them inside Nix evaluation, but would disconnect them from Neovim's lazy-loading and update workflow, so that approach is not adopted. CI restores plugins from the lockfile and starts Neovim headlessly to confirm that the out-of-store distribution path is reproducible.
