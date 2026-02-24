function cd --on-variable PWD
    if status is-interactive
        eza -aF --icons
    end
end
