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
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  home.packages =
    [
      codexPackage
    ]
    ++ [
      pkgs.nodejs
    ];

  home.file = {
    ".codex/AGENTS.md".source = mkLink "codex/AGENTS.md";
    ".codex/guide".source = mkLink "codex/guide";

    # Codex personal plugin
    "plugins/ponytail".source = inputs.ponytail;

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

  home.activation.installPonytail = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${codexPackage}/bin/codex plugin list --marketplace personal --json \
      | ${pkgs.jq}/bin/jq -e 'any(.installed[]; .pluginId == "ponytail@personal")' > /dev/null; then
      ${codexPackage}/bin/codex plugin add ponytail@personal
    fi
  '';
}
