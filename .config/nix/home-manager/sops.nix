{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;

    secrets = {
      wakatime_api_key = {};
      context7_api_key = {};
    };

    templates.".wakatime.cfg" = {
      path = "${config.home.homeDirectory}/.wakatime.cfg";
      content = ''
        [settings]
        api_key = ${config.sops.placeholder.wakatime_api_key}
      '';
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
