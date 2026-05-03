{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors / Shells / Prompt
    neovim
    fish
    oh-my-posh
    tmux

    # Shell tools
    bat
    eza
    fd
    fzf
    ripgrep
    zoxide
    # tree
    wget
    # tlrc # tldr
    curlie # curl の代替
    ni # @antfu/ni
    direnv
    # hyperfine # ベンチマークツール
    gomi
    wakeonlan

    # Git tools
    delta
    lazygit
    ghq
    gh
    czg

    # Dev tools
    # docker
    # docker-compose
    act # GitHub Actions をローカルで実行するツール
    vhs
    just
    typescript # typescript-tools.nvimで必要
    # mise
    uv # Python

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
    comma
  ];
}
