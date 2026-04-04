{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
  ];

  system.defaults = {
    # +----------------------------------------------------------+
    # |                           Dock                           |
    # +----------------------------------------------------------+
    dock = {
      # Dock のサイズ
      tilesize = 34;
      # 拡大
      magnification = true;
      largesize = 74;
      # Dock の位置
      orientation = "bottom";
      # Dock を自動的に隠す
      autohide = true;
      # 起動中のアプリにインジケータを表示
      show-process-indicators = true;
      # 最近使ったアプリを表示
      show-recents = true;
      # ウィンドウをアプリアイコンにしまう
      minimize-to-application = false;
      # しまうときのエフェクト ("genie", "scale")
      mineffect = "genie";
      # スタックにマウスオーバーでハイライト
      mouse-over-hilite-stack = true;
      # 静的なアプリのみ表示 (実行中のアプリを非表示)
      static-only = false;
    };
    # ╭──────────────────────────────────────────────────────────╮
    # │                         Trackpad                         │
    # ╰──────────────────────────────────────────────────────────╯
    /*
       trackpad = {
      # タップでクリック
      Clicking = true;
      # 2本指で右クリック
      TrackpadRightClick = false;
      # 3本指でドラッグ
      TrackpadThreeFingerDrag = true;
      # クリックしたときの触覚フィードバック
      ActuateDetents = 1;
    };
    */
  };
  nixpkgs.config.allowUnfree = true;

  nix.enable = true;
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "k25012kk"];

    # 容量節約のための設定
    auto-optimise-store = true;
    keep-outputs = false;
    keep-derivations = false;
  };

  # Spotlight で見えるように /Applications/Nix Apps を macOS alias で作る
  system.activationScripts.applications.text = lib.mkForce ''
    echo "setting up /Applications/Nix Apps..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r src; do
      app_name=$(basename "$src")
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done
  '';

  # Homebrew cask アプリを /Applications にコピーして Spotlight に登録
  system.activationScripts.spotlightApps.text = ''
    LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
    CASKROOM="/opt/homebrew/Caskroom"

    # cmd-eikana: Caskroom から /Applications にコピー
    if [ -d "$CASKROOM/cmd-eikana" ]; then
      SRC=$(find "$CASKROOM/cmd-eikana" -maxdepth 2 -name "*.app" | head -1)
      if [ -n "$SRC" ]; then
        echo "Copying cmd-eikana to /Applications..." >&2
        rm -rf "/Applications/⌘英かな.app" "/Applications/Eikana.app"
        /usr/bin/ditto "$SRC" "/Applications/Eikana.app"
        /usr/bin/xattr -dr com.apple.quarantine "/Applications/Eikana.app" 2>/dev/null || true
        "$LSREG" -f "/Applications/Eikana.app" 2>/dev/null || true
        /usr/bin/mdimport "/Applications/Eikana.app" 2>/dev/null || true
      fi
    fi

    # battery: Caskroom から /Applications にコピー
    if [ -d "$CASKROOM/battery" ]; then
      SRC=$(find "$CASKROOM/battery" -maxdepth 2 -name "*.app" | head -1)
      if [ -n "$SRC" ] && [ ! -d "/Applications/$(basename "$SRC")" ]; then
        echo "Copying battery to /Applications..." >&2
        /usr/bin/ditto "$SRC" "/Applications/$(basename "$SRC")"
        /usr/bin/xattr -dr com.apple.quarantine "/Applications/$(basename "$SRC")" 2>/dev/null || true
        "$LSREG" -f "/Applications/$(basename "$SRC")" 2>/dev/null || true
      fi
    fi
  '';

  # システムのユーザ名を指定
  system.primaryUser = "k25012kk";
  users.users.k25012kk.home = /Users/k25012kk;

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
