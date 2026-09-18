{ ... }: {
  imports = [
    ./czg
    ./cargo-commitlint
    ./npm
    ./neovim
    ./codex.nix
    ./nh.nix
    ./pi.nix
    ./direnv.nix
    ./gh.nix
    # ./github-copilot.nix # 多分もう使わない
  ];
}
