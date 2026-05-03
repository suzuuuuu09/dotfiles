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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    # +----------------------------------------------------------+
    # | Agent Skills                                             |
    # +----------------------------------------------------------+
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
    context7-skills = {
      url = "github:upstash/context7";
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
    localOverlays = [
      (final: prev: {
        czg = prev.callPackage ./overlays/czg.nix {};
      })
    ];
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
            nixpkgs.overlays = [
              inputs.llm-agents.overlays.default
            ] ++ localOverlays;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              users.k25012kk = import ./home-manager;
              sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.nix-index-database.hmModules.nix-index
              ];
            };
          }
        ];
    };
  };
}
