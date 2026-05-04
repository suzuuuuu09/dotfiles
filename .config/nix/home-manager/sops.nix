{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;

    secrets = {
      wakatime_api_key = {};
    };

    templates.".wakatime.cfg" = {
      path = "${config.home.homeDirectory}/.wakatime.cfg";
      content = ''
        [settings]
        api_key = ${config.sops.placeholder.wakatime_api_key}
      '';
    };
  };
}
