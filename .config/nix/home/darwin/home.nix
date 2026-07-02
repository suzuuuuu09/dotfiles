{
  config,
  username,
  ...
}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  imports = [
    ./home-manager-launchd.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";

    sessionVariables = {
      BROWSER = "open";
      HOMEBREW_PREFIX = "/opt/homebrew";
    };
  };

  targets.darwin.copyApps.enable = false;

  xdg.configFile = {
    "aerospace".source = mkLink ".config/aerospace";
    "borders".source = mkLink ".config/borders";
    "karabiner".source = mkLink ".config/karabiner";
  };
}
