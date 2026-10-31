{
  description = "suzuuuuu09 Nix configuration";

  nixConfig = {
    # このflakeの評価・ビルド時に使用するキャッシュ
    extra-substituters = [
      "https://suzuuuuu09.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com" # llm-agents.nix
      "https://herdr.cachix.org" # Herdr
    ];

    extra-trusted-public-keys = [
      "suzuuuuu09.cachix.org-1:+V6hB76qnQ1Ra3Lf9VZsQtszeZ9UyE39QvRHNtfYPXw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # llm-agents.nix
      "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I=" # Herdr
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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    hunk = {
      url = "github:modem-dev/hunk";
      # hunk's flake-parts still evaluates x86_64-darwin, which 26.11 dropped.
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    };

    herdr = {
      url = "github:herdrdev/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # +----------------------------------------------------------+
    # | Agent Skills                                             |
    # +----------------------------------------------------------+
    agent-skills.url = "github:Kyure-A/agent-skills-nix";

  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nixos-wsl,
      nix-homebrew,
      treefmt-nix,
      git-hooks,
      ...
    }@inputs:
    let
      # TODO: 将来的にはArch Linuxもサポートする予定
      targetSystem = "aarch64-darwin";
      wslSystem = "x86_64-linux";
      osSystem = "x86_64-linux";
      isDarwin = nixpkgs.lib.hasSuffix "darwin" targetSystem;
      macUsername = "k25012kk";
      wslUsername = "nixos";
      osUsername = "suzu";
      wslHostName = "suzuWsl";

      systems = [
        targetSystem
        wslSystem
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      perSystem = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./.config/nix/home/common/programs/treefmt.nix;
          preCommitCheck = import ./.config/nix/home/common/programs/git-hooks.nix {
            inherit git-hooks pkgs treefmtEval;
            src = self;
          };
        in
        {
          inherit pkgs treefmtEval preCommitCheck;
        }
      );

      wslPkgs = perSystem.${wslSystem}.pkgs;

      # ponytail: dependency compatibility shim; remove when Hunk, Herdr, and nix-darwin use hostPlatform.
      stdenvCompatibilityOverlay = _final: prev: {
        stdenv = prev.stdenv // {
          isLinux = prev.stdenv.hostPlatform.isLinux;
          isDarwin = prev.stdenv.hostPlatform.isDarwin;
        };
      };

      localOverlays = [
        stdenvCompatibilityOverlay
        (_final: prev: {
          cargo-commitlint =
            if builtins.hasAttr "cargo-commitlint" prev then
              prev."cargo-commitlint"
            else
              prev.callPackage ./.config/nix/overlays/cargo-commitlint.nix { };
          herdr =
            let
              herdrPkgs = import nixpkgs {
                system = _final.stdenv.hostPlatform.system;
                overlays = [
                  stdenvCompatibilityOverlay
                  inputs.herdr.inputs.rust-overlay.overlays.default
                ];
              };
              rustToolchain = herdrPkgs.rust-bin.fromRustupToolchainFile "${inputs.herdr}/rust-toolchain.toml";
            in
            herdrPkgs.callPackage "${inputs.herdr}/nix/package.nix" {
              rustPlatform = herdrPkgs.makeRustPlatform {
                cargo = rustToolchain;
                rustc = rustToolchain;
              };
            };
          czg = prev.callPackage ./.config/nix/overlays/czg.nix { };
          cxr = prev.callPackage ./.config/nix/overlays/cxr.nix { };
          hunk = _final.callPackage "${inputs.hunk}/nix/package.nix" {
            bun2nix = inputs.hunk.inputs.bun2nix.packages.${_final.stdenv.hostPlatform.system}.default;
          };
        })
      ];

      wslHomeImports = [
        ./.config/nix/home/common
        ./.config/nix/home/wsl
      ];

      osHomeImports = [
        ./.config/nix/home/common
        ./.config/nix/home/os
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      homeSharedModules = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.nix-index-database.homeModules.nix-index
      ];

      wslHomeConfiguration = home-manager.lib.homeManagerConfiguration {
        pkgs = wslPkgs;

        extraSpecialArgs = {
          inherit inputs;
          username = wslUsername;
          enableAgentSkills = true;
          enableSops = true;
        };

        modules = [
          {
            nixpkgs.overlays = localOverlays;
          }
        ]
        ++ wslHomeImports
        ++ homeSharedModules;
      };
    in
    {
      apps = forAllSystems (
        system:
        let
          sourceLockProgram = inputs.agent-skills.lib.agent-skills.mkSourceLockProgram {
            inherit (perSystem.${system}) pkgs;
            manifestsDir = "skills/registry/sources";
            lockFile = "skills/registry/sources.lock.json";
          };
        in
        {
          skills-sources-lock = {
            type = "app";
            meta.description = "Update locked Agent Skill Sources";
            program = "${sourceLockProgram}/bin/skills-sources-lock";
          };
        }
      );

      formatter = forAllSystems (system: perSystem.${system}.treefmtEval.config.build.wrapper);

      checks.${targetSystem} =
        let
          inherit (perSystem.${targetSystem}) pkgs treefmtEval preCommitCheck;
        in
        {
          pre-commit = preCommitCheck;
          formatting = treefmtEval.config.build.check self;

          statix =
            pkgs.runCommand "statix-check"
              {
                nativeBuildInputs = [ pkgs.statix ];
              }
              ''
                # Keep the generated npins importer unchanged.
                statix check --ignore '**/omp/plugins/npins/default.nix' ${self}
                touch "$out"
              '';

          deadnix =
            pkgs.runCommand "deadnix-check"
              {
                nativeBuildInputs = [ pkgs.deadnix ];
              }
              ''
                deadnix \
                  --hidden \
                  --fail \
                  --no-lambda-arg \
                  --no-lambda-pattern-names \
                  ${self}

                touch "$out"
              '';

          shellcheck =
            pkgs.runCommand "shellcheck"
              {
                nativeBuildInputs = [ pkgs.shellcheck ];
              }
              ''
                shellcheck \
                  ${self}/scripts/*.sh \
                  ${self}/.config/aerospace/scripts/*.sh

                touch "$out"
              '';

          fish-syntax =
            pkgs.runCommand "fish-syntax-check"
              {
                nativeBuildInputs = [ pkgs.fish ];
              }
              ''
                fish -n \
                  ${self}/.config/fish/config.fish \
                  ${self}/.config/fish/tool_setup.fish \
                  ${self}/.config/fish/config/*.fish \
                  ${self}/.config/fish/conf.d/*.fish \
                  ${self}/.config/fish/functions/*.fish

                touch "$out"
              '';

          ruff =
            pkgs.runCommand "ruff-check"
              {
                nativeBuildInputs = [ pkgs.ruff ];
              }
              ''
                ruff check \
                  ${self}/skills/fetch-markdown/scripts \
                  ${self}/skills/timezone-utils/scripts

                touch "$out"
              '';

          actionlint =
            pkgs.runCommand "actionlint-check"
              {
                nativeBuildInputs = [ pkgs.actionlint ];
              }
              ''
                actionlint ${self}/.github/workflows/*.yaml
                touch "$out"
              '';
        };

      devShells = forAllSystems (
        system:
        let
          inherit (perSystem.${system}) pkgs preCommitCheck;
        in
        {
          default = pkgs.mkShell {
            shellHook = ''
              (
                # pre-commit rejects even a global hooksPath during installation.
                export GIT_CONFIG_PARAMETERS="''${GIT_CONFIG_PARAMETERS:+$GIT_CONFIG_PARAMETERS }'core.hooksPath='"
                ${preCommitCheck.shellHook}

                if [ ! -x "$(git rev-parse --git-path hooks/pre-commit)" ]; then
                  ${pkgs.pre-commit}/bin/pre-commit install -c .pre-commit-config.yaml || exit
                  git config --local core.hooksPath "$(git rev-parse --git-common-dir)/hooks"
                fi
              )
            '';
            packages = preCommitCheck.enabledPackages;
          };
        }
      );

      darwinConfigurations."suzuMac" = nix-darwin.lib.darwinSystem {
        system = targetSystem;

        specialArgs = {
          inherit self inputs;
          username = macUsername;
        };

        modules =
          (nixpkgs.lib.optionals isDarwin [
            ./.config/nix/hosts/mac
          ])
          ++ [
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager

            (
              {
                pkgs,
                username,
                ...
              }:
              {
                nixpkgs.overlays = localOverlays;

                # Mac全体で永続的に使用するNixキャッシュ設定
                nix.settings = {
                  extra-substituters = [
                    "https://suzuuuuu09.cachix.org"
                    "https://nix-community.cachix.org"
                    "https://cache.numtide.com"
                  ];

                  extra-trusted-public-keys = [
                    "suzuuuuu09.cachix.org-1:+V6hB76qnQ1Ra3Lf9VZsQtszeZ9UyE39QvRHNtfYPXw="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
                  ];

                  trusted-users = [
                    "root"
                    username
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
                    inherit inputs username;
                    enableAgentSkills = true;
                    enableSops = true;
                  };

                  users.${username} = {
                    imports = [
                      ./.config/nix/home/common
                      ./.config/nix/home/darwin/home.nix
                    ];
                  };

                  sharedModules = homeSharedModules;
                };
              }
            )
          ];
      };

      homeConfigurations = {
        "${wslUsername}" = wslHomeConfiguration;
        "${wslUsername}@${wslHostName}" = wslHomeConfiguration;
      };

      nixosConfigurations.suzuWsl = nixpkgs.lib.nixosSystem {
        system = wslSystem;

        specialArgs = {
          inherit inputs;
          username = wslUsername;
        };

        modules = [
          nixos-wsl.nixosModules.default
          ./.config/nix/hosts/wsl
          home-manager.nixosModules.home-manager

          (
            {
              pkgs,
              username,
              ...
            }:
            {
              nixpkgs.overlays = localOverlays;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs username;
                  enableAgentSkills = true;
                  enableSops = true;
                };

                users.${username} = {
                  imports = wslHomeImports;
                };

                sharedModules = homeSharedModules;
              };
            }
          )
        ];
      };

      nixosConfigurations.suzu = nixpkgs.lib.nixosSystem {
        system = osSystem;

        specialArgs = {
          inherit self inputs;
          username = osUsername;
        };

        modules = [
          ./.config/nix/hosts/os
          ./.config/nix/hosts/os/onepassword.nix
          home-manager.nixosModules.home-manager

          ({ username, ... }: {
            nixpkgs.overlays = localOverlays;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              extraSpecialArgs = {
                inherit inputs username;
                enableAgentSkills = true;
                enableSops = true;
              };

              users.${username} = {
                imports = osHomeImports;
              };

              sharedModules = homeSharedModules;
            };
          })
        ];
      };
    };
}
