{
  pkgs,
  username,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = username;
  };

  networking.hostName = "suzuWsl";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.fish.enable = true;

  users.users.${username}.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "26.05";
}
