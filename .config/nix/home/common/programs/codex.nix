{
  inputs,
  pkgs,
  config,
  ...
}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
  ];

  home.file = {
    ".codex/AGENTS.md".source = mkLink "codex/AGENTS.md";
  };
}
