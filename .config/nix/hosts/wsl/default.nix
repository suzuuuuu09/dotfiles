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

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://cache.numtide.com"
    ];

    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  programs.fish.enable = true;

  users.users.${username}.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "26.05";
}
