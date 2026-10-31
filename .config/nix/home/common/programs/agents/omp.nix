{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  llmAgentsPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  pluginSources = import ../../../../../../omp/plugins/npins;
  typesafeSdk = pkgs.fetchzip {
    url = "https://registry.npmjs.org/@typesafe-ai/sdk/-/sdk-0.6.0.tgz";
    hash = "sha256-m3hDKvBe3BC9dXLxS4VtwXLLXfIhEYQKKaSOxV2daik=";
  };
  jevAutoMode = pkgs.runCommand "omp-jev-auto-mode" { } ''
    mkdir -p "$out"
    cp -R ${pluginSources.omp-jev-auto-mode}/. "$out/"
    mkdir -p "$out/node_modules/@typesafe-ai"
    ln -s ${typesafeSdk} "$out/node_modules/@typesafe-ai/sdk"
  '';
in
{
  home = {
    packages = with llmAgentsPackages; [
      omp
    ];

    file = {
      ".omp/agent/extensions/omp-jev-auto-mode".source = jevAutoMode;
      ".omp/agent/config.yml".source = mkLink "omp/agent/config.yml";
      ".omp/agent/jev-auto-mode.json".source = mkLink "omp/agent/jev-auto-mode.json";
    };
  };

  # OMP also discovers extension directories with a .backup suffix.
  home.activation.archiveJevAutoModeBackup = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    backup="$HOME/.omp/agent/extensions/omp-jev-auto-mode.backup"
    archive=${lib.escapeShellArg "${config.xdg.stateHome}/omp/extension-backups"}

    if [[ -e "$backup" || -L "$backup" ]]; then
      run mkdir -p "$archive"
      run ${pkgs.coreutils}/bin/mv --backup=numbered -T -- \
        "$backup" "$archive/omp-jev-auto-mode"
    fi
  '';

  home.file.".omp/plugins/node_modules/omp-ponytail-caveman".source =
    pluginSources.omp-ponytail-caveman.outPath;

  home.file.".omp/plugins/package.json".text = builtins.toJSON {
    name = "omp-plugins";
    private = true;
    dependencies.omp-ponytail-caveman = "file:${pluginSources.omp-ponytail-caveman}";
  };
}
