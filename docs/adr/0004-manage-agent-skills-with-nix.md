# Manage Agent Skills with Nix

Select external Agent Skill Sources and repository-local skills in a Home Manager module, then install them on macOS and WSL through the same process. Per-environment manual installation allows quick updates, but causes skill versions and local adjustments to drift between environments, so it is not the standard installation path. Pin external skill versions in `flake.lock` and manage transformations for local policy in the same module.
