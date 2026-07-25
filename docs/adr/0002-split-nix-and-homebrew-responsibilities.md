# Separate Nix and Homebrew responsibilities

Manage CLI tools, development tools, and system configuration with Nix by default; use Homebrew only for macOS GUI applications and tools that Nix does not handle well. Divide Homebrew applications into managed and manual categories, and do not perform bulk updates or removals during activation. This preserves compatibility with macOS applications while avoiding unintended updates and removals when applying the configuration.
