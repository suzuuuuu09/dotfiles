abbr -a sc "source $FISH_CONFIG_DIR/config.fish"

# ls
alias ls "eza --icons --git"
abbr -a la "ls -aF --ignore-glob=.DS_Store"
abbr -a ll "ls -lF"
abbr -a lt "ls -TF"

# Change Directory
alias cdi zi
abbr -a j z
abbr -a ji zi
abbr -a .. "z .."
abbr -a ... "z ../.."
abbr -a .... "z ../../.."
abbr -a ..... "z ../../../.."

abbr -a pbc pbcopy
abbr -a pbp pbpaste

abbr -a o open

# Aliases to alternative tools
alias find fd
alias grep "rg --color=always"
alias curl curlie
alias rm gomi

# +----------------------------------------------------------+
# |                         Homebrew                         |
# +----------------------------------------------------------+
abbr -a br brew
abbr -a bi "brew install"
abbr -a bu "brew upgrade"

# +----------------------------------------------------------+
# |                          Neovim                          |
# +----------------------------------------------------------+
alias vim nvim
abbr -a nv nvim
abbr -a nvc "nvim $XDG_CONFIG_HOME"
abbr -a nvn "nvim $XDG_CONFIG_HOME/nvim"

# +----------------------------------------------------------+
# |                            AI                            |
# +----------------------------------------------------------+
abbr -a co codex

# @antfu/ni
abbr -a nx nlx

# +----------------------------------------------------------+
# |                         lazygit                          |
# +----------------------------------------------------------+
abbr -a lg lazygit

# +----------------------------------------------------------+
# |                          Direnv                          |
# +----------------------------------------------------------+
abbr -a de "direnv allow"

# abbr -a , --position anywhere --set-cursor 'nix run nixpkgs#%'

# +----------------------------------------------------------+
# |                           ghq                            |
# +----------------------------------------------------------+
abbr -a gg "ghq get"

# +----------------------------------------------------------+
# |                           Nix                            |
# +----------------------------------------------------------+
abbr -a nix-clean "nix-collect-garbage -d && nix-store --optimize"
abbr -a nfu "nix flake update"
abbr -a nfc "nix flake check"
switch (uname)
    case Darwin
        abbr -a nix-switch "sudo darwin-rebuild switch --flake ~/dotfiles#(scutil --get LocalHostName)"
        abbr -a nix-build "darwin-rebuild build --flake ~/dotfiles#(scutil --get LocalHostName)"
        abbr -a nix-check "darwin-rebuild check --flake ~/dotfiles#(scutil --get LocalHostName)"
    case Linux
        abbr -a nix-switch "sudo nixos-rebuild switch --flake ~/dotfiles#suzuWsl"
        abbr -a nix-build "sudo nixos-rebuild build --flake ~/dotfiles#suzuWsl"
        abbr -a nix-check "sudo nixos-rebuild check --flake ~/dotfiles#suzuWsl"
        alias open explorer.exe
        alias xdg-open explorer.exe
        alias pbcopy clip.exe
        alias pbpaste "powershell.exe -NoProfile -Command Get-Clipboard"
end
