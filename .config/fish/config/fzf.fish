# fzfのデフォルトオプション設定
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -gx FZF_DEFAULT_OPTS "
  --height=40% --reverse
  --preview '
    if test -d {}
      eza -a --tree --level=1 --icons --group-directories-first --color=always {}
    else
      bat --style=numbers --color=always --line-range :500 {}
    end
  '
	--color=fg:#e5e9f0,bg:-1,hl:#81a1c1
  --color=fg+:#e5e9f0,bg+:-1,hl+:#81a1c1
  --color=info:#ebcb8b,prompt:#81a1c1,pointer:#b48ead
  --color=marker:#a3be8c,spinner:#b48ead,header:#a3be8c
  --layout=reverse --border
"
# set -gx FZF_CTRL_T_COMMAND "fd --type f"
# set -gx FZF_ALT_C_COMMAND "fd --type d"

# Nord theme for fzf
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
#     --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
#     --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
#     --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'
