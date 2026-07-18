function fzf-directory
    set dir (fd --type d --hidden --exclude .git | fzf)
    if test -n "$dir"
        cd "$dir"
        commandline -f repaint
    end
end
