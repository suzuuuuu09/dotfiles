{
  description = "suzuuuuu09 Nix configuration";

  nixConfig = {
    # このflakeの評価・ビルド時に使用するキャッシュ
    extra-substituters = [
      "https://suzuuuuu09.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "suzuuuuu09.cachix.org-1:+V6hB76qnQ1Ra3Lf9VZsQtszeZ9UyE39QvRHNtfYPXw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    # +----------------------------------------------------------+
    # | Agent Skills                                             |
    # +----------------------------------------------------------+
    agent-skills.url = "github:Kyure-A/agent-skills-nix";

    local-skills = {
      url = "path:./skills";
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
      url = "github:upstash/context7/574fc642ab4ba6e178b56f436928cb564349cf57";
      flake = false;
    };

    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };

    mizchi-skills = {
      url = "github:mizchi/skills/89c1b34018ba0d85a770c065ba22f83a8d004d34";
      flake = false;
    };

    ui-ux-pro-max-skills = {
      url = "github:nextlevelbuilder/ui-ux-pro-max-skill/b7e3af80f6e331f6fb456667b82b12cade7c9d35";
      flake = false;
    };
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    treefmt-nix,
    ...
  } @ inputs: let
    # TODO: 将来的にはArch Linuxもサポートする予定
    targetSystem = "aarch64-darwin";
    isDarwin = nixpkgs.lib.hasSuffix "darwin" targetSystem;

    pkgs = nixpkgs.legacyPackages.${targetSystem};

    treefmtEval =
      treefmt-nix.lib.evalModule pkgs
      ./.config/nix/home-manager/programs/treefmt.nix;

    localOverlays = [
      (_final: prev: {
        czg = prev.callPackage ./.config/nix/overlays/czg.nix {};
        cxr = prev.callPackage ./.config/nix/overlays/cxr.nix {};
      })
    ];
  in {
    formatter.${targetSystem} = treefmtEval.config.build.wrapper;

    checks.${targetSystem} = {
      formatting = treefmtEval.config.build.check self;

      statix =
        pkgs.runCommand "statix-check" {
          nativeBuildInputs = [pkgs.statix];
        } ''
          statix check ${self}
          touch "$out"
        '';

      deadnix =
        pkgs.runCommand "deadnix-check" {
          nativeBuildInputs = [pkgs.deadnix];
        } ''
          deadnix \
            --hidden \
            --fail \
            --no-lambda-arg \
            --no-lambda-pattern-names \
            ${self}

          touch "$out"
        '';
    };

    darwinConfigurations."suzuMac" = nix-darwin.lib.darwinSystem {
      system = targetSystem;

      specialArgs = {
        inherit self inputs;
      };

      modules =
        (nixpkgs.lib.optionals isDarwin [
          ./.config/nix/darwin
        ])
        ++ [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager

          ({pkgs, ...}: {
            nixpkgs.overlays =
              [
                inputs.llm-agents.overlays.default
              ]
              ++ localOverlays;

            # Mac全体で永続的に使用するNixキャッシュ設定
            nix.settings = {
              extra-substituters = [
                "https://suzuuuuu09.cachix.org"
                "https://nix-community.cachix.org"
              ];

              extra-trusted-public-keys = [
                "suzuuuuu09.cachix.org-1:+V6hB76qnQ1Ra3Lf9VZsQtszeZ9UyE39QvRHNtfYPXw="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              ];

              trusted-users = [
                "root"
                "k25012kk"
              ];
            };

            # cachix pushなどのコマンドを使用可能にする
            environment.systemPackages = with pkgs; [
              cachix
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              extraSpecialArgs = {
                inherit inputs;
              };

              users.k25012kk = import ./.config/nix/home-manager;

              sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
                inputs.nix-index-database.homeModules.nix-index
              ];
            };
          })
        ];
    };
  };
}
