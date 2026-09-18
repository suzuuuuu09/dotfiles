{
  inputs,
  pkgs,
  config,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  home.packages =
    (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      codex
    ])
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
            installation = "AVAILABLE";
            authentication = "ON_INSTALL";
          };

          category = "Productivity";
        }
      ];
    };
  };
}
