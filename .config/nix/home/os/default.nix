{username, ...}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
