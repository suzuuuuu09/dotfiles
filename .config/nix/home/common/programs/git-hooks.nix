{
  git-hooks,
  pkgs,
  src,
  treefmtEval,
}:
git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
  inherit src;

  package =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.pre-commit.overridePythonAttrs (old: {
        # shortcut: skips pre-commit's .NET hook tests on Darwin, remove when its SDK builds.
        disabledTests = (old.disabledTests or [ ]) ++ [ "test_dotnet_" ];
        env = builtins.removeAttrs (old.env or { }) [
          "DOTNET_ROOT"
          "NuGetAudit"
        ];
        nativeCheckInputs = pkgs.lib.remove pkgs.dotnetCorePackages.sdk_8_0-source (
          old.nativeCheckInputs or [ ]
        );
      })
    else
      pkgs.pre-commit;

  hooks.treefmt = {
    enable = true;
    name = "treefmt";

    # nix fmtと同じtreefmt設定を使用する
    packageOverrides.treefmt = treefmtEval.config.build.wrapper;

    # コミット対象のファイルだけをtreefmtへ渡す
    pass_filenames = true;
    stages = [ "pre-commit" ];

    settings = {
      # 整形が発生した場合はコミットを中止する
      fail-on-change = true;

      # キャッシュによる見落としを防ぐ
      no-cache = true;
    };
  };
}
