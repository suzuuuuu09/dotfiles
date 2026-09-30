{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  llmAgentsPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  secretsFile = "${config.home.homeDirectory}/dotfiles/.config/nix/secrets/secrets.yaml";
  sopsAgeKeyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  ompMcpConfig = "${config.home.homeDirectory}/.omp/agent/mcp.json";

  ompGoogleApiKey = pkgs.writeShellApplication {
    name = "omp-google-api-key";
    runtimeInputs = [ pkgs.sops ];
    text = ''
      export SOPS_AGE_KEY_FILE=${lib.escapeShellArg sopsAgeKeyFile}
      exec sops decrypt --extract '["composio_api_key"]' ${lib.escapeShellArg secretsFile}
    '';
  };

  ompGoogleSetup = pkgs.writeShellApplication {
    name = "omp-google-setup";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      jq
      sops
    ];
    text = ''
      export OMP_GOOGLE_SECRETS_FILE=${lib.escapeShellArg secretsFile}
      export OMP_GOOGLE_SOPS_AGE_KEY_FILE=${lib.escapeShellArg sopsAgeKeyFile}
      export OMP_GOOGLE_MCP_CONFIG=${lib.escapeShellArg ompMcpConfig}
      export OMP_GOOGLE_API_KEY_COMMAND=${lib.escapeShellArg "${ompGoogleApiKey}/bin/omp-google-api-key"}

      ${builtins.readFile ./omp-google-setup.sh}
    '';
  };
in
{
  home.packages = [
    llmAgentsPackages.omp
    llmAgentsPackages.claude-code
    ompGoogleApiKey
    ompGoogleSetup
  ];

  home.file.".omp/agent/mcp.json" = lib.mkIf (config.sops.secrets ? composio_consumer_api_key) {
    text = builtins.toJSON {
      mcpServers.composio = {
        type = "http";
        url = "https://connect.composio.dev/mcp";
        # Keep disabled until explicit account selection is enforced for every write path.
        enabled = false;
        headers."x-consumer-api-key" =
          "!${pkgs.coreutils}/bin/cat ${lib.escapeShellArg config.sops.secrets.composio_consumer_api_key.path}";
      };
    };
  };
}
