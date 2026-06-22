{
  pkgs,
  username,
  ...
}: let
  dictL = pkgs.skkDictionaries.l;
  dictProper = pkgs.skkDictionaries.propernoun;
  dictJinmei = pkgs.skkDictionaries.jinmei;
  dictEmoji = pkgs.skkDictionaries.emoji;
  dictGeo = pkgs.skkDictionaries.geo;
  macSKKDocumentsPath = "Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents";
  macSKKConfigPath = "/Users/${username}/dotfiles/.config/macSKK";
  mkInput = key: modifierFlags: optionalModifierFlags: {
    inherit key modifierFlags optionalModifierFlags;
  };
  mkBinding = action: inputs: {
    inherit action inputs;
  };
  mkDateConversion = calendar: format: locale: {
    inherit calendar format locale;
  };
  mkYomi = relative: yomi: {
    inherit relative yomi;
  };
  mkTraditionalDict = filename: encoding: {
    enabled = true;
    inherit encoding filename;
    saveToUserDict = true;
    type = "traditional";
  };
  macSKKDefaults = {
    annotationFontFamily = "";
    annotationFontSize = 14;
    candidatesFontFamily = "";
    candidatesFontSize = 14;
    dateConversions = {
      conversions = [
        (mkDateConversion "gregorian" "yyyy/MM/dd" "en_US")
        (mkDateConversion "gregorian" "yyyy-MM-dd" "en_US")
        (mkDateConversion "gregorian" "yyyy年M月d日" "en_US")
        (mkDateConversion "japanese" "Gy年M月d日" "ja_JP")
      ];
      yomis = [
        (mkYomi "now" "きょう")
        (mkYomi "yesterday" "きのう")
        (mkYomi "tomorrow" "あした")
        (mkYomi "now" "today")
        (mkYomi "yesterday" "yesterday")
        (mkYomi "tomorrow" "tomorrow")
      ];
    };
    dictionaries = [
      (mkTraditionalDict "SKK-JISYO.L" 3)
      (mkTraditionalDict "SKK-JISYO.geo" 3)
      (mkTraditionalDict "SKK-JISYO.jinmei" 3)
      (mkTraditionalDict "SKK-JISYO.propernoun" 3)
      (mkTraditionalDict "SKK-JISYO.emoji" 4)
    ];
    kanaRule = "kana-rule.conf";
    keyBindingSets = [
      {
        id = "macSKK のコピー";
        keyBindings = [
          (mkBinding "hiragana" [(mkInput "j" 262144 0)])
          (mkBinding "toggleKana" [(mkInput "q" 0 0)])
          (mkBinding "toggleAndFixKana" [(mkInput "q" 0 0)])
          (mkBinding "hankakuKana" [(mkInput "q" 262144 0)])
          (mkBinding "direct" [])
          (mkBinding "zenkaku" [])
          (mkBinding "abbrev" [(mkInput "/" 0 0)])
          (mkBinding "directAbbrev" [(mkInput ";" 262144 0)])
          (mkBinding "japanese" [(mkInput "q" 131072 0)])
          (mkBinding "stickyShift" [(mkInput ";" 0 0)])
          (mkBinding "enter" [(mkInput 36 0 655360)])
          (mkBinding "space" [(mkInput 49 0 0)])
          (mkBinding "shiftSpace" [(mkInput 49 131072 0)])
          (mkBinding "backwardCandidate" [(mkInput "x" 0 0)])
          (mkBinding "tab" [(mkInput 48 0 131072)])
          (mkBinding "backspace" [
            (mkInput 51 0 655360)
            (mkInput "h" 262144 0)
          ])
          (mkBinding "delete" [
            (mkInput 117 8388608 0)
            (mkInput "d" 262144 0)
          ])
          (mkBinding "cancel" [
            (mkInput 53 0 0)
            (mkInput "g" 262144 0)
          ])
          (mkBinding "left" [
            (mkInput 123 8388608 655360)
            (mkInput "b" 262144 0)
          ])
          (mkBinding "right" [
            (mkInput 124 8388608 655360)
            (mkInput "f" 262144 0)
          ])
          (mkBinding "down" [
            (mkInput 125 8388608 131072)
            (mkInput "n" 262144 0)
          ])
          (mkBinding "up" [
            (mkInput 126 8388608 131072)
            (mkInput "p" 262144 0)
          ])
          (mkBinding "startOfLine" [(mkInput "a" 262144 0)])
          (mkBinding "endOfLine" [(mkInput "e" 262144 0)])
          (mkBinding "unregister" [(mkInput "x" 131072 0)])
          (mkBinding "registerPaste" [(mkInput "y" 262144 0)])
          (mkBinding "reconvert" [(mkInput "/" 262144 0)])
          (mkBinding "affix" [(mkInput "." 131072 0)])
          (mkBinding "eisu" [(mkInput 102 0 0)])
          (mkBinding "kana" [(mkInput 104 0 0)])
        ];
        version = 1;
      }
    ];
    selectedKeyBindingSetId = "macSKK のコピー";
    skkserv = {
      address = "127.0.0.1";
      enableCompletion = false;
      enabled = true;
      encoding = 4;
      port = 1178;
      saveToUserDict = true;
    };
    systemDict = "com.apple.dictionary.ja.Daijirin";
    workarounds = [
      {
        bundleIdentifier = "com.vivaldi.Vivaldi";
        insertBlankString = false;
        showMarkerWhenEmpty = false;
        treatFirstCharacterAsMarkedText = false;
      }
    ];
  };
in {
  system.defaults.CustomUserPreferences = {
    "net.mtgto.inputmethod.macSKK" = macSKKDefaults;
  };

  system.activationScripts.postActivation.text = ''
    DOC_DIR="/Users/${username}/${macSKKDocumentsPath}"
    DICT_DIR="$DOC_DIR/Dictionaries"
    SETTINGS_DIR="$DOC_DIR/Settings"

    mkdir -p "$DICT_DIR"
    mkdir -p "$SETTINGS_DIR"

    cp -fv ${dictL}/share/skk/SKK-JISYO.L "$DICT_DIR/SKK-JISYO.L"
    cp -fv ${dictGeo}/share/skk/SKK-JISYO.geo "$DICT_DIR/SKK-JISYO.geo"
    cp -fv ${dictEmoji}/share/skk/SKK-JISYO.emoji "$DICT_DIR/SKK-JISYO.emoji"
    cp -fv ${dictProper}/share/skk/SKK-JISYO.propernoun "$DICT_DIR/SKK-JISYO.propernoun"
    cp -fv ${dictJinmei}/share/skk/SKK-JISYO.jinmei "$DICT_DIR/SKK-JISYO.jinmei"

    install -m 0644 \
      "${macSKKConfigPath}/Settings/kana-rule.conf" \
      "$SETTINGS_DIR/kana-rule.conf"

    chown ${username}:staff "$DICT_DIR" "$SETTINGS_DIR"
    chown ${username}:staff "$DICT_DIR"/SKK-JISYO.*
    chown ${username}:staff "$SETTINGS_DIR/kana-rule.conf"
    chmod 644 "$DICT_DIR"/SKK-JISYO.*
    chmod 644 "$SETTINGS_DIR/kana-rule.conf"
    echo "macSKK dictionaries and config setup complete!"
  '';
}
