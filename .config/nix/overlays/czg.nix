{
  lib,
  writeShellScriptBin,
  nodejs,
}: let
  packageName = "czg";
  version = "1.13.1";
in
  writeShellScriptBin "czg" ''
    exec ${nodejs}/bin/npx -y ${packageName}@${version} "$@"
  ''
  // {
    meta = {
      description = "Interactive Commitizen CLI that generate standardized git commit messages";
      homepage = "https://cz-git.qbb.sh/cli/";
      license = lib.licenses.mit;
      maintainers = [];
      platforms = lib.platforms.all;
      mainProgram = packageName;
    };
  }
