function fzf-directory
    set --local directory (fd --type d --hidden --exclude .git | fzf)
    if test -n "$directory"
        __fzf_cd "$directory"
    else
        commandline -f repaint
    end
end
