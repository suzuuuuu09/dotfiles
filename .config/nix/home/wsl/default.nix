{username, ...}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    sessionVariables = {
      BROWSER = "explorer.exe";
    };
  };
}
