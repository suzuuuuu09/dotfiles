{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    github-copilot-cli
  ];
}
