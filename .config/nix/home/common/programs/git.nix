{ config, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = "suzuuuuu09";
        email = "140299273+suzuuuuu09@users.noreply.github.com";
      };

      difftool.sourcetree.cmd = "'' ";

      mergetool.sourcetree = {
        cmd = "'' ";
        trustExitCode = true;
      };

      core = {
        autocrlf = false;
        pager = "delta";
        editor = "nvim";
        hooksPath = "${config.xdg.configHome}/git/hooks";
      };

      merge.conflictStyle = "zdiff3";
      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate = true;
        "keep-plus-minus-markers" = true;
        line-numbers = true;
      };

      ghq = {
        root = "~/ghq";
        user = "suzuuuuu09";
      };

      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # Keep ~/.config/git as the repository directory link managed by dotfiles.nix.
  xdg.configFile."git/config".enable = false;
  xdg.configFile."gh/git-config.inc".text =
    config.xdg.configFile."git/config".text;
}
