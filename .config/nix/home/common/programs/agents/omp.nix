{
  config,
  inputs,
  lib,
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

  home.file.".omp/agent/mcp.json" = lib.mkIf (config.sops.secrets ? composio_api_key) {
    text = builtins.toJSON {
      mcpServers.composio = {
        type = "http";
        url = "https://connect.composio.dev/mcp";
        # Keep disabled until explicit account selection is enforced for every write path.
        enabled = false;
        headers."x-consumer-api-key" =
          "!${pkgs.coreutils}/bin/cat ${lib.escapeShellArg config.sops.secrets.composio_api_key.path}";
      };
    };
  };
}
