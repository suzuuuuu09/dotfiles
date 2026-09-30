# Separate Google authentication from environment configuration

Nix manages OMP and non-secret integration configuration, while an external OAuth provider manages Google authorization without a user-maintained Google OAuth client. OMP may retain its credentials for that provider outside dotfiles and the Nix store; account connections are reauthorized separately when needed on a new target environment. This preserves reproducible configuration without making authentication state part of environment reconstruction; write access is adopted only when explicit account selection is mechanically required, rather than relying solely on agent instructions.

If Composio is adopted, its API key may be stored in the repository only as SOPS-encrypted data and read from a decrypted runtime secret file. This exception does not permit storing Google OAuth tokens or embedding decrypted credentials in the Nix store. For shared Connect MCP, the consumer key is distinct from a developer project API key.
