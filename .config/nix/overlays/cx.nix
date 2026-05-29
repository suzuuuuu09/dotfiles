{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cx";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "suzuuuuu09";
    repo = "cx";
    rev = "v${version}";
    hash = "sha256-IvRaGL6tOcofvfODYNmGd0xgKLq50dx7Xdkd7e3ngGI=";
  };

  cargoHash = "sha256-gj6zjU3UTS0L5Yz6MFymU6SMw3ZfdJcTEZ0NZrC+YCM=";

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
