{...}: {
  home.homeDirectory = /Users/k25012kk;
  home.username = "k25012kk";
  home.stateVersion = "25.11";
  targets.darwin.copyApps.enable = false;

  imports = [
    ./packages.nix
    ./dotfiles.nix
  ];

  programs = {
    home-manager.enable = true;
  };
}
