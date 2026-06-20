# https://github.com/Kyure-A/agent-skills-nix
# Agent Skillsを管理している
# ~/.agents/skills (デフォルトの配置) にスキルを配置するための設定
{
  lib,
  inputs,
  enableAgentSkills ? false,
  ...
}: {
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = lib.mkIf enableAgentSkills {
    enable = true;

    # スキルのソースを定義 (複数のソースを指定可能)
    sources = {
      # +----------------------------------------------------------+
      # | flake inputsから参照                                     |
      # +----------------------------------------------------------+
      # Vercelのスキル
      vercel = {
        path = inputs.vercel-skills;
        subdir = "skills";
      };

      # Vercel Agentのスキル
      v-agent = {
        path = inputs.vercel-agent-skills;
        subdir = "skills";
      };

      # Anthropicsのスキル
      anthropics = {
        path = inputs.anthropics-skills;
        subdir = "skills";
      };

      agent-browser = {
        path = inputs.agent-browser;
        subdir = "skills";
      };

      context7 = {
        path = inputs.context7-skills;
        subdir = "skills";
      };

      mattpocock = {
        path = inputs.mattpocock-skills;
        subdir = "skills";
      };

      mizchi = {
        path = inputs.mizchi-skills;
      };

      ui-ux-pro-max = {
        path = inputs.ui-ux-pro-max-skills;
        # NOTE: シムリンクのscriptsを使うため、リポジトリ全体を source root にする
        subdir = ".";
      };
      # +----------------------------------------------------------+
      # | ローカルパスから参照                                     |
      # +----------------------------------------------------------+
      # 自作のスキル
      personal = {
        # path = "${inputs.self}/skills";
        path = inputs.local-skills;
        filter.maxDepth = 1;
      };
    };

    # 使うスキルを指定 (sourcesのキーを参照)
    skills = {
      enableAll = ["personal"];

      # 外部からのスキルを使う
      explicit = {
        frontend-design = {
          from = "anthropics";
          path = "frontend-design";
        };
        skill-creator = {
          from = "anthropics";
          path = "skill-creator";
        };
        find-skills = {
          from = "vercel";
          path = "find-skills";
        };
        web-design-guidelines = {
          from = "v-agent";
          path = "web-design-guidelines";
        };
        empirical-prompt-tuning = {
          from = "mizchi";
          path = "meta/empirical-prompt-tuning";
        };
        context7-cli = {
          from = "context7";
          path = "context7-cli";
        };

        ui-ux-pro-max = {
          from = "ui-ux-pro-max";
          path = ".claude/skills/ui-ux-pro-max";
        };
        grill-me = {
          from = "mattpocock";
          path = "productivity/grill-me";

          transform = {original, ...}: ''
            ${original}

            ## Notes

            - When asking questions, provide options to make them easier to answer.
            - Do not start implementation immediately after completing the design. After completing the design, you must request confirmation and proceed with implementation only after receiving explicit instructions from the user.
          '';
        };
        agent-browser = {
          from = "agent-browser";
          path = "agent-browser";

          transform = {
            original,
            dependencies,
          }: ''
            ${
              builtins.replaceStrings
              [
                "allowed-tools: Bash(agent-browser:*), Bash(npx agent-browser:*)"
                "Install: `npm i -g agent-browser && agent-browser install`"
                "agent-browser skills get core"
                "agent-browser skills get core --full"
                "agent-browser skills get electron"
                "agent-browser skills get slack"
                "agent-browser skills get dogfood"
                "agent-browser skills get vercel-sandbox"
                "agent-browser skills get agentcore"
                "agent-browser skills list"
                "agent-browser install"
              ]
              [
                "allowed-tools: Bash(npx agent-browser@latest:*)"
                "Install: do not install the CLI globally. Use `npx agent-browser@latest`. Run `npx agent-browser@latest install` when the browser needs to be installed."
                "npx agent-browser@latest skills get core"
                "npx agent-browser@latest skills get core --full"
                "npx agent-browser@latest skills get electron"
                "npx agent-browser@latest skills get slack"
                "npx agent-browser@latest skills get dogfood"
                "npx agent-browser@latest skills get vercel-sandbox"
                "npx agent-browser@latest skills get agentcore"
                "npx agent-browser@latest skills list"
                "npx agent-browser@latest install"
              ]
              original
            }

            ## Local policy

            Do not install the agent-browser CLI globally:

            ```bash
            npm install -g agent-browser
            ```

            Always run the CLI with:

            ```bash
            npx agent-browser@latest <command>
            ```

            Browser setup is still allowed and may be needed on first use:

            ```bash
            npx agent-browser@latest install
            ```

            Before browser automation, load the workflow:

            ```bash
            npx agent-browser@latest skills get core
            ```

            If full command details are needed:

            ```bash
            npx agent-browser@latest skills get core --full
            ```

            If doctor reports a daemon version mismatch, close the stale daemon:

            ```bash
            npx agent-browser@latest --session default close
            ```
          '';
        };
        find-docs = {
          from = "context7";
          path = "find-docs";
          transform = {
            original,
            dependencies,
          }: ''
            ${
              builtins.replaceStrings
              [
                ''
                  Retrieve current documentation and code examples for any library using the Context7 CLI.

                  Make sure the CLI is up to date before running commands:

                  ```bash
                  npm install -g ctx7@latest
                  ```

                  Or run directly without installing:

                  ```bash
                  npx ctx7@latest <command>
                  ```
                ''
                "ctx7 library <name> <query>"
                "ctx7 docs <libraryId> <query>"
                "ctx7 library react"
                "ctx7 library nextjs"
                "ctx7 library prisma"
                "ctx7 docs /vercel/next.js"
                "ctx7 docs /facebook/react"
                "ctx7 docs /prisma/prisma"
                "ctx7 login"
              ]
              [
                ''
                  Retrieve current documentation and code examples for any library using the Context7 CLI.

                  Do not install Context7 globally.
                  Always run Context7 directly with npx:

                  ```bash
                  npx ctx7@latest <command>
                  ```
                ''
                "npx ctx7@latest library <name> <query>"
                "npx ctx7@latest docs <libraryId> <query>"
                "npx ctx7@latest library react"
                "npx ctx7@latest library nextjs"
                "npx ctx7@latest library prisma"
                "npx ctx7@latest docs /vercel/next.js"
                "npx ctx7@latest docs /facebook/react"
                "npx ctx7@latest docs /prisma/prisma"
                "npx ctx7@latest login"
              ]
              original
            }

            ## Local policy

            Do not run:

            ```bash
            npm install -g ctx7@latest
            ```

            Always use:

            ```bash
            npx ctx7@latest
            ```
          '';
        };
      };
    };

    # どこにスキルを配置するか
    targets = {
      agents.enable = true; # ~/.agents/skills にスキルを配置
    };
  };
}
