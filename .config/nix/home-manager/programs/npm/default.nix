{lib, ...}: {
  home.activation.createNpmUserConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e "$HOME/.npmrc" ]; then
      install -m 600 ${./.npmrc} "$HOME/.npmrc"
    fi
  '';
}
