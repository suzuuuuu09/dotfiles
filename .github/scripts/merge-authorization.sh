#!/usr/bin/env bash
set -euo pipefail

if ! jq -e '
  (.action == "unlabeled" and .label.name == "automerge") or
  any(.pull_request.labels[]?; .name == "automerge")
' "$GITHUB_EVENT_PATH" >/dev/null; then
  exit 0
fi

number=$(jq -er '.number | select(type == "number" and . > 0 and floor == .)' "$GITHUB_EVENT_PATH")
pull_request=$(gh api "repos/$GH_REPO/pulls/$number")
jq -e '
  (.labels | type == "array") and
  all(.labels[]; (.name | type) == "string") and
  (.draft | type == "boolean") and
  has("auto_merge") and
  (.auto_merge == null or (.auto_merge | type) == "object")
' <<<"$pull_request" >/dev/null

if ! jq -e --arg repo "$GH_REPO" \
  '.state == "open" and .base.ref == "main" and .head.repo.full_name == $repo' \
  <<<"$pull_request" >/dev/null; then
  exit 0
fi

if ! jq -e '[.labels[].name] | index("automerge") != null' <<<"$pull_request" >/dev/null; then
  if jq -e '.auto_merge != null' <<<"$pull_request" >/dev/null; then
    gh pr merge "$number" --disable-auto
  fi
  exit 0
fi

if jq -e '.draft or .auto_merge != null' <<<"$pull_request" >/dev/null; then
  exit 0
fi

head_sha=$(jq -er '.head.sha' <<<"$pull_request")

gh pr merge "$number" --auto --squash --match-head-commit "$head_sha"
