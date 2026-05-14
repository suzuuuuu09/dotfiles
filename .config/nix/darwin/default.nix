{...}: {
  imports = [
    ./system.nix
    ./homebrew.nix
    ./macskk.nix
  ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; # tmux内で必要
  };
}
