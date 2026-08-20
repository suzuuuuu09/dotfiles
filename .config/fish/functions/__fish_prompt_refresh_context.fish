function __fish_prompt_has_marker --description 'Check whether the current directory matches a prompt marker.'
    set -l entries *

    for pattern in $argv
        if string match --quiet --regex '[*?\[]' -- "$pattern"
            if string match --quiet -- "$pattern" $entries
                return 0
            end
        else if test -e "$pattern"
            return 0
        end
    end

    return 1
end

function __fish_prompt_version --argument-names tool_command --description 'Read a tool version for the cached prompt context.'
    if not command -sq $tool_command
        return 1
    end

    set -l output (command $argv 2>&1)
    set -l prompt_version (string match --regex --groups-only --max 1 '([0-9]+(\.[0-9]+)+)' -- $output)
    if test -n "$prompt_version"
        printf '%s' $prompt_version[1]
        return 0
    end

    return 1
end

function __fish_prompt_memory --description 'Read the approximate used and total memory.'
    switch "$__fish_prompt_context_os"
        case Darwin
            set -l total_bytes (sysctl -n hw.memsize 2>/dev/null)
            set -l vmstat (vm_stat 2>/dev/null)
            set -l page_size (string match --regex --groups-only --max 1 'page size of ([0-9]+) bytes' -- $vmstat)
            set -l free_pages (string match --regex --groups-only --max 1 '^Pages free:\s+([0-9]+)' -- $vmstat)
            set -l inactive_pages (string match --regex --groups-only --max 1 '^Pages inactive:\s+([0-9]+)' -- $vmstat)
            set -l speculative_pages (string match --regex --groups-only --max 1 '^Pages speculative:\s+([0-9]+)' -- $vmstat)
            set -l purgeable_pages (string match --regex --groups-only --max 1 '^Pages purgeable:\s+([0-9]+)' -- $vmstat)
            if test -z "$total_bytes"; or test -z "$page_size"; or test -z "$free_pages"; or test -z "$inactive_pages"; or test -z "$speculative_pages"; or test -z "$purgeable_pages"
                return 1
            end

            set -l total_gb (math --scale 0 "$total_bytes / 1073741824")
            set -l available_pages (math "$free_pages[1] + $inactive_pages[1] + $speculative_pages[1] + $purgeable_pages[1]")
            set -l used_gb (math --scale 0 "($total_bytes - $available_pages * $page_size[1]) / 1073741824")
            printf '%s/%sGB' $used_gb $total_gb
        case Linux
            if not test -r /proc/meminfo
                return 1
            end

            set -l total_kb (string match --regex --groups-only --max 1 '^MemTotal:\s+([0-9]+)' </proc/meminfo)
            set -l available_kb (string match --regex --groups-only --max 1 '^MemAvailable:\s+([0-9]+)' </proc/meminfo)
            if test -z "$total_kb"; or test -z "$available_kb"
                return 1
            end

            set -l total_gb (math --scale 0 "$total_kb[1] / 1048576")
            set -l used_gb (math --scale 0 "($total_kb[1] - $available_kb[1]) / 1048576")
            printf '%s/%sGB' $used_gb $total_gb
    end

    return 1
end

function __fish_prompt_os_text --description 'Return the current OS icon and optional WSL label.'
    switch "$__fish_prompt_context_os"
        case Darwin
            printf '\uf179'
        case Linux
            if test -r /proc/version; and string match --quiet --ignore-case '*microsoft*' </proc/version
                printf 'WSL at \uf17c'
            else
                printf '\uf31b'
            end
        case '*'
            printf '\ue62a'
    end
end

function __fish_prompt_aws_text --description 'Read the active AWS profile and region without loading credentials.'
    set -l profile $AWS_PROFILE[1]
    set -l profile_is_set 0
    if test -n "$profile"
        set profile_is_set 1
    else if test -n "$AWS_DEFAULT_PROFILE"
        set profile $AWS_DEFAULT_PROFILE[1]
        set profile_is_set 1
    end
    set -l region $AWS_REGION[1]
    test -n "$region" || set region $AWS_DEFAULT_REGION[1]

    test -n "$profile" || set profile default

    if test $profile_is_set = 0; and test -z "$region"
        return 1
    end
    if test -n "$region"
        printf '%s@%s' $profile $region
    else if test -n "$profile"
        printf '%s' $profile
    else
        printf '%s' $region
    end
