set -g OH_MY_POSH_THEME nord-detailed

# Oh-My-Posh
oh-my-posh init fish --config $HOME/.config/oh-my-posh/themes/$OH_MY_POSH_THEME.omp.json | source

# zoxide
zoxide init fish | source
