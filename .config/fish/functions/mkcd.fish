function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>"
        return 1
    end

    set dir $argv[1]

    if test -d $dir
        echo "Directory '$dir' already exists."
        return 1
    end

    mkdir -p $dir
    cd $dir
end
