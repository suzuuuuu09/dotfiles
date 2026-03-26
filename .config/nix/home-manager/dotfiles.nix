{config, ...}: let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in {
  home.file = {
    # +----------------------------------------------------------+
    # |                         ファイル                         |
    # +----------------------------------------------------------+
    ".gitconfig".source = mkLink ".gitconfig";
    ".global.gitignore".source = mkLink ".global.gitignore";
    ".zshrc".source = mkLink ".zshrc";
    ".zshenv".source = mkLink ".zshenv";
    ".zprofile".source = mkLink ".zprofile";

    # +----------------------------------------------------------+
    # |                       ディレクトリ                       |
    # +----------------------------------------------------------+
    ".config/nix".source = mkLink ".config/nix";
    ".config/nvim".source = mkLink ".config/nvim";
    # 使わないけど一応残しておく
    # ".config/zsh".source = mkLink ".config/zsh";
    ".config/oh-my-posh".source = mkLink ".config/oh-my-posh";
    ".config/fish".source = mkLink ".config/fish";
    ".config/gh".source = mkLink ".config/gh";
    ".config/lazygit".source = mkLink ".config/lazygit";
    ".config/wezterm".source = mkLink ".config/wezterm";
    ".config/btop".source = mkLink ".config/btop";
    ".config/mise".source = mkLink ".config/mise";
  };
}
