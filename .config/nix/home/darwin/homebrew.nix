{
  lib,
  username,
  ...
}: let
  trustedHomebrewTaps = [
    "bjarneo/cliamp"
    "felixkratz/formulae"
    "nikitabobko/tap"
    "pear-devs/pear"
    "mtgto/macskk"
  ];

  homebrewTaps =
    trustedHomebrewTaps
    ++ [
      "gitusp/azoo-key-skkserv"
    ];

  trustedHomebrewCasks = [
    "gitusp/azoo-key-skkserv/azoo-key-skkserv"
  ];

  # Installed by nix-darwin / Homebrew.
  managedBrews = [
    "mas"
    "herdr"
    "felixkratz/formulae/borders"
    "bjarneo/cliamp/cliamp"
  ];

  managedCasks = [
    "nikitabobko/tap/aerospace"
    "alt-tab"
    "homerow"
    "pear-devs/pear/pear-desktop"
    "battery"
    "wezterm@nightly"
    "ghostty"
    "macskk"
    "gitusp/azoo-key-skkserv/azoo-key-skkserv"
    "jordanbaird-ice"
    "musescore"
    "localsend"
    "shottr"
    "codex-app"
    "tailscale-app"
  ];

  # Kept out of Homebrew management on purpose.
  manualCasks = [
    "vivaldi"
    "raycast"
    "discord"
    "slack"
    "zoom"
    "karabiner-elements"
    "obsidian"
    "parsec"
    "amical"
    "1password"
    "visual-studio-code"
    "intellij-idea"
  ];

  # Conservative allowlist for scripts/homebrew-update.sh.
  upgradableCasks = [
    "battery"
    "localsend"
  ];
in {
  _module.args.homebrewManifest = {
    inherit managedBrews managedCasks manualCasks upgradableCasks;
  };

  nix-homebrew = {
    enable = true;
    # Apple Silicon (M1/M2/M3) 環境で Intel 版 Brew も使えるようにする
    enableRosetta = true;
    # 現在の macOS ユーザー名
    user = username;
    # 既存の Homebrew インストールを自動で移行する
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    caskArgs.appdir = "/Applications";
    taps = homebrewTaps;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      extraEnv = {
        # Homebrew trust state is stored under XDG_CONFIG_HOME when set.
        # nix-darwin activation runs brew under sudo, so pass it explicitly.
        XDG_CONFIG_HOME = "/Users/${username}/.config";
      };
      # 手動管理のアプリは消さない。更新は scripts/homebrew-update.sh に分離する。
      cleanup = "none";
    };

    brews = managedBrews;

    # Homebrew で install してよい managed アプリだけを載せる。
    casks = managedCasks;

    # https://github.com/mas-cli/mas/issues/1221
    # masでインストールができないのでコメントアウト
    masApps = {
      "RunCat" = 1429033973;
      # "Microsoft Outlook" = 985367838;
    };
  };

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    # Keep Homebrew trust state in both lookup locations.
    install -d -m 0755 /Users/${username}/.homebrew
    install -d -m 0755 /Users/${username}/.config/homebrew
    chown ${username}:staff /Users/${username}/.homebrew /Users/${username}/.config/homebrew

    cat > /Users/${username}/.homebrew/trust.json <<'EOF'
    ${builtins.toJSON {
      trustedtaps = trustedHomebrewTaps;
      trustedcasks = trustedHomebrewCasks;
    }}
    EOF

    cp /Users/${username}/.homebrew/trust.json /Users/${username}/.config/homebrew/trust.json
    chown ${username}:staff /Users/${username}/.homebrew/trust.json /Users/${username}/.config/homebrew/trust.json
    chmod 0600 /Users/${username}/.homebrew/trust.json /Users/${username}/.config/homebrew/trust.json

    azooKeySkkservTapDir="/opt/homebrew/Library/Taps/gitusp/homebrew-azoo-key-skkserv"
    install -d -m 0755 "$azooKeySkkservTapDir/Casks"
    install -m 0644 \
      "${toString ../../../homebrew/Casks/azoo-key-skkserv.rb}" \
      "$azooKeySkkservTapDir/Casks/azoo-key-skkserv.rb"
    chown -R ${username}:staff "$azooKeySkkservTapDir"
  '';
}
