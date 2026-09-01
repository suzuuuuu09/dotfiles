{ ... }: {
  imports = [
    ./czg
    ./npm
    ./codex.nix
    ./nh.nix
    ./pi.nix
    ./direnv.nix
    # ./github-copilot.nix # 多分もう使わない
  ];
}
