include "ci-paths";

def check($files; $expected):
  ($files | ci_paths | to_entries | map(select(.value) | .key) | sort) as $actual
  | if $actual == ($expected | sort) then true
    else error("\($files): expected \($expected), got \($actual)")
    end;

[
  check([]; []),
  check(["README.md", "flake.lock.backup"]; []),
  check(["flake.lock"]; ["nix", "nvim"]),
  check(["flake.nix"]; ["nix", "nvim"]),
  check([".config/nix/home-manager/programs/fish.nix"]; ["nix"]),
  check(["skills/registry/sources.lock.json"]; ["nix"]),
  check(["omp/plugins/npins/sources.json"]; ["nix"]),
  check([".config/nvim/lazy-lock.json"]; ["nvim"]),
  check(["scripts/nvim-restore.sh"]; ["nvim"]),
  check([".config/wezterm/wezterm.lua"]; ["wezterm"]),
  check([".github/renovate.jsonc"]; ["renovate"]),
  check(["scripts/test_renovate_agent_sources.py"]; ["renovate"]),
  check(["scripts/renovate-agent-sources.sh"]; ["renovate"]),
  check([".github/workflows/nix-build.yaml"]; ["nix", "actions"]),
  check([".github/workflows/nix-nvim.yaml"]; ["nvim", "actions"]),
  check([".github/workflows/wezterm-linter.yaml"]; ["wezterm", "actions"]),
  check([".github/workflows/renovate.yaml"]; ["renovate", "actions"]),
  check([".github/workflows/renovate-config-validator.yaml"]; ["renovate", "actions"]),
  check([".github/workflows/renovate-merge.yaml"]; ["actions"]),
  check([".github/actions/setup-nix/action.yaml"]; ["nix", "nvim", "wezterm", "renovate", "actions"]),
  check([".config/nvim/deleted.lua", ".config/wezterm/new name.lua"]; ["nvim", "wezterm"])
] | all
