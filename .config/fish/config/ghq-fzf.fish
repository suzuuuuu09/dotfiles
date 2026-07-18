function ghq-fzf
    set --local selected_repo (ghq list --full-path | fzf)
    if test -z "$selected_repo"
        commandline -f repaint
        return
    end

    __fzf_cd "$selected_repo"
end

bind \cg ghq-fzf
