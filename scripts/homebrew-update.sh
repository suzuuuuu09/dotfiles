#!/usr/bin/env bash

# Update the Homebrew packages declared in .config/nix/home/darwin/homebrew.nix.
# Usage: homebrew-update.sh [--dry-run]

set -euo pipefail

DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: homebrew-update.sh [--dry-run]

Update managed Homebrew formulae and selected casks.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --dry-run)
    DRY_RUN=1
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown argument: %s\n' "$1" >&2
    usage >&2
    exit 1
    ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

command -v nix >/dev/null 2>&1 || {
  printf 'nix is required\n' >&2
  exit 1
}

command -v brew >/dev/null 2>&1 || {
  printf 'brew is required\n' >&2
  exit 1
}

load_manifest_list() {
  local attr_name="$1"
  local expr
  expr='
    let
      mod = import ./.config/nix/home/darwin/homebrew.nix {
        lib = { mkAfter = x: x; };
        username = "codex";
      };
    in
    builtins.concatStringsSep "\n" mod._module.args.homebrewManifest.'"${attr_name}"
  nix eval --impure --raw --expr "$expr"
}

formulae=()
while IFS= read -r item || [[ -n $item ]]; do
  [[ -n $item ]] && formulae+=("$item")
done < <(load_manifest_list managedBrews)

casks=()
while IFS= read -r item || [[ -n $item ]]; do
  [[ -n $item ]] && casks+=("$item")
done < <(load_manifest_list upgradableCasks)

run_or_print() {
  local label="$1"
  shift

  if [[ $DRY_RUN -eq 1 ]]; then
    printf 'would %s: %s\n' "$label" "$*"
    return 0
  fi

  "$@"
}

is_installed() {
  local kind="$1"
  local name="$2"

  brew list "--${kind}" --versions "$name" >/dev/null 2>&1
}

is_outdated() {
  local kind="$1"
  local name="$2"

  local output
  output="$(brew outdated "--${kind}" --quiet "$name" 2>/dev/null || true)"
  [[ -n $output ]]
}

update_formula() {
  local name="$1"

  if ! is_installed formula "$name"; then
    printf 'skip formula (not installed): %s\n' "$name"
    return 0
  fi

  if ! is_outdated formula "$name"; then
    printf 'up-to-date formula: %s\n' "$name"
    return 0
  fi

  printf 'upgrade formula: %s\n' "$name"
  if ! run_or_print "upgrade formula" brew upgrade --formula "$name"; then
    printf 'skip formula (upgrade failed): %s\n' "$name"
  fi
}

update_cask() {
  local name="$1"

  if ! is_installed cask "$name"; then
    printf 'skip cask (not installed): %s\n' "$name"
    return 0
  fi

  if ! is_outdated cask "$name"; then
    printf 'up-to-date cask: %s\n' "$name"
    return 0
  fi

  printf 'upgrade cask: %s\n' "$name"
  if ! run_or_print "upgrade cask" brew upgrade --cask "$name"; then
    printf 'skip cask (upgrade failed): %s\n' "$name"
  fi
}

if [[ $DRY_RUN -eq 1 ]]; then
  printf 'dry-run: brew update\n'
else
  brew update
fi

for formula in "${formulae[@]}"; do
  update_formula "$formula"
done

for cask in "${casks[@]}"; do
  update_cask "$cask"
done
