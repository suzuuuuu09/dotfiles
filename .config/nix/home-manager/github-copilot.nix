{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    github-copilot-cli
  ];

  # MCPの設定
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;

    secrets = {
      context7_api_key = {};
    };

    templates."mcp-config.json" = {
      path = "${config.home.homeDirectory}/.copilot/mcp-config.json";

      content =
        builtins.replaceStrings
        ["\${CONTEXT7_API_KEY}"]
        [config.sops.placeholder.context7_api_key]
        (builtins.readFile ../../../copilot/mcp-config.json);
    };
  };
}
