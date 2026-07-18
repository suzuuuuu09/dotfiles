function __fzf_cd --argument-names directory --description 'Put an fzf directory selection on the command line.'
    if test (count $argv) -ne 1
        return 2
    end

    set --local escaped_directory (string escape -- "$directory")
    commandline --replace "cd -- $escaped_directory"

    if functions --query _omp_enter_key_handler
        _omp_enter_key_handler
    else
        commandline -f execute
    end
end
