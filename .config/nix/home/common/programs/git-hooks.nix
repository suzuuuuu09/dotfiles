{
  git-hooks,
  pkgs,
  src,
  treefmtEval,
}:
git-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
  inherit src;

  hooks.treefmt = {
    enable = true;
    name = "treefmt";

    # nix fmtと同じtreefmt設定を使用する
    packageOverrides.treefmt = treefmtEval.config.build.wrapper;

    # コミット対象のファイルだけをtreefmtへ渡す
    pass_filenames = true;
    stages = ["pre-commit"];

    settings = {
      # 整形が発生した場合はコミットを中止する
      fail-on-change = true;

      # キャッシュによる見落としを防ぐ
      no-cache = true;
    };
  };
}
