{
  pkgs,
  config,
  ...
}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  home.packages = with pkgs; [
    codex
  ];

  home.file = {
    ".codex/AGENTS.md".source = mkLink "codex/AGENTS.md";
  };
}
