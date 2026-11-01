#!/usr/bin/env bash
set -euo pipefail

script=$(sed -n '/^        run: |$/,$ { /^        run: |$/d; s/^          //; p; }' \
  .github/workflows/renovate-merge.yaml)
grep -q '^        shell: bash$' .github/workflows/renovate-merge.yaml
grep -q '^        shell: bash$' .github/workflows/pull-request.yaml
test_dir=$(mktemp -d)
trap 'rm -f -- "$test_dir/expected-protection.json"; rmdir -- "$test_dir"' EXIT
export RUNNER_TEMP="$test_dir"
export GH_REPO=suzuuuuu09/dotfiles PR_NUMBER=123 HEAD_SHA=checked-sha

gh() {
  case "$*" in
  "api repos/$GH_REPO/contents/.github/main-protection.json?ref=main --jq .content | @base64d")
    if [[ $CHECKS == config-error ]]; then
      return 1
    fi
    cat .github/main-protection.json
    ;;
  "api repos/$GH_REPO/branches/main/protection")
    if [[ $CHECKS == api-error ]]; then
      return 1
    fi
    printf '%s\n' "$CHECKS"
    ;;
  "pr merge 123 --auto --squash --match-head-commit checked-sha")
    printf 'MERGE\n'
    ;;
  *) return 1 ;;
  esac
}
export -f gh

check() {
  export CHECKS="$1"
  local expected="$2" output

  if output=$(bash -eo pipefail -c "$script" 2>&1); then
    [[ $expected == merge && $output == *MERGE* ]]
  else
    [[ $expected == blocked && $output != *MERGE* ]]
  fi
}

protection=$(jq '{enforce_admins: {enabled: .enforce_admins}, required_status_checks}' \
  .github/main-protection.json)
check "$protection" merge
for index in 0 1 2 3; do
  check "$(jq --argjson index "$index" 'del(.required_status_checks.checks[$index])' <<<"$protection")" blocked
  check "$(jq --argjson index "$index" '.required_status_checks.checks[$index].app_id = 1' <<<"$protection")" blocked
done
check "$(jq '.required_status_checks.checks[0].context = "another-check"' <<<"$protection")" blocked
check "$(jq '.required_status_checks.strict = false' <<<"$protection")" blocked
check "$(jq '.enforce_admins.enabled = false' <<<"$protection")" blocked
check '{}' blocked
check api-error blocked
check config-error blocked
