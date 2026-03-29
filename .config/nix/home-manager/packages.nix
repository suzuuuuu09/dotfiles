{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors / Shells / Prompt
    neovim
    fish
    oh-my-posh

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
    hyperfine # ベンチマークツール
    gomi

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
    # nyancat

    # PDF Viewer
    tdf

    # Fonts
    udev-gothic-nf

    # GUI tools
    obsidian
  ];
}
