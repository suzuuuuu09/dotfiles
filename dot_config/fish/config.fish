if status is-interactive
    set fish_greeting
end

fish_config theme choose nord

set -g FISH_CONFIG_DIR $HOME/.config/fish

# config/*.fish を読み込む
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file
end

# tool_setup.fish を読み込む
source "$FISH_CONFIG_DIR/tool_setup.fish"

# functions/*.fish を読み込む
for file in $FISH_CONFIG_DIR/functions/*.fish
    source $file
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
