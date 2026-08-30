{username, ...}: {
	imports = [
	  ./packages.nix
		./programs
	];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
