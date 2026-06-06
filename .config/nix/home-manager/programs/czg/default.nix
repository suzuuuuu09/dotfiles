{config, ...}: {
  home.file.".commitlintrc.cjs".source =
    config.lib.file.mkOutOfStoreSymlink
    (builtins.toString ./.commitlintrc.cjs);
}
