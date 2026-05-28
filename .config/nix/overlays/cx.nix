{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cx";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "suzuuuuu09";
    repo = "cx";
    rev = "v${version}";
    hash = "sha256-G5hPiGlM8FCxTtsSpLFY7oWR9HP/Lapj6rJorhSoNus=";
  };

  cargoHash = "sha256-7OZB+XQv+vEWUpjmnR0BA7mycmDCZ4KjGu4lVrIzh4I=";

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
