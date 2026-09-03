_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };

  xdg.configFile."autostart/1password.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=1Password
    Comment=Password manager and secure wallet
    Exec=1password --silent %U
    Terminal=false
    Icon=1password
    StartupWMClass=1Password
    Categories=Office;Security;
  '';
}
