# https://github.com/Kyure-A/agent-skills-nix
# Agent Skillsを管理している
# ~/.agents/skills (デフォルトの配置) にスキルを配置するための設定
{
  inputs,
  config,
  ...
}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in {
  imports = [
    inputs.agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;

    # スキルのソースを定義 (複数のソースを指定可能)
    sources = {
      # Vercelのスキル (flake inputsから参照)
      vercel = {
        path = inputs.vercel-skills;
        subdir = "skills";
      };

      # Vercel Agentのスキル (flake inputsから参照)
      v-agent = {
        path = inputs.vercel-agent-skills;
        subdir = "skills";
      };

      # Anthropicsのスキル (flake inputsから参照)
      anthropics = {
        path = inputs.anthropics-skills;
        subdir = "skills";
      };

      # 自作のスキル (ローカルパスから参照)
      personal = {
        path = dotfilesPath;
        subdir = "skills";
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
      ];
    };

    # どこにスキルを配置するか
    targets = {
      agents.enable = true; # ~/.agents/skills にスキルを配置
    };
  };
}
