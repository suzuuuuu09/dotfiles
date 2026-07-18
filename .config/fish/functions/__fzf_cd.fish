function __fzf_cd --argument-names directory --description 'Put an fzf directory selection on the command line.'
    if test (count $argv) -ne 1
        return 2
    end

    set --local escaped_directory
    if string match --quiet -- '~/*' "$directory"
        set --local relative_directory (string sub --start=3 -- "$directory")
        set escaped_directory "~/"(string escape -- "$relative_directory")
    else
        set escaped_directory (string escape -- "$directory")
    end

    commandline --replace "cd -- $escaped_directory"

    if functions --query _omp_enter_key_handler
        _omp_enter_key_handler
    else
        commandline -f execute
    end
end
