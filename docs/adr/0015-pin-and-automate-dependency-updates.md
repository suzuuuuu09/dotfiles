# Pin external dependencies and update them with Renovate

Pin Nix inputs in `flake.lock`, Neovim plugins in `lazy-lock.json`, and GitHub Actions by commit SHA; do not unconditionally pull the latest external versions at runtime. Updating everything manually would reduce the change rate, but dependencies would be likely to remain outdated for long periods. Therefore, Renovate proposes updates to Nix and GitHub Actions and performs lockfile maintenance. All Renovate PRs, including GitHub Actions updates, are eligible for automatic merging after the required checks pass.


Agent Skill Sources use the official agent-skills-nix Source Registry manifests
under `skills/registry/sources/` and `skills/registry/sources.lock.json`. OMP plugin
sources use `omp/plugins/npins/sources.json` with the generated npins importer.
These repositories no longer belong in the root flake inputs; the agent-skills-nix
library itself remains a flake input. Both locks preserve resolved revisions and
hashes, and evaluation never resolves a branch to its latest revision.

Renovate's Nix manager does not maintain these locks. Two JSONata custom managers
extract their branch references and commit digests, excluding Skill Sources with
`pin.at` and frozen npins entries. Renovate groups updates into one Agent Sources
PR. A post-upgrade script runs the official `npins update --partial` to refresh
URLs and hashes for the exact revisions Renovate selected; it never advances
branches itself. Only the two source locks are included in the generated changes.

The existing daily Renovate workflow runs Renovate, npins, and jq in one Nix shell
from the repository's pinned nixpkgs. This avoids a separate Docker environment
for post-upgrade tools. The self-hosted command allowlist permits only the source
lock refresh script. No additional GitHub App or secrets are needed.

Renovate only creates and rebases PRs (`automerge = false`). A separate
`renovate-merge.yaml` workflow enables GitHub auto-merge for same-repository PRs
from the Renovate App, using the existing App credentials so merge events still
trigger workflows. It refuses to enable auto-merge unless branch protection
matches the required contexts and App IDs declared on `main`. Keeping the merge
decision in GitHub avoids waiting for another daily Renovate run after CI
succeeds.

`pull-request.yaml` selects the relevant reusable CI workflows and always runs
`required-ci`, which fails if any selected workflow fails or is cancelled. This
avoids requiring path-filtered checks that would never appear on unrelated PRs.
`main` also requires the CodeRabbit and Socket checks, including their expected
GitHub App IDs, and requires PRs to be up to date. These requirements apply to
all PRs, including administrators; Renovate rebases outdated branches on its
next run. The Nix CI covers both source lock paths.

After these workflows are deployed to `main`, apply the reviewed protection
configuration with
`gh api --method PUT repos/suzuuuuu09/dotfiles/branches/main/protection --input .github/main-protection.json`.
Applying it before deployment would block existing PRs waiting for the new
check. Existing PRs need to be rebased after deployment so the new PR workflow
runs and reports `required-ci`.

See `skills/registry/README.md` for full and individual source update commands.

## Agreed simplification (not implemented)

The following policy choices are agreed as a design only. Implementation,
GitHub label creation, publication, and branch protection changes are explicitly
deferred. The deployed implementation remains as described above.

- The `renovate` label identifies the update source. A separate `automerge` label
  grants Auto-merge Authorization to non-draft PRs from this repository,
  regardless of author. Removing it withdraws a pending reservation, without
  reverting an already merged change. Label additions and removals must both
  be handled.
- Renovate PRs receive `automerge` automatically, including vulnerability
  updates. Use additive labeling so the security label cannot replace the
  authorization label. Existing Renovate PRs must be included in the rollout.
- `required-ci` and both Socket checks remain mandatory for all PRs. CodeRabbit
  remains available as an advisory review; merging does not wait for it.
- The merge workflow stops comparing branch protection on every PR. Protection
  is verified when its configuration is applied or changed, and GitHub enforces
  it at merge time. Remove administration-read from the merge workflow token
  and remove the policy-comparison-specific tests. This deliberately gives up
  the workflow's additional refusal to reserve a merge after an administrator
  removes protection.
- Keep strict up-to-date protection, the daily schedule and manual execution.
  Also run the existing Renovate workflow on every push to `main`, including
  dependency merges, so remaining PRs can rebase without waiting for the next
  daily run. More Renovate and follow-up CI executions are an accepted cost.

Keep the existing GitHub App authentication, same-repository scope, and
conditional CI selection. Renovate itself continues to use `automerge = false`;
GitHub performs the actual merge after the required checks pass.
