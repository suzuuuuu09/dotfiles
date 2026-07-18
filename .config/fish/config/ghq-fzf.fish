function ghq-fzf
    set res (ghq list --full-path | fzf)
    if test -n "$res"
        if cd -- $res
            set -g _omp_new_prompt 1
        end
    end
    commandline -f repaint
end

bind \cg ghq-fzf
