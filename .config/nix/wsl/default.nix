{pkgs, ...}: {
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  networking.hostName = "suzuWsl";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.fish.enable = true;

  users.users.nixos.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "26.05";
}
