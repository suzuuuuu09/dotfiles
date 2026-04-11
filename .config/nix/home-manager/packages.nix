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
    wakeonlan

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
    typescript # typescript-tools.nvimで必要
    # mise

    # Python tools
    uv

    # Surveillance tools
    bottom
    btop
    yazi

    # Media tools
    ffmpeg
    # NOTE: インストール時にdenoをインストールするため除外
    # 仮にインストールするなら、homebrewでインストールすることを検討
    # yt-dlp
    imagemagick

    # joke tools
    cowsay
    figlet
    lolcat
    # nyancat

    # PDF Viewer
    tdf

    # Fonts
    udev-gothic
    udev-gothic-nf

    # GUI tools
    # obsidian
  ];
}
