{username, ...}: {
  imports = [
    ./packages.nix
    ./programs
    ./onepassword.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
