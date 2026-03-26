{
  description = "suzuuuuu09 Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    ...
  }: let
    targetSystem = "aarch64-darwin";
    isDarwin = nixpkgs.lib.hasSuffix "darwin" targetSystem;
  in {
    darwinConfigurations."suzuMac" = nix-darwin.lib.darwinSystem {
      system = targetSystem;
      specialArgs = {inherit self;};
      modules =
        (nixpkgs.lib.optionals isDarwin [./darwin])
        ++ [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.k25012kk = import ./home-manager;
          }
        ];
    };
  };
}
