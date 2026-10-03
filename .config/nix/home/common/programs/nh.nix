{ config, ... }: {
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/dotfiles";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep-one";
    };
  };
}
