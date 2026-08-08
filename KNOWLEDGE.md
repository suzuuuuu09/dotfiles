# Project Knowledge

このファイルには、コードや既存ドキュメントだけでは理由を追いにくく、将来の変更で再発しやすいプロジェクト固有の知識を記録する。

## Nix とターゲット環境

**共通パッケージは両ターゲットで評価できるものだけにする**
`.config/nix/home/common/` は macOS と NixOS-WSL の両方から import されるため、macOS 専用パッケージは実行時に使われる場所が macOS だけでも WSL の評価を壊すことがある。
`pngpaste` のような Darwin 専用パッケージは `.config/nix/home/darwin/` に置き、共通モジュールから移動した場合は Darwin と WSL の両方を検証する。

*Avoid*: macOS 専用プラグインが使うパッケージだから `home/common/` に置いても WSL には影響しない、と仮定する。

**新規モジュールを検証する前に Git フレーク入力への収載を確認する**
この flake の `self` は Git のソースツリーとして扱われるため、新しく作った未追跡ファイルが `nix build` から見えないことがある。
新規モジュールが「存在しない」と言われた場合は、Nix の構文や import 経路を調べる前に `git status` とファイルの追跡状態を確認する。

## 固定している外部依存

**Hunk の nixpkgs は root input と同期させない**
`hunk` は `bun2nix` と `flake-parts` の評価中に `x86_64-darwin` まで列挙するため、root の新しい nixpkgs が同アーキテクチャのサポートを削除すると、ホストが `aarch64-darwin` でも評価に失敗する。
現在は `flake.nix` の `hunk.inputs.nixpkgs` を `nixpkgs-26.05-darwin` に固定している。
Hunk または nixpkgs を更新するときは、この独立した pin を保ったまま `nix build --no-link .#darwinConfigurations.suzuMac.system` と `nix flake check` を実行する。

*Avoid*: `hunk.inputs.nixpkgs.follows = "nixpkgs"` に戻す、または専用 pin を理由の確認なしに更新する。

**Codex は `llm-agents.nix` 由来のパッケージを使う**
このリポジトリの `codex` は nixpkgs の `pkgs.codex` ではなく、`inputs.llm-agents.packages.${system}.codex` を参照する。
Codex のバージョンや配布元を更新するときは `.config/nix/home/common/programs/codex.nix` のこの参照を維持し、生成された `home.packages` で実際の derivation を確認する。

## Agent Skills と macOS activation

**`~/.agents/skills` の管理マーカーを所有権の境界として扱う**
`agent-skills-nix` は、非空の `~/.agents/skills` に `.agent-skills-managed.json` がない場合、そのディレクトリを未管理と判断して activation を停止する。
既存の内容が旧 Nix Store へのリンクであれば、削除や強制上書きの前にディレクトリ全体を日時付きの隣接パスへ退避し、通常の `darwin-rebuild switch --flake .#suzuMac` を再実行する。

*Avoid*: 内容を確認せずに `AGENT_SKILLS_FORCE=1` を恒久設定する、または旧ディレクトリを先に削除する。

**Homebrew の trust 設定は sudo activation 用の場所にも用意する**
nix-darwin の activation 中は Homebrew が sudo 経由で実行されるため、対話ユーザーの trust 設定だけでは tap や cask の検証に使われないことがある。
`.config/nix/home/darwin/homebrew.nix` では `XDG_CONFIG_HOME` を明示し、信頼する tap/cask を `/Users/<username>/.homebrew/trust.json` と `/Users/<username>/.config/homebrew/trust.json` の両方へ生成する。
新しい外部 tap の formula/cask を追加するときは、managed リストと必要な trust リストを同じ変更で更新する。
tap 全体を信頼する必要がなければ、cask 単位の trust を優先する。

*Avoid*: activation の失敗を常に `HOMEBREW_NO_REQUIRE_TAP_TRUST` で無効化して済ませる。

## フォーマッター

**TOML の整形結果は Taplo の対象範囲まで確認する**
`nix fmt` は treefmt 経由で Taplo も実行し、`.taplo.toml` の `align_entries = true` は通常の TOML エントリを整列する。
設定を追加しただけではファイルは変わらず、`keymap.toml` の inline table のように整列対象外の構文もあるため、整形後の実ファイルを確認する。

*Avoid*: formatter の設定だけを見て `=` の整列を断定する、または inline table も通常のエントリと同じように整列すると期待する。

## Fish ネイティブプロンプト

**Powerline の三角形は隣接セグメントの背景を引き継ぐ**
Oh My Posh の `leading_diamond` は、先頭では透明背景＋現在セグメントの前景、境界では直前セグメントの背景＋現在セグメントの前景で描画する。Fish版ではセグメント描画時に直前の背景色を追跡し、`` のセルへ設定する。最後の `trailing_diamond` は現在セグメントの前景＋透明背景へ戻す。
Enter の transient prompt は `\r` と `\n` の両方を専用ハンドラへ bind し、`fish_prompt` で一時描画した後 `fish_right_prompt` で状態を戻す。

*Avoid*: 三角形を前景色だけで描画して直前セグメントの背景を落とす、または Enter を `commandline -f execute` だけにして transient prompt を省略する。
