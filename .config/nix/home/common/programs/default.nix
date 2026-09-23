{ ... }: {
  imports = [
    ./agents
    ./czg
    ./cargo-commitlint
    ./npm
    ./neovim
    ./nh.nix
    ./direnv.nix
    ./git.nix
    ./gh.nix
  ];
}
