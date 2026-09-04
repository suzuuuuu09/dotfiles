{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-commitlint";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "quinnjr";
    repo = "cargo-commitlint";
    rev = "v${version}";
    hash = "sha256-43zghb8Fbs9jJXDVgyvY8fNKJGmvDSpsAPpR9E5xXEc=";
  };

  cargoHash = "sha256-vq6RB1XdLlgU1dEsjM9Qr3+ofivNOjkcHsVC8oI9YBk=";

  meta = {
    description = "Rust-based Conventional Commits message linter";
    homepage = "https://github.com/quinnjr/cargo-commitlint";
    license = lib.licenses.mit;
    maintainers = [];
    mainProgram = "cargo-commitlint";
    platforms = lib.platforms.unix;
  };
}
