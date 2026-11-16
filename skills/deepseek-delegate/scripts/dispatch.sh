#!/usr/bin/env bash
# One-shot Nix/OpenCode dispatch for a bounded coding task.
# No user code is committed, pushed, or deleted by this wrapper.
set -uo pipefail
umask 077

usage() {
  cat <<'USAGE'
Usage: dispatch.sh --brief /absolute/brief.md [--repo /path/to/git/repo]
                   [--model opencode/deepseek-v4.1-flash-free]
                   [--allow-dirty] [--auto]

Allowed models (only if still listed as free):
  opencode/deepseek-v4.1-flash-free (default)
  opencode/glm-5.3-flash-free

--allow-dirty: only after the orchestrator reviews existing changes.
--auto: auto-approve OpenCode's ask-gated actions; requires explicit user approval.
USAGE
}

brief=""
repo="$PWD"
model="opencode/deepseek-v4.1-flash-free"
allow_dirty=false
auto=false
while (($#)); do
  case "$1" in
  --brief | --repo | --model)
    key="$1"
    if (($# < 2)); then
      printf 'Missing value for %s\n' "$key" >&2
      exit 2
    fi
    case "$key" in
    --brief) brief="$2" ;;
    --repo) repo="$2" ;;
    --model) model="$2" ;;
    esac
    shift 2
    ;;
  --allow-dirty)
    allow_dirty=true
    shift
    ;;
  --auto)
    auto=true
    shift
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown argument: %s\n' "$1" >&2
    usage >&2
    exit 2
    ;;
  esac
done

case "$model" in
opencode/deepseek-v4.1-flash-free | opencode/glm-5.3-flash-free) ;;
*)
  printf 'Rejected non-allowlisted model: %s\n' "$model" >&2
  exit 2
  ;;
esac
if [[ -z $brief || ! -s $brief ]]; then
  printf 'Brief must be an existing nonempty file.\n' >&2
  exit 2
fi
if ! command -v nix >/dev/null 2>&1; then
  printf 'Nix is unavailable.\n' >&2
  exit 127
fi
if ! command -v git >/dev/null 2>&1; then
  printf 'git is unavailable.\n' >&2
  exit 127
fi
root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || {
  printf 'Target is not a Git repository: %s\n' "$repo" >&2
  exit 2
}
if [[ -n "$(git -C "$root" status --porcelain)" && $allow_dirty != true ]]; then
  printf 'Working tree is dirty; review existing changes first, then use --allow-dirty if safe.\n' >&2
  git -C "$root" status --short >&2
  exit 3
fi

outdir="$(mktemp -d "${TMPDIR:-/tmp}/deepseek-delegate.XXXXXXXX")" || exit 1
printf 'Output directory: %s\n' "$outdir"
printf '%s\n' "$model" >"$outdir/model.txt"
git -C "$root" status --short >"$outdir/status-before.txt"

args=(run --model "$model" --agent build)
if [[ $auto == true ]]; then args+=(--auto); fi
args+=("$(cat "$brief")")

printf 'Delegating in: %s\n' "$root"
(
  cd "$root" || exit 2
  nix run 'github:numtide/llm-agents.nix#opencode' -- "${args[@]}"
) 2>&1 | tee "$outdir/output.log"
exit_code=${PIPESTATUS[0]}
printf '%s\n' "$exit_code" >"$outdir/exit-code.txt"
git -C "$root" status --short >"$outdir/status-after.txt"
git -C "$root" diff --check >"$outdir/diff-check.txt" 2>&1
printf 'OpenCode exit code: %s\n' "$exit_code"
printf 'Logs: %s\n' "$outdir"
exit "$exit_code"
