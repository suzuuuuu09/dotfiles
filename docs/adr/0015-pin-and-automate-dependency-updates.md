# Pin external dependencies and update them with Renovate

Pin Nix inputs in `flake.lock`, Neovim plugins in `lazy-lock.json`, and GitHub Actions by commit SHA; do not unconditionally pull the latest external versions at runtime. Updating everything manually would reduce the change rate, but dependencies would be likely to remain outdated for long periods. Therefore, Renovate proposes updates to Nix and GitHub Actions and performs lockfile maintenance. Nix dependency updates that pass verification may be merged automatically, whereas GitHub Actions updates, which change the workflows that run, are reviewed by a person and are not auto-merged.


Agent Skill Sources use the official agent-skills-nix Source Registry manifests
under `skills/registry/sources/` and `skills/registry/sources.lock.json`. OMP plugin
sources use `omp/plugins/npins/sources.json` with the generated npins importer.
These repositories no longer belong in the root flake inputs; the agent-skills-nix
library itself remains a flake input. Both locks preserve resolved revisions and
hashes, and evaluation never resolves a branch to its latest revision.

Renovate's Nix manager does not maintain these locks. The Agent Sources workflow
updates them daily and on manual dispatch, using the existing Renovate GitHub App
to create an update PR that triggers CI. It merges only after CI: Nix Build passes
for that exact head commit; a later head commit cannot be merged by an older run.
This explicit CI gate is needed even without required branch checks. Commit-pinned
Skill Sources retain `pin.at` in their manifests and stay fixed during updates.
Renovate continues to update flake inputs and SHA-pinned workflow actions.

See `skills/registry/README.md` for full and individual source update commands.
