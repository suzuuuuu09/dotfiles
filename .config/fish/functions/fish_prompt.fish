set -g __fish_git_prompt_showdirtystate no
set -g __fish_git_prompt_showuntrackedfiles no
set -g __fish_git_prompt_showstashstate no
set -g __fish_git_prompt_show_informative_status no
set -g __fish_git_prompt_showcolorhints no
set -e __fish_git_prompt_showupstream

function __fish_prompt_segment --argument-names previous_background background foreground text padding
    set -l prefix ' '
    set -l suffix ' '
    switch "$padding"
        case no-leading
            set prefix ''
        case no-trailing
            set suffix ''
    end

    if test -n "$previous_background"
        set_color --background=$previous_background
        set_color --foreground=$background
    else
        set_color --background=normal
        set_color --foreground=$background
    end
    printf ''
    set_color --background=$background
    set_color --foreground=$foreground
    printf '%s%s%s' "$prefix" "$text" "$suffix"
    set_color normal
end

function __fish_prompt_language_icon --argument-names type
    switch $type
        case node
            printf '\ued0d'
        case python
            printf '\ue235'
        case aws
            printf '\ue7ad'
        case cf
            printf '\uf40a'
        case cmake
            printf '\ue61e \ue61d'
        case dart
            printf '\ue798'
        case dotnet
            printf '\ue77f'
        case flutter
            printf '\ue28e'
        case go
            printf '\ue627'
        case java
            printf '\ue738'
        case kotlin
            printf K
        case lua
            printf '\ue620'
        case rust
            printf '\ue7a8'
    end
end

function __fish_prompt_duration --argument-names milliseconds --description 'Format command duration like Oh My Posh.'
    set milliseconds (string match --regex --groups-only --max 1 '(^[0-9]+)' -- "$milliseconds")
    test -n "$milliseconds" || set milliseconds 0

    if test $milliseconds -lt 1000
        printf '%sms' $milliseconds
        return
    end

    set -l hours (math --scale 0 "$milliseconds / 3600000")
    set -l remainder (math --scale 0 "$milliseconds % 3600000")
    set -l minutes (math --scale 0 "$remainder / 60000")
    set remainder (math --scale 0 "$remainder % 60000")
    set -l seconds (math --scale 0 "$remainder / 1000")
    set -l milliseconds_remainder (math --scale 0 "$remainder % 1000")
    set -l fields

    if test $hours -gt 0
        set --append fields "$hours"h
    end
    if test $hours -gt 0; or test $minutes -gt 0
        set --append fields "$minutes"m
    end
    if test $hours -gt 0; or test $minutes -gt 0; or test $seconds -gt 0
        set --append fields "$seconds"s
    end
    set --append fields "$milliseconds_remainder"ms
    string join ' ' $fields
end

function fish_prompt --description 'Render the native Nord prompt.'
    if contains -- --final-rendering $argv
        set_color '#EBCB8B'
        printf ' '
        set_color normal
        return
    end

    if not set -q __fish_prompt_context_pwd; or test "$__fish_prompt_context_pwd" != "$PWD"
        __fish_prompt_refresh_context
    end

    set -l previous_background
    set -l segment_background '#4C566A'
    set -l os_text (__fish_prompt_os_text)
    __fish_prompt_segment "$previous_background" $segment_background '#E5E9F0' $os_text
    set previous_background $segment_background

    set segment_background '#88C0D0'
    __fish_prompt_segment "$previous_background" $segment_background '#2E3440' ' fish' no-trailing
    set previous_background $segment_background

    if test -n "$__fish_prompt_context_memory"
        set segment_background '#81A1C1'
        __fish_prompt_segment "$previous_background" $segment_background '#E5E9F0' " $__fish_prompt_context_memory"
        set previous_background $segment_background
    end

    if test (count $__fish_prompt_context_language_types) -gt 0
        for index in (seq (count $__fish_prompt_context_language_types))
            set -l type $__fish_prompt_context_language_types[$index]
            set -l value $__fish_prompt_context_language_values[$index]
            set -l language_icon (__fish_prompt_language_icon $type)
            set -l language_text "$language_icon"
            if test -n "$value"
                set language_text "$language_icon $value"
            end
            switch $type
                case cf dotnet
                    set language_text "$language_icon  $value"
                case cmake
                    set language_text "$language_icon  cmake $value"
            end
            set segment_background '#B48EAD'
            switch $type
                case node python
                    __fish_prompt_segment "$previous_background" $segment_background '#E5E9F0' "$language_text"
                case '*'
                    __fish_prompt_segment "$previous_background" $segment_background '#E5E9F0' "$language_text" no-leading
            end
            set previous_background $segment_background
        end
    end

    set -l git_value (fish_git_prompt '%s')
    if test -n "$git_value"
        set segment_background '#A3BE8C'
        set -l git_icon ' '
        if test "$__fish_prompt_context_git_remote" = 1
            set git_icon (printf '\e]8;;%s\e\\\e]8;;\e\\' "$__fish_prompt_context_git_url")
        end
        __fish_prompt_segment "$previous_background" $segment_background '#2E3440' "$git_icon$git_value"
        set previous_background $segment_background
    end

    set segment_background '#434C5E'
    set -l command_duration $CMD_DURATION[1]
    __fish_prompt_segment "$previous_background" $segment_background '#E5E9F0' (__fish_prompt_duration $command_duration)
    set_color --background=normal
    set_color --foreground=$segment_background
    printf ''
    set_color normal

    printf '\n'
    set_color '#EBCB8B'
    printf '╭─'
    set_color normal
    set_color '#E5E9F0'
    printf ' ♥ %s |' (date '+%H:%M')
    set_color normal

    if test "$__fish_prompt_context_is_root" = 1
        set_color '#BF616A'
        printf '  '
        set_color normal
    end

    set_color '#E5E9F0'
    printf ' %s ' (prompt_pwd --dir-length=0)
    set_color normal

    set -l prompt_character '$'
    test "$__fish_prompt_context_is_root" = 1; and set prompt_character '#'
    printf '\n'
    set_color '#EBCB8B'
    printf '╰─ '
    set_color '#B48EAD'
    printf '%s' $prompt_character
    set_color normal
    printf ' '
end

function fish_title
    path basename $PWD
end
