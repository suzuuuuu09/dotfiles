{config, ...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      "${config.home.homeDirectory}/.colima/ssh_config"
    ];

    settings = {
      "android-termux" = {
        "HostName" = "100.68.11.107";
        "User" = "u0_a432";
        "Port" = "8022";
        "IdentityFile" = "~/.ssh/android-termux.pub";
        "IdentitiesOnly" = "yes";
        "ServerAliveInterval" = "30";
        "ServerAliveCountMax" = "3";
      };

      "*" = {
        "IdentityAgent" = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };
}
