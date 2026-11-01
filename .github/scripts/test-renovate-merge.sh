#!/usr/bin/env bash
set -euo pipefail

script=$(sed -n '/^        run: |$/,$ { /^        run: |$/d; s/^          //; p; }' \
	.github/workflows/renovate-merge.yaml)
export GH_REPO=suzuuuuu09/dotfiles PR_NUMBER=123 HEAD_SHA=checked-sha

gh() {
	case "$*" in
	"api repos/$GH_REPO/branches/main/protection/required_status_checks")
		if [[ "$CHECKS" == api-error ]]; then
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

	if output=$(bash -euo pipefail -c "$script" 2>&1); then
		[[ "$expected" == merge && "$output" == *MERGE* ]]
	else
		[[ "$expected" == blocked && "$output" != *MERGE* ]]
	fi
}

check '{"strict":true,"checks":[{"context":"required-ci","app_id":15368}]}' merge
check '{"strict":true,"checks":[]}' blocked
check '{"strict":true,"checks":[{"context":"required-ci","app_id":1}]}' blocked
check '{"strict":true,"checks":[{"context":"another-check","app_id":15368}]}' blocked
check '{"strict":false,"checks":[{"context":"required-ci","app_id":15368}]}' blocked
check '{}' blocked
check api-error blocked
