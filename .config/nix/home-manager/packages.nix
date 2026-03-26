{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors / Shells
    neovim
    fish

    # Shell tools
    bat
    eza
    fd
    fzf
    ripgrep
    zoxide
    tree
    wget
    tlrc # tldr
    curlie # curl の代替
    ni # @antfu/ni

    # Git tools
    delta
    lazygit
    ghq
    gh

    # Dev tools
    docker
    docker-compose
    act # GitHub Actions をローカルで実行するツール
    vhs
    # mise

    # Python tools
    uv

    # Surveillance tools
    bottom
    btop
    yazi

    # Media tools
    ffmpeg
    yt-dlp
    imagemagick

    # joke tools
    cowsay
    figlet
    lolcat
    nyancat

    # Fonts
    udev-gothic-nf
  ];
}
