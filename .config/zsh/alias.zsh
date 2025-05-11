alias ls="ls --color=auto"
alias la="ls -aF --color=auto"
alias ll="ls -lF --color=auto"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

alias vim="nvim"
alias nv="nvim"

alias codr="code -r"

alias df="dotfiles"

# cdの後にlaを実行する
chpwd() {
	if [[ $(int) != $HOME ]]; then;
		la
	fi
}
