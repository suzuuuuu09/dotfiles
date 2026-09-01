{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cxr";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "suzuuuuu09";
    repo = "cxr";
    rev = "v${version}";
    hash = "sha256-cXlE2HmCUPaKn+wkxEdTm8WnJFy/VUXaVZ+cXZaqvHA=";
  };

  cargoHash = "sha256-kDA8093C7UevvjWP6KReY1+4o1U+/iARxcQQQTwhh0Y=";

  # Tests require lsof and multi-process operations that don't work in Nix sandbox
  doCheck = false;

  meta = {
    description = "A tool to generate a directory structure from a YAML template.";
    homepage = "https://github.com/suzuuuuu09/cxr";
    license = lib.licenses.mit;
    maintainers = [];
    mainProgram = "cxr";
    platforms = lib.platforms.unix;
  };
}
