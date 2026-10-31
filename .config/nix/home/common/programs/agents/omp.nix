{
  config,
  inputs,
  pkgs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  llmAgentsPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  typesafeSdk = pkgs.fetchzip {
    url = "https://registry.npmjs.org/@typesafe-ai/sdk/-/sdk-0.6.0.tgz";
    hash = "sha256-m3hDKvBe3BC9dXLxS4VtwXLLXfIhEYQKKaSOxV2daik=";
  };
  jevAutoMode = pkgs.runCommand "omp-jev-auto-mode" { } ''
    mkdir -p "$out"
    cp -R ${inputs.omp-jev-auto-mode}/. "$out/"
    mkdir -p "$out/node_modules/@typesafe-ai"
    ln -s ${typesafeSdk} "$out/node_modules/@typesafe-ai/sdk"
  '';
in
{
  home = {
    packages = with llmAgentsPackages; [
      omp
    ];

    file.".omp/agent/extensions/omp-jev-auto-mode".source = jevAutoMode;
    file.".omp/agent/config.yml".source = mkLink "omp/agent/config.yml";
    file.".omp/agent/jev-auto-mode.json".source = mkLink "omp/agent/jev-auto-mode.json";
  };

  home.file.".omp/plugins/node_modules/omp-ponytail-caveman".source = inputs.omp-ponytail-caveman;

  home.file.".omp/plugins/package.json".text = builtins.toJSON {
    name = "omp-plugins";
    private = true;
    dependencies.omp-ponytail-caveman = "file:${inputs.omp-ponytail-caveman}";
  };
}
