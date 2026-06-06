# https://github.com/Kyure-A/agent-skills-nix
# Agent Skillsを管理している
# ~/.agents/skills (デフォルトの配置) にスキルを配置するための設定
{inputs, ...}: {
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
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
        find-docs = {
          from = "context7";
          path = "find-docs";
        };
        context7-cli = {
          from = "context7";
          path = "context7-cli";
        };
        grill-me = {
          from = "mattpocock";
          path = "productivity/grill-me";
        };
        ui-ux-pro-max = {
          from = "ui-ux-pro-max";
          path = ".claude/skills/ui-ux-pro-max";
        };
        agent-browser = {
          from = "agent-browser";
          path = "agent-browser";
        };
      };
    };

    # どこにスキルを配置するか
    targets = {
      agents.enable = true; # ~/.agents/skills にスキルを配置
    };
  };
}
