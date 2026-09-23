{
  inputs,
  pkgs,
  ...
}:
let
  llmAgentsPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with llmAgentsPackages; [
    omp
    claude-code
  ];
}
