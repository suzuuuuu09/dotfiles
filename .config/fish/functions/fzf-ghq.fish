function fzf-ghq
    set --local selected_repo (ghq list --full-path | string replace -- "$HOME/" "~/" | fzf)
    if test -z "$selected_repo"
        commandline -f repaint
        return
    end

    __fzf_cd "$selected_repo"
end
