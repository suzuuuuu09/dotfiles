{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      # Use the native Wayland frontend in Plasma's Wayland session.
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];

      settings = {
        globalOptions = {
          "Hotkey/ActivateKeys" = {
            "0" = "Henkan";
          };

          "Hotkey/DeactivateKeys" = {
            "0" = "Muhenkan";
          };
        };

        inputMethod = {
          GroupOrder."0" = "Default";

          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "jp";
            DefaultIM = "mozc";
          };

          "Groups/0/Items/0".Name = "keyboard-jp";
          "Groups/0/Items/1".Name = "mozc";
        };
      };
    };
  };
}
