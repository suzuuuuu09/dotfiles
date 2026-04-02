{
  config,
  pkgs,
  ...
}: let
  dictL = pkgs.skkDictionaries.l;
  dictProper = pkgs.skkDictionaries.propernoun;
  dictJinmei = pkgs.skkDictionaries.jinmei;
  dictEmoji = pkgs.skkDictionaries.emoji;
  dictGeo = pkgs.skkDictionaries.geo;
  macSKKPath = "Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents";
in {
  system.activationScripts.postActivation.text = ''
    DICT_DIR="/Users/k25012kk/${macSKKPath}/Dictionaries"
    mkdir -p "$DICT_DIR"
    cp -fv ${dictL}/share/skk/SKK-JISYO.L "$DICT_DIR/SKK-JISYO.L"
    cp -fv ${dictGeo}/share/skk/SKK-JISYO.geo "$DICT_DIR/SKK-JISYO.geo"
    cp -fv ${dictEmoji}/share/skk/SKK-JISYO.emoji "$DICT_DIR/SKK-JISYO.emoji"
    cp -fv ${dictProper}/share/skk/SKK-JISYO.propernoun "$DICT_DIR/SKK-JISYO.propernoun"
    cp -fv ${dictJinmei}/share/skk/SKK-JISYO.jinmei "$DICT_DIR/SKK-JISYO.jinmei"
    chown -R k25012kk:staff "$DICT_DIR"
    chmod 644 "$DICT_DIR"/SKK-JISYO.*
    echo "macSKK dictionaries setup complete!"
  '';

  # ${macSKKPath}/Settingsに~/dotfiles/.config/macSKK/Settingsをシンボリックリンクで配置
}