end

function __fish_prompt_add_language --argument-names language_type --description 'Add a detected language/tool to the cached context.'
    set -l prompt_version (__fish_prompt_version $argv[2..-1])
    if test -z "$prompt_version"
        if test "$language_type" != node
            set prompt_version 'NO VERSION'
        end
    end
    if test "$language_type" = cf
        set prompt_version "cf $prompt_version[1]"
    end
    set --append __fish_prompt_context_language_types $language_type
    set --append __fish_prompt_context_language_values "$prompt_version[1]"
end

function __fish_prompt_refresh_context --description 'Refresh prompt data that changes when the working directory changes.'
    set -g __fish_prompt_context_pwd $PWD
    set -g __fish_prompt_context_os (uname)
    set -g __fish_prompt_context_memory (__fish_prompt_memory)
    set -g __fish_prompt_context_is_root 0
    test (id -u) -eq 0; and set -g __fish_prompt_context_is_root 1

    set -g __fish_prompt_context_git_remote 0
    set -g __fish_prompt_context_git_url
    set -l git_remote_info (command git remote -v 2>/dev/null)
    if test (count $git_remote_info) -gt 0
        set -g __fish_prompt_context_git_remote 1
        set -g __fish_prompt_context_git_url (string match --regex --groups-only --max 1 '^[^[:space:]]+[[:space:]]+(.+)[[:space:]]+\(fetch\)$' -- "$git_remote_info[1]")
    end

    set -g __fish_prompt_context_aws (__fish_prompt_aws_text)
    set -g __fish_prompt_context_language_types
    set -g __fish_prompt_context_language_values

    if __fish_prompt_has_marker '*.js' '*.ts' package.json .nvmrc pnpm-workspace.yaml .pnpmfile.cjs .vue
        __fish_prompt_add_language node node --version
    end

    if __fish_prompt_has_marker '*.py' '*.ipynb' pyproject.toml setup.py venv.bak
        set -l python_version (__fish_prompt_version python --version)
        if test -n "$python_version"
            set -l virtualenv
            if test -n "$VIRTUAL_ENV"
                set virtualenv (path basename "$VIRTUAL_ENV")
            end
            if test -n "$virtualenv"
                set python_version "$virtualenv $python_version[1]"
            end
        else
            set python_version 'NO VERSION'
        end
        set --append __fish_prompt_context_language_types python
        set --append __fish_prompt_context_language_values $python_version[1]
    end

    if test -n "$__fish_prompt_context_aws"
        set --append __fish_prompt_context_language_types aws
        set --append __fish_prompt_context_language_values $__fish_prompt_context_aws
    end

    if __fish_prompt_has_marker manifest.yml mta.yaml
        __fish_prompt_add_language cf cf version
    end

    if __fish_prompt_has_marker CMakeLists.txt '*.cmake'
        __fish_prompt_add_language cmake cmake --version
    end

    if __fish_prompt_has_marker '*.dart' pubspec.yaml pubspec.yml pubspec.lock .dart_tool
        __fish_prompt_add_language dart dart --version
        __fish_prompt_add_language flutter flutter --version
    end

    if __fish_prompt_has_marker '*.cs' '*.csx' '*.vb' '*.sln' '*.slnx' '*.slnf' '*.csproj' '*.vbproj' '*.fs' '*.fsx' '*.fsproj' global.json
        __fish_prompt_add_language dotnet dotnet --version
    end

    if __fish_prompt_has_marker '*.go' go.mod go.sum go.work go.work.sum
        __fish_prompt_add_language go go version
    end

    if __fish_prompt_has_marker pom.xml build.gradle.kts build.sbt .java-version .deps.edn project.clj build.boot '*.java' '*.class' '*.gradle' '*.jar' '*.clj' '*.cljc'
        __fish_prompt_add_language java java -version
    end

    if __fish_prompt_has_marker '*.kt' '*.kts' '*.ktm'
        __fish_prompt_add_language kotlin kotlin -version
    end

    if __fish_prompt_has_marker '*.lua' .luacheckrc '*.rockspec'
        __fish_prompt_add_language lua lua -v
    end

    if __fish_prompt_has_marker Cargo.toml Cargo.lock '*.rs'
        __fish_prompt_add_language rust rustc --version
    end
end
