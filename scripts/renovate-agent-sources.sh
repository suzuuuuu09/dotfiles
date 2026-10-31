#!/usr/bin/env bash
set -euo pipefail

skills_lock=skills/registry/sources.lock.json
pin_lock=$(mktemp)
candidate=$(mktemp "${skills_lock}.XXXXXX")
trap 'rm -f -- "$pin_lock" "$candidate"' EXIT

# Partial updates preserve the exact revisions selected by Renovate.
jq .npins "$skills_lock" >"$pin_lock"
npins --lock-file "$pin_lock" update --partial
jq --sort-keys --slurpfile pins "$pin_lock" '.npins = $pins[0]' "$skills_lock" >"$candidate"
chmod 644 "$candidate"
mv -- "$candidate" "$skills_lock"

npins -d omp/plugins/npins update --partial
