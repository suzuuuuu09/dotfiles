{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  codexPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex;
  ponytailSource = toString inputs.ponytail;
  # Codex 0.159/0.160 skip hooks for root AgentPlugin manifests.
  ponytailPlugin = builtins.path {
    path = ponytailSource;
    name = "ponytail-codex";
    filter = path: _type: path != "${ponytailSource}/plugin.json";
  };
  ponytailRuntime =
    pkgs.runCommand "ponytail-codex-runtime"
      {
        nativeBuildInputs = [ pkgs.jq ];
      }
      ''
        cp -R ${ponytailPlugin}/. "$out"
        chmod u+w "$out/hooks" "$out/hooks/claude-codex-hooks.json"
        # Hook launch environments need not include Home Manager's Node.js in PATH.
        jq --arg node "${pkgs.nodejs}/bin/node" \
          '(.hooks[][].hooks[].command) |= sub("^node "; $node + " ")' \
          "$out/hooks/claude-codex-hooks.json" > "$TMPDIR/hooks.json"
        cp "$TMPDIR/hooks.json" "$out/hooks/claude-codex-hooks.json"

        # Exercise all three hooks without Node.js in PATH, using isolated state.
        export CLAUDE_PLUGIN_ROOT="$out" PLUGIN_DATA="$TMPDIR/plugin-data"
        export CLAUDE_CONFIG_DIR="$TMPDIR/claude" PONYTAIL_DEFAULT_MODE=full
        for event in SessionStart UserPromptSubmit SubagentStart; do
          command=$(jq -r --arg event "$event" '.hooks[$event][0].hooks[0].command' "$TMPDIR/hooks.json")
          printf '%s' '{"prompt":"$ponytail full"}' | \
            PATH=${
              lib.makeBinPath [
                pkgs.coreutils
                pkgs.bash
                pkgs.jq
              ]
            } \
            ${pkgs.bash}/bin/bash -c "$command" > "$TMPDIR/output.json"
          jq -e --arg event "$event" \
            '.hookSpecificOutput.hookEventName == $event and (.hookSpecificOutput.additionalContext | contains("PONYTAIL"))' \
            "$TMPDIR/output.json" > /dev/null
        done
        test "$(cat "$PLUGIN_DATA/.ponytail-active")" = full
      '';
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  home = {
    packages = [
      codexPackage
      pkgs.nodejs
    ];

    file = {
      ".codex/AGENTS.md".source = mkLink "codex/AGENTS.md";
      ".codex/guide".source = mkLink "codex/guide";

      # Codex personal plugin
      "plugins/ponytail".source = ponytailRuntime;

      # Personal marketplace
      ".agents/plugins/marketplace.json".text = builtins.toJSON {
        name = "personal";

        interface = {
          displayName = "Personal";
        };

        plugins = [
          {
            name = "ponytail";

            source = {
              source = "local";
              path = "./plugins/ponytail";
            };

            policy = {
              installation = "INSTALLED_BY_DEFAULT";
              authentication = "ON_INSTALL";
            };

            category = "Productivity";
          }
        ];
      };
    };

    activation.installPonytail = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      # Refresh the cached source even when the manifest version is unchanged.
      ${codexPackage}/bin/codex plugin add ponytail@personal
    '';
  };
}
