{
  inputs,
  pkgs,
  ...
}:
let
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
  };
}
