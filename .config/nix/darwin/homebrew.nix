{...}: {
  nix-homebrew = {
    enable = true;
    # Apple Silicon (M1/M2/M3) 環境で Intel 版 Brew も使えるようにする
    enableRosetta = true;
    # 現在の macOS ユーザー名
    user = "k25012kk";
    # 既存の Homebrew インストールを自動で移行する
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    caskArgs.appdir = "/Applications";

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # 警告: "zap" を有効にすると、このファイルに書いていない
      # 手動で入れた Brew パッケージが削除されます。移行完了後に有効化するのが安全です。
      # cleanup = "zap";
    };

    brews = [
      "mas"
      "felixkratz/formulae/borders"
      "bjarneo/cliamp/cliamp"
    ];

    casks = [
      "nikitabobko/tap/aerospace"
      "alt-tab"
      "homerow"

      # Music
      "pear-devs/pear/pear-desktop" # Youtube Music クライアント
      "battery"

      # Terminal
      "wezterm@nightly"
      "ghostty"

      # Browser
      "vivaldi"

      # Input Method
      "macskk"

      # Launcher
      "raycast"

      # Communication
      "discord"
      "slack"
      "zoom"

      "karabiner-elements"
      "jordanbaird-ice"
      "obsidian"
      "parsec"
      "claude"
      "amical"
      "1password"

      # IDE
      "visual-studio-code"
      # "intellij-idea"
    ];

    # https://github.com/mas-cli/mas/issues/1221
    # masでインストールができないのでコメントアウト
    masApps = {
      # "RunCat" = 1429033973;
      # "Microsoft Outlook" = 985367838;
    };
  };
}
