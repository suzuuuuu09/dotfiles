{...}: {
  home.homeDirectory = /Users/k25012kk;
  home.username = "k25012kk";
  home.stateVersion = "25.11";
  targets.darwin.copyApps.enable = false;

  imports = [
    ./packages.nix
    ./dotfiles.nix
    ./agent-skills.nix
    ./sops.nix
  ];

  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
