def affected($patterns): any(.[]; test($patterns | join("|")));

def ci_paths:
  {
    nix: affected([
      "\\.nix$",
      "^flake\\.lock$",
      "^skills/registry/sources\\.lock\\.json$",
      "^omp/plugins/npins/sources\\.json$",
      "^\\.github/workflows/nix-build\\.yaml$",
      "^\\.github/actions/setup-nix/action\\.yaml$"
    ]),
    nvim: affected([
      "^\\.config/nvim/",
      "^scripts/nvim-restore\\.sh$",
      "^flake\\.(lock|nix)$",
      "^\\.github/workflows/nix-nvim\\.yaml$",
      "^\\.github/actions/setup-nix/action\\.yaml$"
    ]),
    wezterm: affected([
      "^\\.config/wezterm/",
      "^\\.github/workflows/wezterm-linter\\.yaml$",
      "^\\.github/actions/setup-nix/action\\.yaml$"
    ]),
    renovate: affected([
      "^\\.github/renovate\\.jsonc$",
      "^\\.github/workflows/(renovate|renovate-config-validator)\\.yaml$",
      "^scripts/(renovate-agent-sources\\.sh|test_renovate_agent_sources\\.py)$"
    ]),
    actions: affected(["^\\.github/(workflows|actions)/"])
  };
