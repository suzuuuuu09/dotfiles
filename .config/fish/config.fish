# XDG Base Directory Specification
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim

# Non-interactive fish is used by scripts and tools that do not need prompt
# rendering, aliases, bindings, or shell hooks.
if not status is-interactive
    return
end

set fish_greeting

fish_config theme choose nord

set -g FISH_CONFIG_DIR $HOME/.config/fish

# config/*.fish を読み込む
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file
end

# tool_setup.fish を読み込む
source "$FISH_CONFIG_DIR/tool_setup.fish"

# Reproduce Oh My Posh's transient prompt and command acceptance behavior.
bind \r __fish_prompt_enter_key_handler -M default
bind \r __fish_prompt_enter_key_handler -M insert
bind \r __fish_prompt_enter_key_handler -M visual
bind \n __fish_prompt_enter_key_handler -M default
bind \n __fish_prompt_enter_key_handler -M insert
bind \n __fish_prompt_enter_key_handler -M visual
bind \cc __fish_prompt_ctrl_c_key_handler -M default
bind \cc __fish_prompt_ctrl_c_key_handler -M insert
bind \cc __fish_prompt_ctrl_c_key_handler -M visual

if status is-interactive
    # Commands to run in interactive sessions can go here
end
