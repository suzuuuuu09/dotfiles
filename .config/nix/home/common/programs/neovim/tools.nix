{
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withRuby = true;
    extraPackages = with pkgs; [
      bash-language-server
      biome
      clang-tools
      cpplint
      fish-lsp
      imagemagick
      jdt-language-server
      kulala-fmt
      lua-language-server
      nixd
      nixfmt
      prettier
      python3Packages.debugpy
      ruff
      rustfmt
      stylua
      svelte-language-server
      tailwindcss-language-server
      taplo
      ty
      typstyle
      typos-lsp
      vscode-langservers-extracted
    ];
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
