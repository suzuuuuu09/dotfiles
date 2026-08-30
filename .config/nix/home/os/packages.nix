{pkgs, ...}: {
	home.packages = with pkgs; [
		wezterm
		slack
		discord
		herdr
	];
}
