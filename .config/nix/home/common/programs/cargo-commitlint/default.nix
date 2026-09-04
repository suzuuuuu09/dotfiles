{config, ...}: {
  xdg.configFile."cargo-commitlint/commitlint.toml".source =
    config.lib.file.mkOutOfStoreSymlink (builtins.toString ./commitlint.toml);
}
