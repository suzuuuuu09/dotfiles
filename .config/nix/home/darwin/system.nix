{
  self,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
  ];

  # Homebrew API からのインストールを無効化
  # environment.variables.HOMEBREW_NO_INSTALL_FROM_API = "1";
  # Homebrew の環境変数を設定して、API からのインストールを無効化
  # environment.etc."homebrew/brew.env".text = ''
  #   HOMEBREW_NO_INSTALL_FROM_API=1
  # '';

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true; # tmux内で必要
  };

  system = {
    defaults = {
      # +----------------------------------------------------------+
      # |                          finder                          |
      # +----------------------------------------------------------+
      finder = {
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Home";
        ShowExternalHardDrivesOnDesktop = true;
      };

      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 30;
        KeyRepeat = 2;
        "com.apple.swipescrolldirection" = true;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.trackpad.scaling" = 1.5;
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 1.0;
      };

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
        # アプリケーションをグループ化して表示
        # AeroSpaceの小さく表示されるバグ対策
        expose-group-apps = true;
        # ドックに表示するアプリ
        persistent-apps = [
          {app = "/Applications/Vivaldi.app";}
          {app = "/Applications/WezTerm.app";}
          {app = "/Applications/Microsoft Teams.app";}
          {app = "/Applications/Slack.app";}
          {app = "/Applications/zoom.us.app";}
          {app = "/Applications/Obsidian.app";}
          {app = "/System/Applications/Utilities/Audio MIDI Setup.app";}
          {app = "/Applications/Codex.app";}
          {app = "/Applications/Parsec.app";}
          {app = "/Applications/Discord.app";}
        ];
        wvous-bl-corner = 2;
        wvous-br-corner = 11;
      };
      # ╭──────────────────────────────────────────────────────────╮
      # │                         Trackpad                         │
      # ╰──────────────────────────────────────────────────────────╯
      trackpad = {
        # タップでクリック
        Clicking = true;
        # 2本指で右クリック
        TrackpadRightClick = true;
        # 3本指でドラッグ
        TrackpadThreeFingerDrag = true;
        # クリックしたときの触覚フィードバック
        ActuateDetents = true;
      };

      screencapture = {
        target = "file";
      };

      CustomUserPreferences = {
        "com.apple.controlcenter" = {
          "NSStatusItem Visible AudioVideoModule" = 0;
          "NSStatusItem Visible Battery" = 1;
          "NSStatusItem Visible BentoBox" = 1;
          "NSStatusItem Visible Clock" = 1;
          "NSStatusItem Visible FocusModes" = 1;
          "NSStatusItem Visible KeyboardBrightness" = 0;
          "NSStatusItem Visible NowPlaying" = 0;
          "NSStatusItem Visible ScreenMirroring" = 0;
          "NSStatusItem Visible Shortcuts" = 0;
          "NSStatusItem Visible Timer" = 0;
          "NSStatusItem Visible WiFi" = 1;
        };

        NSGlobalDomain = {
          AppleMenuBarVisibleInFullscreen = true;
        };

        "com.apple.finder" = {
          ShowHardDrivesOnDesktop = 0;
          ShowPathbar = 1;
          ShowRemovableMediaOnDesktop = 1;
        };

        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
          DragLock = 0;
          Dragging = 0;
          TrackpadCornerSecondaryClick = 0;
          TrackpadFiveFingerPinchGesture = 2;
          TrackpadFourFingerHorizSwipeGesture = 2;
          TrackpadFourFingerPinchGesture = 2;
          TrackpadFourFingerVertSwipeGesture = 2;
          TrackpadHandResting = 1;
          TrackpadHorizScroll = 1;
          TrackpadMomentumScroll = 1;
          TrackpadPinch = 1;
          TrackpadRightClick = 1;
          TrackpadRotate = 1;
          TrackpadScroll = 1;
          TrackpadThreeFingerDrag = 0;
          TrackpadThreeFingerHorizSwipeGesture = 2;
          TrackpadThreeFingerTapGesture = 0;
          TrackpadThreeFingerVertSwipeGesture = 2;
          TrackpadTwoFingerDoubleTapGesture = 1;
          TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
          USBMouseStopsTrackpad = 0;
        };

        "com.apple.screencapture" = {
          location = "~/Pictures/Screenshots";
          style = "selection";
        };

        "io.github.gitusp.azoo-key-skkserv" = {
          host = "127.0.0.1";
          incomingCharset = "EUC-JP";
          startServerAtLaunch = true;
        };
      };
    };

    primaryUser = username;

    # Spotlight で見えるように /Applications/Nix Apps を macOS alias で作る
    activationScripts.applications.text = lib.mkForce ''
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
    activationScripts.spotlightApps.text = ''
      LSREG="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
      CASKROOM="/opt/homebrew/Caskroom"

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

    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };

  launchd.user.agents = {
    macSKKAutostart = {
      script = ''
        /usr/bin/open -gj -a "/Library/Input Methods/macSKK.app"
      '';
      serviceConfig = {
        Label = "net.mtgto.inputmethod.macSKK.autostart";
        RunAtLoad = true;
        KeepAlive = false;
      };
    };

    azooKeySkkservAutostart = {
      script = ''
        /usr/bin/open -gj -a "/Applications/azooKey skkserv.app"
      '';
      serviceConfig = {
        Label = "io.github.gitusp.azoo-key-skkserv.autostart";
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    enable = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" username];

      # 容量節約のための設定
      auto-optimise-store = true;
      keep-outputs = false;
      keep-derivations = false;
    };
  };

  users.users.${username}.home = "/Users/${username}";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
