{ lib }:
let
  evaluate =
    secrets:
    (lib.evalModules {
      specialArgs = {
        pkgs = {
          stdenv.hostPlatform.system = "aarch64-darwin";
          coreutils = "/runtime/coreutils";
        };
        inputs.llm-agents.packages.aarch64-darwin.omp = "omp";
      };
      modules = [
        ../home/common/programs/agents/omp.nix
        {
          options = {
            home.packages = lib.mkOption { type = lib.types.listOf lib.types.str; };
            home.file = lib.mkOption {
              default = { };
              type = lib.types.attrsOf (
                lib.types.submodule {
                  options.text = lib.mkOption { type = lib.types.str; };
                }
              );
            };
            sops.secrets = lib.mkOption { type = lib.types.attrs; };
          };
          config.sops.secrets = secrets;
        }
      ];
    }).config;
  withoutKey = evaluate { };
  withKey = evaluate { composio_api_key.path = "/run/secrets/composio key"; };
  server = (builtins.fromJSON withKey.home.file.".omp/agent/mcp.json".text).mcpServers.composio;
in
assert !(withoutKey.home.file ? ".omp/agent/mcp.json");
assert server.enabled == false;
assert server.type == "http";
assert server.url == "https://connect.composio.dev/mcp";
assert
  server.headers."x-consumer-api-key" == "!/runtime/coreutils/bin/cat '/run/secrets/composio key'";
"ok"
