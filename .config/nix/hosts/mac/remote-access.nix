{username, ...}: {
  services.openssh = {
    enable = true;
  };

  users.users.${username}.openssh.authorizedKeys.keyFiles = [
    ./ssh/android-to-suzu-mac.pub
  ];
}
