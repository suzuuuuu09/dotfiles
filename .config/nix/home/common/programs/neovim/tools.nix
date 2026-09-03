{
  lib,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withRuby = true;
    extraPackages = with pkgs; [
      alejandra
      bash-language-server
      biome
      clang-tools
      cpplint
      fish-lsp
      jdt-language-server
      kulala-fmt
      lua-language-server
      nixd
      nixfmt
      prettier
      prettierd
      pyright
      python3Packages.debugpy
      ruff
      rustfmt
      stylua
      svelte-language-server
      tailwindcss-language-server
      taplo
      typstyle
      typos-lsp
      vscode-langservers-extracted
    ];
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
