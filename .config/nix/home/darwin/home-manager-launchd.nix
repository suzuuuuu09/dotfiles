{
  config,
  lib,
  ...
}: let
  dstDir = "${config.home.homeDirectory}/Library/LaunchAgents";
in {
  # Work around a Home Manager Darwin regression where `launchctl bootout --wait`
  # fails with "Unrecognized target specifier" for LaunchAgents on recent macOS.
  home.activation.setupLaunchAgents = lib.mkForce (lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Disable errexit to ensure we process all agents even if some fail
    set +e

    readAgentDomain() {
      local domainsDir="$1"
      local agentName="$2"
      local domainFile="$domainsDir/$agentName.domain"

      if [[ -n "$domainsDir" && -f "$domainFile" ]]; then
        local domainName
        domainName="$(<"$domainFile")"
        case "$domainName" in
          gui|user)
            printf '%s\n' "$domainName"
            ;;
          *)
            printf 'gui\n'
            ;;
        esac
      else
        printf 'gui\n'
      fi
    }

    resolveDomain() {
      local domainName="$1"

      case "$domainName" in
        gui)
          printf 'gui/%s\n' "$UID"
          ;;
        user)
          printf 'user/%s\n' "$UID"
          ;;
      esac
    }

    bootoutAgent() {
      local domain="$1"
      local agentName="$2"

      verboseEcho "Stopping agent '$domain/$agentName'..."
      local bootout_output
      bootout_output=$(run /bin/launchctl bootout "$domain/$agentName" 2>&1) || {
        if [[ "$bootout_output" != *"No such process"* ]]; then
          warnEcho "Failed to stop agent '$domain/$agentName': $bootout_output"
        else
          verboseEcho "Agent '$domain/$agentName' was not running"
        fi
      }
    }

    installAndBootstrapAgent() {
      local srcPath="$1"
      local dstPath="$2"
      local domain="$3"
      local agentName="$4"

      verboseEcho "Installing agent file to $dstPath"
      if ! run install -Dm444 -T "$srcPath" "$dstPath"; then
        errorEcho "Failed to install agent file for '$agentName'"
        return 1
      fi

      verboseEcho "Starting agent '$domain/$agentName'"
      local bootstrap_output
      bootstrap_output=$(run /bin/launchctl bootstrap "$domain" "$dstPath" 2>&1) || {
        if [[ "$bootstrap_output" == *"Bootstrap failed: 5: Input/output error"* ]]; then
          errorEcho "Failed to start agent '$domain/$agentName' with I/O error (code 5)"
          errorEcho "This typically happens when the agent wasn't unloaded before attempting to bootstrap the new agent."
        else
          errorEcho "Failed to start agent '$domain/$agentName' with error: $bootstrap_output"
        fi

        return 1
      }

      verboseEcho "Successfully started agent '$domain/$agentName'"
      return 0
    }

    processAgent() {
      local srcPath="$1"
      local dstDir="$2"
      local oldDomainsDir="$3"
      local newDomainsDir="$4"

      local agentFile="''${srcPath##*/}"
      local agentName="''${agentFile%.plist}"
      local dstPath="$dstDir/$agentFile"
      local oldDomainName
      local newDomainName
      local oldDomain
      local newDomain

      oldDomainName="$(readAgentDomain "$oldDomainsDir" "$agentName")"
      newDomainName="$(readAgentDomain "$newDomainsDir" "$agentName")"
      oldDomain="$(resolveDomain "$oldDomainName")"
      newDomain="$(resolveDomain "$newDomainName")"

      if cmp -s "$srcPath" "$dstPath" && [[ "$oldDomainName" == "$newDomainName" ]]; then
        verboseEcho "Agent '$newDomain/$agentName' is already up-to-date"
        return 0
      fi

      verboseEcho "Processing agent '$newDomain/$agentName'"

      if [[ -f "$dstPath" ]]; then
        bootoutAgent "$oldDomain" "$agentName"
      fi

      installAndBootstrapAgent "$srcPath" "$dstPath" "$newDomain" "$agentName"
      return 0
    }

    removeAgent() {
      local srcPath="$1"
      local dstDir="$2"
      local newDir="$3"
      local oldDomainsDir="$4"

      local agentFile="''${srcPath##*/}"
      local agentName="''${agentFile%.plist}"
      local dstPath="$dstDir/$agentFile"
      local domainName
      local domain

      domainName="$(readAgentDomain "$oldDomainsDir" "$agentName")"
      domain="$(resolveDomain "$domainName")"

      if [[ -e "$newDir/$agentFile" ]]; then
        verboseEcho "Agent '$agentName' still exists in new generation, skipping cleanup"
        return 0
      fi

      if [[ ! -e "$dstPath" ]]; then
        verboseEcho "Agent file '$dstPath' already removed"
        return 0
      fi

      if ! cmp -s "$srcPath" "$dstPath"; then
        warnEcho "Skipping deletion of '$dstPath', since its contents have diverged"
        return 0
      fi

      bootoutAgent "$domain" "$agentName"

      verboseEcho "Removing agent file '$dstPath'"
      if run rm -f $VERBOSE_ARG "$dstPath"; then
        verboseEcho "Successfully removed agent file for '$agentName'"
      else
        warnEcho "Failed to remove agent file '$dstPath'"
      fi

      return 0
    }

    setupLaunchAgents() {
      local oldDir newDir oldDomainsDir newDomainsDir dstDir

      newDir="$(readlink -m "$newGenPath/LaunchAgents")"
      newDomainsDir="$(readlink -m "$newGenPath/LaunchAgentDomains")"
      dstDir=${lib.escapeShellArg dstDir}

      if [[ -n "''${oldGenPath:-}" ]]; then
        oldDir="$(readlink -m "$oldGenPath/LaunchAgents")"
        if [[ ! -d "$oldDir" ]]; then
          verboseEcho "No previous LaunchAgents directory found"
          oldDir=""
        fi

        oldDomainsDir="$(readlink -m "$oldGenPath/LaunchAgentDomains")"
        if [[ ! -d "$oldDomainsDir" ]]; then
          oldDomainsDir=""
        fi
      else
        oldDir=""
        oldDomainsDir=""
      fi

      verboseEcho "Setting up LaunchAgents in $dstDir"
      [[ -d "$dstDir" ]] || run mkdir -p "$dstDir"

      verboseEcho "Processing new/updated LaunchAgents..."
      find -L "$newDir" -maxdepth 1 -name '*.plist' -type f | while read -r srcPath; do
        processAgent "$srcPath" "$dstDir" "$oldDomainsDir" "$newDomainsDir"
      done

      if [[ -z "$oldDir" || ! -d "$oldDir" ]]; then
        verboseEcho "LaunchAgents setup complete"
        return
      fi

      verboseEcho "Cleaning up removed LaunchAgents..."
      find -L "$oldDir" -maxdepth 1 -name '*.plist' -type f | while read -r srcPath; do
        removeAgent "$srcPath" "$dstDir" "$newDir" "$oldDomainsDir"
      done
    }

    setupLaunchAgents

    set -e
  '');
}
