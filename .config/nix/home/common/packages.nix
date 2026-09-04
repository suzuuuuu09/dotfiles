{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors / Shells / Prompt
    git
    fish
    tmux
    # Homebrewの方でインストールする
    # herdr

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
    jq
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
    cargo-commitlint
    jujutsu
    hunk

    # Dev tools
    # docker
    # docker-compose
    act # GitHub Actions をローカルで実行するツール
    ttyd
    just
    typescript # typescript-tools.nvimで必要
    # mise
    uv # Python
    cxr
    bun
    pnpm
    nodejs_24
    python3
    comma

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

    # PDF Viewer
    tdf

    # Fonts
    udev-gothic
    udev-gothic-nf
    nerd-fonts.symbols-only
  ];
}
