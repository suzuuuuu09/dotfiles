{lib, ...}: let
  trustedHomebrewTaps = [
    "bjarneo/cliamp"
    "felixkratz/formulae"
    "nikitabobko/tap"
    "pear-devs/pear"
    "mtgto/macskk"
  ];
in {
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
    taps = trustedHomebrewTaps;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      extraEnv = {
        # Homebrew trust state is stored under XDG_CONFIG_HOME when set.
        # nix-darwin activation runs brew under sudo, so pass it explicitly.
        XDG_CONFIG_HOME = "/Users/k25012kk/.config";
      };
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
      # "parsec"
      "claude"
      "amical"
      "1password"
      "shottr"
      "musescore"

      # "microsoft-powerpoint"
      # "microsoft-word"

      # IDE
      "visual-studio-code"
      "intellij-idea"

      # AI
      "codex-app"
    ];

    # https://github.com/mas-cli/mas/issues/1221
    # masでインストールができないのでコメントアウト
    masApps = {
      # "RunCat" = 1429033973;
      # "Microsoft Outlook" = 985367838;
    };
  };

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    # Keep Homebrew trust state in both lookup locations.
    install -d -m 0755 /Users/k25012kk/.homebrew
    install -d -m 0755 /Users/k25012kk/.config/homebrew
    chown k25012kk:staff /Users/k25012kk/.homebrew /Users/k25012kk/.config/homebrew

    cat > /Users/k25012kk/.homebrew/trust.json <<'EOF'
    ${builtins.toJSON {trustedtaps = trustedHomebrewTaps;}}
    EOF

    cp /Users/k25012kk/.homebrew/trust.json /Users/k25012kk/.config/homebrew/trust.json
    chown k25012kk:staff /Users/k25012kk/.homebrew/trust.json /Users/k25012kk/.config/homebrew/trust.json
    chmod 0600 /Users/k25012kk/.homebrew/trust.json /Users/k25012kk/.config/homebrew/trust.json
  '';
}
