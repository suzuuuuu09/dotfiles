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
      enable = [
        "skill-creator"
        "find-skills"
        "frontend-design"
        "web-design-guidelines"
        "agent-browser"
        "find-docs"
        # "context7-mcp"
        "context7-cli"
      ];
    };

    # どこにスキルを配置するか
    targets = {
      agents.enable = true; # ~/.agents/skills にスキルを配置
    };
  };
}
