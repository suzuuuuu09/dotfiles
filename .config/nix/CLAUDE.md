# Copilot Instructions for dotfiles

This is a personal macOS dotfiles repository using Nix, nix-darwin, and home-manager to manage system and user configuration.

## Build & Deployment Commands

### Applying Configuration Changes

```bash
# Build and apply the full system configuration
darwin-rebuild switch --flake ~/.config/nix#suzuMac

# Or use the shorthand (if nix is in PATH)
nix run nixpkgs#darwin-rebuild -- switch --flake ~/.config/nix#suzuMac
```

The flake.nix is located at `.config/nix/flake.nix` (not at the repo root). All Nix builds are run from that directory.

### Linting & Validation

```bash
# Lint Nix files (if available)
nix flake check ~/.config/nix

# Format Nix files
nix fmt ~/.config/nix
```

**Note:** The repository uses commitlint with a Japanese prompt interface. Commits follow conventional commit format with emoji prefixes (✨ for features, ⚡️ for perf, 🐛 for bugs, etc.).

## High-Level Architecture

### Directory Structure

- **`.config/nix/`** - Main Nix configuration root
  - `flake.nix` - Flake configuration with inputs and outputs
  - `flake.lock` - Locked dependency versions
  - `nix.conf` - Nix configuration (enables flakes and nix-command)
  - `darwin/` - nix-darwin system-level configuration (Dock, trackpad, Spotlight, Nix store optimization)
  - `home-manager/` - User-level configuration and dotfile management
  - `overlays/` - Custom Nix package overlays
  - `secrets/` - Encrypted secrets managed by sops-nix

- **`home-manager/`** - home-manager modules (imported by flake.nix)
  - `default.nix` - Main entry point; imports all submodules
  - `dotfiles.nix` - Symlinks dotfiles from repo into user directory (~/.config, ~/)
  - `packages.nix` - Package declarations
  - `agent-skills.nix` - AI agent skill configuration (agent-skills-nix)
  - `sops.nix` - Secrets management configuration

- **`skills/`** - Custom AI agent skills (integrated via agent-skills-nix)
  - Each skill folder contains its own SKILL.md documentation
  - Skills are installed to `~/.agents/skills/` during `darwin-rebuild switch`
  - New skills must be git-tracked (use `git add`) before they appear in the build

### Key Concepts

1. **Flake Inputs & Outputs**
   - Uses nixpkgs-unstable, nix-darwin, home-manager, and optional third-party integrations (nix-homebrew, sops-nix)
   - Outputs a single Darwin configuration named "suzuMac" for Apple Silicon (aarch64-darwin)
   - home-manager is integrated as a Darwin module

2. **home-manager Configuration**
   - Manages both system packages and user dotfiles
   - Dotfiles are symlinked from the repo using `mkOutOfStoreSymlink` in `dotfiles.nix`
   - `.config/nix` itself is symlinked, allowing in-repo edits to be immediately reflected
   - `useGlobalPkgs = true` prevents duplicate package installations

3. **Secrets Management**
   - Encrypted with sops-nix (YAML files encrypted with age keys)
   - Age key stored at `.config/sops/age/key.txt` (git-ignored)
   - Configuration in `.sops.yaml` at repo root defines which files are encrypted

4. **Agent Skills Integration**
   - Uses `agent-skills-nix` module to install and manage AI agent skills
   - Aggregates skills from multiple sources (flake inputs: Vercel, Anthropic, personal)
   - Skills are symlinked to `~/.agents/skills/` after `darwin-rebuild switch`
   - Custom skills in `./skills/` are loaded as `local-skills` input
   - **Critical**: New skill folders must be git-tracked before they work; git add them first

## Key Conventions

### Nix Code Style

- Use comment boxes with `+--` and `|` for section headers (visible throughout config)
- Organize complex modules with clear comment sections
- Use `let...in` for intermediate values; use `${...}` for string interpolation
- Japanese comments are used for documentation throughout the config

### Configuration Practices

1. **Symlink Philosophy**: Use `mkOutOfStoreSymlink` to link directly to repo files, not copies. This allows editing dotfiles in-repo and seeing changes immediately.

2. **Module Imports**: Modular Nix is organized via explicit `imports = [...]` lists, not auto-discovery.

3. **Experimental Features**: Nix flakes and nix-command are enabled in `nix.conf` and required for all builds.

4. **Path References**: In Nix, use relative paths (e.g., `../secrets/secrets.yaml`) for sops defaultSopsFile, not runtime path expansion like `${config.home.homeDirectory}/...`.

5. **Git Tracking for Dynamic Content**: Nix only copies git-tracked files into the Nix store. New custom skills and overlays must be `git add`'ed before `darwin-rebuild switch` recognizes them.

### Commit Conventions

- Use the interactive commitlint prompt (triggers with `git commit`)
- Include emoji prefix based on change type (see commitlint.config.cjs)
- Scope is optional; subject should be imperative form in English
- Breaking changes and related issues go in footer

## Integration with Tools

- **sops-nix** - Encrypts sensitive config files; keys at `.config/sops/age/key.txt`
- **nix-homebrew** - Manages Homebrew packages and casks declaratively
- **Agent Skills** - AI agent integrations for Vercel, Anthropic, and custom agents
- **Karabiner** - Keyboard customization; automatic backups git-ignored
- **Oh My Posh** - Prompt themes; symlinked from repo
