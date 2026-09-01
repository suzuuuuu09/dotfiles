# Separate Neovim development-tool responsibilities

Nix is the source of truth for every executable Neovim starts, including LSP servers, formatters, linters, DAP adapters, CLI tools, and runtimes. Home Manager exposes Neovim-specific executables through `programs.neovim.extraPackages`; lazy.nvim manages plugins; Lua configures and enables LSPs with `vim.lsp.config` and `vim.lsp.enable`; and Conform invokes formatters on save. none-ls remains only for `cpplint` diagnostics. Mason and its installer bridges are not used.

This consolidates executable versions across macOS and WSL and keeps runtime installation out of the editor. `nixd` replaces `nil_ls`; its `nixpkgs.expr` reads the locked `inputs.nixpkgs` from this flake so Nix package versions can appear as inlay hints. LSP formatting remains disabled when Conform has a formatter and falls back to the LSP only when no external formatter is available.
