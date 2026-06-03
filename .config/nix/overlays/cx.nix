{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cx";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "suzuuuuu09";
    repo = "cx";
    rev = "v${version}";
    hash = "sha256-Yi9PFk6t9RTvfPg9ZrZQBMgUb8McF6wpc86I04Rbd0U=";
  };

  cargoHash = "sha256-Zn2FnxpizmueQgBAC4vE7OSufmlFotMkAX8cNMwOdmo=";

  # Tests require lsof and multi-process operations that don't work in Nix sandbox
  doCheck = false;

  meta = {
    description = "A tool to generate a directory structure from a TOML template.";
    homepage = "https://github.com/suzuuuuu09/cx";
    license = lib.licenses.mit;
    maintainers = [];
    mainProgram = "cx";
    platforms = lib.platforms.unix;
  };
}
