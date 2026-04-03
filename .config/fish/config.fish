if status is-interactive
    set fish_greeting
end

# XDG Base Directory Specification
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim

fish_config theme choose nord

set -g FISH_CONFIG_DIR $HOME/.config/fish

# config/*.fish を読み込む
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file
end

# tool_setup.fish を読み込む
source "$FISH_CONFIG_DIR/tool_setup.fish"

if status is-interactive
    # Commands to run in interactive sessions can go here
end
