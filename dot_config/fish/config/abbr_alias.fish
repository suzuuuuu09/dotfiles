abbr -a sc "source $FISH_CONFIG_DIR/config.fish"

# ls
alias ls eza
abbr -a la "ls -aF"
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

# Find
alias find fd
alias grep "rg --color=always"

# Neovim
alias vim nvim
abbr -a nv nvim
abbr -a nvc "nvim $XDG_CONFIG_HOME"
abbr -a nvn "nvim $XDG_CONFIG_HOME/nvim"

# AI
abbr -a co copilot
abbr -a oc opencode

# chezmoi
abbr -a cm chezmoi
abbr -a cma "chezmoi apply"
abbr -a cmA "chezmoi add"
