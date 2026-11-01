# Pin external dependencies and update them with Renovate

Pin Nix inputs in `flake.lock`, Neovim plugins in `lazy-lock.json`, and GitHub Actions by commit SHA; do not unconditionally pull the latest external versions at runtime. Updating everything manually would reduce the change rate, but dependencies would be likely to remain outdated for long periods. Therefore, Renovate proposes updates to Nix and GitHub Actions and performs lockfile maintenance. Nix dependency updates that pass verification may be merged automatically, whereas GitHub Actions updates, which change the workflows that run, are reviewed by a person and are not auto-merged.


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

Agent Sources use Renovate-managed automerge (`platformAutomerge = false`,
`ignoreTests = false`). Renovate checks the current revision's CI results before
merging on a subsequent run, including when branch protection does not require
checks. The Nix CI triggers on both lock paths. Other dependency rules and manual
update commands remain in place.

See `skills/registry/README.md` for full and individual source update commands.
