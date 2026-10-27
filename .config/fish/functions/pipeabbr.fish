function __pipe_expand
    set -l line (commandline --current-job --cut-at-cursor)

    # 前にコマンドが必要
    string match -qr '\S.*\s+\S+\s*$' -- "$line"; or return 1

    # 直前がパイプなら展開しない
    set -l prefix (string replace -r '\s+\S+\s*$' '' -- "$line")
    string match -qr '\|\s*$' -- "$prefix"; and return 1

    set -l key "__pipe_abbr_$argv[1]"
    set -q $key; or return 1

    printf '| %s\n' $$key
end

function pipeabbr --argument-names key target
    set -g "__pipe_abbr_$key" "$target"
    abbr -a $key --position anywhere --function __pipe_expand
end
