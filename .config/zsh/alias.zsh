alias ls="eza"
alias la="eza -aF"
alias ll="eza -lF"

# 移動関係
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias j="z"
alias ji="zi"
alias cd="z"
alias cdi="zi"

alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

alias vim="nvim"
alias nv="nvim"

alias nx="nlx"

alias codr="code -r"

alias czm="chezmoi"

# cdの後にlaを実行する
chpwd() {
	if [[ $(pwd) != $HOME ]]; then;
		la
	fi
}
