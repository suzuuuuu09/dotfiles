{config, ...}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  # ~/.config/ の直下に置くもの
  xdg.configFile = {
    # +----------------------------------------------------------+
    # |                       ディレクトリ                       |
    # +----------------------------------------------------------+
    "oh-my-posh".source = mkLink ".config/oh-my-posh";
    "nix".source = mkLink ".config/nix";
    "nvim".source = mkLink ".config/nvim";
    # 使わないけど一応残しておく
    # "zsh".source = mkLink ".config/zsh";
    "fish".source = mkLink ".config/fish";
    "gh".source = mkLink ".config/gh";
    "lazygit".source = mkLink ".config/lazygit";
    "wezterm".source = mkLink ".config/wezterm";
    "btop".source = mkLink ".config/btop";
    "mise".source = mkLink ".config/mise";
    "karabiner".source = mkLink ".config/karabiner";
    "vde".source = mkLink ".config/vde";
  };

  # ~/ の直下に置くもの
  home.file = {
    # +----------------------------------------------------------+
    # |                         ファイル                         |
    # +----------------------------------------------------------+
    ".gitconfig".source = mkLink ".gitconfig";
    ".global.gitignore".source = mkLink ".global.gitignore";
    ".zshrc".source = mkLink ".zshrc";
    ".zshenv".source = mkLink ".zshenv";
    ".zprofile".source = mkLink ".zprofile";
  };
}
