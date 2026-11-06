#!/usr/bin/env bash
set -euo pipefail

command=$(sed -n 's/^        run: //p' .github/workflows/renovate-merge.yaml)
export GH_REPO=example/dotfiles PR_NUMBER=123 HEAD_SHA=checked-sha

gh() {
  printf '%s\n' "$@"
  return "${GH_EXIT_CODE:-0}"
}
export -f gh

expected=$(printf '%s\n' pr merge 123 --auto --squash --match-head-commit checked-sha)
[[ $(bash -euo pipefail -c "$command") == "$expected" ]]

if GH_EXIT_CODE=1 bash -euo pipefail -c "$command" >/dev/null; then
  exit 1
fi
