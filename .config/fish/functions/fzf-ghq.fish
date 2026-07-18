function fzf-ghq
    set --local selected_repo (ghq list --full-path | string replace -- "$HOME/" "~/" | fzf)
    if test -z "$selected_repo"
        commandline -f repaint
        return
    end

    if string match --quiet -- "$HOME/*" "$selected_repo"
        set selected_repo (string replace -- "$HOME/" "~/" "$selected_repo")
    end

    __fzf_cd "$selected_repo"
end
