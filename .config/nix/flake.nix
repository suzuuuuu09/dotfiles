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
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    agent-skills.url = "github:Kyure-A/agent-skills-nix";

    local-skills = {
      url = "path:../../skills";
      flake = false;
    };
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };
    vercel-agent-skills = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
    anthropics-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    agent-browser = {
      url = "github:vercel-labs/agent-browser";
      flake = false;
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    agent-skills,
    ...
  } @ inputs: let
    # TODO: 将来的にはArchlinuxもサポートする予定
    targetSystem = "aarch64-darwin";
    isDarwin = nixpkgs.lib.hasSuffix "darwin" targetSystem;
  in {
    darwinConfigurations."suzuMac" = nix-darwin.lib.darwinSystem {
      system = targetSystem;
      specialArgs = {inherit self inputs;};
      modules =
        (nixpkgs.lib.optionals isDarwin [./darwin])
        ++ [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.k25012kk = import ./home-manager;
          }
        ];
    };
  };
}
