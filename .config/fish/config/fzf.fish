# fzfのデフォルトオプション設定
set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -gx FZF_DEFAULT_OPTS "
  --height=40%
  --preview '
    if test -d {}
      eza -a --tree --level=1 --icons --group-directories-first --color=always --ignore-glob=.DS_Store,.git {}
    else
      bat --style=numbers --color=always --line-range :500 {}
    end
  '
	--color=fg:#e5e9f0,bg:-1,hl:#81a1c1
  --color=fg+:#e5e9f0,bg+:-1,hl+:#81a1c1
  --color=info:#ebcb8b,prompt:#81a1c1,pointer:#81a1c1
  --color=marker:#a3be8c,spinner:#b48ead,header:#a3be8c
  --layout=reverse --border
"

bind \co fzf-directory
bind \cg fzf-ghq
