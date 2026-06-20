{config, ...}: {
  home = {
    stateVersion = "25.11";

    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };
  };

  programs.home-manager.enable = true;

  imports = [
    ./programs
    ./packages.nix
    ./sops.nix
    ./dotfiles.nix
    ./agent-skills.nix
  ];
}
