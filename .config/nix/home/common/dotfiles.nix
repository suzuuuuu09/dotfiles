{config, ...}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path:
    config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  # ~/.config/ の直下に置くもの
  xdg.configFile = {
    # +----------------------------------------------------------+
    # |                       ディレクトリ                       |
    # +----------------------------------------------------------+
    "bat".source = mkLink ".config/bat";
    "cxr".source = mkLink ".config/cxr";
    "oh-my-posh".source = mkLink ".config/oh-my-posh";
    "nix".source = mkLink ".config/nix";
    "nvim".source = mkLink ".config/nvim";
    "yazi".source = mkLink ".config/yazi";
    "tmux".source = mkLink ".config/tmux";
    # 使わないけど一応残しておく
    # "zsh".source = mkLink ".config/zsh";
    "fish".source = mkLink ".config/fish";
    "gh".source = mkLink ".config/gh";
    "lazygit".source = mkLink ".config/lazygit";
    "wezterm".source = mkLink ".config/wezterm";
    "ghostty".source = mkLink ".config/ghostty";
    "btop".source = mkLink ".config/btop";
    "mise".source = mkLink ".config/mise";
    "vde".source = mkLink ".config/vde";
    "git".source = mkLink ".config/git";
  };

  # ~/ の直下に置くもの
  home.file = {
    # +----------------------------------------------------------+
    # |                         ファイル                         |
    # +----------------------------------------------------------+
    ".gitconfig".source = mkLink ".gitconfig";
    ".zshrc".source = mkLink ".zshrc";
    ".zshenv".source = mkLink ".zshenv";
    ".zprofile".source = mkLink ".zprofile";
  };
}
