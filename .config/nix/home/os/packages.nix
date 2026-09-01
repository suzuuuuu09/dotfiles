{ pkgs, ... }: {
  home.packages = with pkgs; [
    wezterm
    slack
    discord
    herdr

    #Hyprland
    waybar
    fuzzel
    mako
    hyprpaper
    hyprlock
    hypridle
    hyprpolkitagent
    wl-clipboard
    grim
    slurp
    pavucontrol
    kitty
  ];
}
