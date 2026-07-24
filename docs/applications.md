# アプリケーション設定と操作方針

この文書は、各アプリケーションの設定値を転記するのではなく、現在の役割、設定の理由、適用経路を説明する。
設定の正本は、各節のリンク先にあるリポジトリ内のファイルである。

## この文書の前提

現在の主環境はmacOSである。
NixOS-WSLは、Windows側でUnityなどを使う作業時に共通ユーザー環境を利用するための補助対象環境である。
WSLをmacOSと同じ頻度や水準で保守することは、現時点で決めていない。

Home Managerは、共通設定の多くを`~/dotfiles`からout-of-store symlinkで公開する。
そのため、リンク済みdotfileを編集した内容は、Nixの再適用を待たずに対象アプリから参照できる。
インストール状態やmacOS固有の設定は、Nix、nix-darwin、Homebrewの各moduleを経由して適用する。

## 現在の位置付け

| 領域 | 現在の位置付け | 正本または適用経路 |
| --- | --- | --- |
| シェル | Fishをメインで使う。Zshは現在使っていない。 | [`config.fish`](../.config/fish/config.fish)、[`dotfiles.nix`](../.config/nix/home/common/dotfiles.nix) |
| 端末 | WezTermをメインで使う。 | [`wezterm/`](../.config/wezterm/) |
| セッション管理 | Herdrを使う。tmuxは現在使っていない。 | [`herdr/config.toml`](../.config/herdr/config.toml) |
| 端末候補 | Ghosttyは検証中である。 | [`ghostty/config`](../.config/ghostty/config) |
| エディタ | Neovimをメインとして環境変数からも指定する。 | [`nvim/`](../.config/nvim/)、[`default.nix`](../.config/nix/home/common/default.nix) |
| エディタの予備 | VS Codeはバックアップ用に設定を残しているが、現在はmacOSでもWSLでも使っていない。 | [`vscode/`](../.config/vscode/) |
| ウィンドウ管理 | AeroSpaceでmacOSのウィンドウ配置を管理する。 | [`aerospace.toml`](../.config/aerospace/aerospace.toml) |
| 日本語入力 | macSKKを中心に、azoo-key-skkserv、Karabiner、macismを組み合わせる。 | [`macskk.nix`](../.config/nix/home/darwin/macskk.nix)、[`karabiner.json`](../.config/karabiner/karabiner.json) |
| ファイル操作 | Yaziとgomiを使い、通常の削除を復元可能な操作に寄せる。 | [`yazi/`](../.config/yazi/)、[`gomi/config.yaml`](../.config/gomi/config.yaml) |
| Git操作 | ghq、rebase、delta、lazygit、czgを組み合わせる。 | [`.gitconfig`](../.gitconfig)、[`git/`](../.config/git/)、[`lazygit/`](../.config/lazygit/) |

## シェル

### Fish

FishはmacOSとWSLの共通ユーザー環境で有効にしている。
macOSのログインシェル、WezTermの起動シェル、Neovimの外部シェルをFishに揃えている。
WSLでもFishをユーザーのログインシェルとして指定している。

[`config.fish`](../.config/fish/config.fish)は、対話時の挨拶を無効にし、XDGディレクトリ、`EDITOR`、`GIT_EDITOR`、`VISUAL`を設定する。
プロンプトはFishのNordテーマを選択し、詳細な補完やパス設定は[`config/`](../.config/fish/config/)に分割している。
`fd`、`rg`、`eza`、`zoxide`、`fzf`などの代替CLIを短いaliasやabbrから呼び出す。

`rm`は`gomi`へaliasし、意図しない完全削除を避ける。
`y`関数はYazi終了時に選択したディレクトリへカレントディレクトリを移す。
`fzf`にはNordの色と、ディレクトリなら`eza`、ファイルなら`bat`を使うプレビューを設定する。

Fishをメインにする理由は、現在のmacOSで日常的に使っているシェルであるためである。
Zshとの機能互換性を維持することは、現在の運用要件に含めない。

### Zsh

ホーム直下の`.zshenv`、`.zprofile`、`.zshrc`はHome Managerからリンクされている。
一方で、`.config/zsh`自体は現在のHome Manager moduleからリンクしていない。
これは過去の設定をすぐに削除せずに残している状態であり、現在のメインシェルを意味しない。
Zshの削除や整理は、リンクされたホーム直下ファイルを含めた別の判断として扱う。

## 端末とセッション

### WezTerm

WezTermはmacOSで使うメイン端末である。
起動時のシェルをFishにし、UDEV Gothic 35NFLG、Nord、半透明表示、背景ぼかしを設定する。
タブバー、ペイン境界、ワークスペース切り替えをLuaの分割設定で管理する。

リーダーキーは`Ctrl-q`である。
リーダー後の`h/j/k/l`でペインを移動し、`r/d`で分割し、`n/w`でワークスペースを作成または選択する。
この操作体系はNeovim、AeroSpace、Yaziなどでも使うVim風の移動キーと揃えている。

### Herdr

Herdrは、エージェント、タブ、ペインをワークスペースとしてまとめて扱うために使う。
現在のセッション管理はtmuxではなくHerdrを中心にする。
エージェントパネルはスペース順に並べ、ペイン境界へのエージェントラベル表示は無効にしている。
テーマは端末テーマを使い、自動テーマ切り替えは行わない。

プレフィックスは`Ctrl-s`である。
`prefix+Shift-l`でlazygitをポップアップ表示し、`prefix+Shift-b`で現在のリポジトリをGitHubで開く。
セッションJSON、ログ、ソケットなどの実行時生成物は設定の正本ではないため、dotfilesでは管理しない。

### tmux

tmuxの設定はリポジトリに残り、Home Managerからもリンクされる。
設定上のプレフィックスは`Ctrl-a`で、ペイン移動とNordのステータスラインを定義している。
ただし、現在の日常運用ではtmuxを使わず、Herdrを使っている。
tmuxの設定は現状の実行経路ではなく、残存する設定として記録する。

### Ghostty

GhosttyはHomebrewで管理し、設定ファイルもリンクしている。
現在の`config`は空であり、アプリケーション自体を検証している段階である。
WezTermと同じ役割を持つと決めず、検証結果が出るまでは候補として扱う。

## 操作体系と見た目

### アプリ横断のキー操作

Neovim、WezTerm、Herdr、AeroSpace、Yaziでは、可能な範囲でVim風の`h/j/k/l`を移動に使う。
Caps LockはKarabiner-Elementsで左Controlへ変換する。
これにより、アプリを切り替えても同じ移動とモード切り替えの感覚を保つ。

### 配色とフォント

Nordは好みの配色であり、複数アプリの見た目を揃えるために使う。
同時に、暗色背景とNordのコントラストは日常的な読みやすさにも寄与する。
UDEV Gothicは好みのフォントであり、日本語とアイコンを含む表示の読みやすさも理由として使う。

Neovim、WezTerm、VS Code、Fish、fzf、bat、btop、Yazi、lazygit、delta、tmuxなどでNord系の設定を使う。
UDEV Gothic系のフォントはNixでインストールし、Neovim、WezTerm、VS Codeで指定する。

## ウィンドウ管理

AeroSpaceはmacOSのタイル型ウィンドウ管理を担当する。
`Alt-h/j/k/l`でフォーカスを移動し、`Alt-Shift-h/j/k/l`でウィンドウを移動する。
通常のタイル配置とアコーディオン配置を切り替え、必要なウィンドウだけをフローティングにする。

ワークスペースは、ブラウザを`B`、コミュニケーションを`C`、音楽を`M`、ノートを`N`、端末を`T`として用途の頭文字で覚える。
数字のワークスペースも残しており、用途が固定されない作業に使える。
Vivaldi、Slack、Discord、Obsidian、WezTerm、YouTube Musicは起動時に対応するワークスペースへ自動配置する。
Finder、システム設定、ブラウザのピクチャーインピクチャーはフローティングにする。

JankyBordersはAeroSpaceの起動後に開始し、現在フォーカスされているウィンドウを境界線で示す。
ワークスペース変更時にはピクチャーインピクチャー追従スクリプトを実行する。

## キーボードと日本語入力

### Karabiner-Elements

Caps Lockは左Controlへ変換する。
左Commandを単独で押すと英数、右Commandを単独で押すとかなを送信する。
Commandを長押ししたときは通常のCommandとして扱う。
リモートデスクトップアプリでは単独Commandの変換を無効にし、転送先のキーボード操作を優先する。

### macSKKとazoo-key-skkserv

macSKKを日本語入力の中心にする。
macSKKの設定はnix-darwinの`CustomUserPreferences`で宣言し、辞書とカナ入力規則はactivation時にアプリのコンテナへコピーする。
辞書には一般語、地名、人名、固有名詞、絵文字のSKK辞書を含める。
カナ入力規則の正本は[`kana-rule.conf`](../.config/macSKK/Settings/kana-rule.conf)である。

macSKKではControlを使う移動や編集のキーバインドも設定し、シェルやエディタで使う操作感と揃える。
SKKサーバーは`127.0.0.1:1178`で有効にし、azoo-key-skkservを起動時に開始する。
macSKK本体とazoo-key-skkservの起動は、macOSのユーザーlaunchdで管理する。

Neovimからはmacismを使い、Neovimがフォーカスを失ったときにmacSKKの英数入力へ戻す。
これはアプリを移動した後に日本語入力状態が残る問題を避けるためである。

## エディタと開発ツール

### Neovim

Neovimはメインエディタであり、`EDITOR`、`GIT_EDITOR`、`VISUAL`にも指定する。
設定は`config`、`plugins`、`after`、スニペットに分割し、機能ごとに遅延読み込みする。
プラグインの解決結果は[`lazy-lock.json`](../.config/nvim/lazy-lock.json)で固定し、起動時の自動更新確認は無効にする。

mapleaderはSpace、maplocalleaderは`,`である。
ウィンドウ移動には`Ctrl-h/j/k/l`を使い、削除や変更ではブラックホールレジスタを使う。
`x`系の操作はシステムクリップボードへ切り取り、通常の削除でレジスタを汚さない。
FishをNeovimの外部シェルとして使い、macSKKから英数へ戻すautocmdを持つ。

LSPと開発ツールは複数の層に分ける。
NixはmacOSとWSLで共有するCLIと基礎ツールを提供する。
lazy.nvimはNeovimプラグインを管理する。
Masonはエディタ専用のLSPやツールを実行時に導入する。
Conformは保存時のフォーマットを担当し、必要に応じてLSPのフォーマットへフォールバックする。
CopilotとSidekickもNeovimのAI機能として設定するが、利用の有無は作業ごとに選ぶ。

### VS Code

VS Codeの設定はバックアップ用にリポジトリへ残している。
現在はmacOSでもWSLでも使っていない。
設定にはUDEV Gothic、Nord系の色、Vim風の`Ctrl-h/j/k/l`、vscode-neovim連携、WindowsのGit Bash端末設定が残っている。
ただし、現在のHome Managerのdotfileリンク対象には含めていない。
再び使う場合は、設定をどの対象環境へ公開するかを先に確認する。

### ランタイムの管理

Nixの共通パッケージにはNode.js、Bun、Python、uvなどを含める。
一方、[`mise/config.toml`](../.config/mise/config.toml)ではBun、Node.js、pnpmを`latest`として管理する。
この二つが共存していることは確認できるが、役割を一つの方針へ統合する判断はまだ記録していない。
ランタイムのバージョンを固定する必要が生じた場合は、Nix、mise、Masonのどこを正本にするかを別途決める。

## 補助アプリケーション

[`nord-detailed.omp.json`](../.config/oh-my-posh/themes/nord-detailed.omp.json)はFishのプロンプトとして使い、OS、シェル、メモリ、Node.js、Python、AWS、CMakeなどの状態をNord配色で表示する。
Zshにも同じテーマ名を指定しているが、現在のメインシェルはFishである。

[`lazygit/config.yml`](../.config/lazygit/config.yml)は日本語UIとdeltaのNordページャを使い、Herdrからポップアップ起動できる。
ファイル操作画面からは`czg`と`czg ai`を呼び出してコミットメッセージ作成を補助する。
[`gh/config.yml`](../.config/gh/config.yml)はHTTPS接続と対話プロンプトを既定にし、`gh co`を`gh pr checkout`のaliasにする。
認証情報を含む`hosts.yml`は、この文書でも内容を扱わない。

[`bat/config`](../.config/bat/config)はNordのシンタックステーマを使い、[`btop/btop.conf`](../.config/btop/btop.conf)はNordテーマ、true color、透過背景を使う。
これらはターミナル上の補助表示をWezTermやNeovimの配色に揃えるための設定である。

[`cxr/img.yaml`](../.config/cxr/img.yaml)はOpenCVを使う画像処理課題のプロジェクト雛形を生成する。
[`vde/layout/config.yml`](../.config/vde/layout/config.yml)にはNeovimとtdfを横に並べるReportレイアウトを定義する。
これらは用途固有の補助ツールであり、主環境の操作体系を決める設定とは分けて扱う。

## ファイル操作

Yaziは、隠しファイルを表示し、`h/j/k/l`でディレクトリとファイルを移動するファイルマネージャーである。
プレビュー、fzf、zoxideを統合し、Fishの`y`関数から起動する。
テキストは`$EDITOR`で開き、macOS、Linux、Windowsで開く操作を分ける。

Yaziの`d`はゴミ箱へ移動し、`D`だけが完全削除を行う。
Fishの`rm`もgomiへ向けるため、通常の削除は復元可能な経路を通る。
この方針は、完全削除を明示操作に限定する安全策として採用する。

## Gitとリポジトリ操作

ghqのルートは`~/ghq`に固定し、リポジトリの取得場所を揃える。
通常のpullはrebaseを使い、rebase時にはautostashを有効にする。
差分表示はdeltaを使い、lazygitを対話的な確認と操作の入口にする。
czgとczg aiはコミットメッセージ作成を補助する。

この構成は、リポジトリの場所を統一し、履歴を直線的に保ちながら、差分確認とコミット作成を補助するためのGit作業方針である。
Gitの設定本体はホームの[`.gitconfig`](../.gitconfig)にあり、[`git/`](../.config/git/)にはattributesとignoreを置いている。
Gitの設定を変更するときは、ホームファイルとXDGディレクトリのどちらを参照する設定かを確認する。

## macOSのアプリケーション管理

macOSのGUIアプリケーションは、すべてを同じ自動化対象にはしない。
[`homebrew.nix`](../.config/nix/home/darwin/homebrew.nix)では、formulaとcaskを管理対象、手動管理、更新許可のallowlistに分ける。
activationではHomebrewの自動更新と一括削除を行わない。
手動管理のアプリを意図せず削除しないことを優先し、更新は[`homebrew-update.sh`](../scripts/homebrew-update.sh)へ分離する。

macSKK、azoo-key-skkserv、AeroSpace、WezTerm、Ghostty、Herdrなどは、macOS固有のインストール経路を持つ。
Karabiner-Elements、Vivaldi、Slack、Discord、Obsidian、VS Codeなどは、存在をmanifestに記録しつつ自動管理から外している。
この分類の背景は、NixとHomebrewの責務を分けた[ADR 0002](adr/0002-split-nix-and-homebrew-responsibilities.md)にまとめている。

Finderは隠しファイルと外付けディスクを表示し、新しいウィンドウをホームディレクトリで開く。
Dockは自動的に隠し、WezTerm、通信、ノート、ユーティリティなど日常的に使うアプリを固定する。
これらのmacOS既定値は[`system.nix`](../.config/nix/home/darwin/system.nix)で管理する。

## 設定が正本にならないファイル

リポジトリに存在することと、現在のアプリへリンクされていることは同じではない。
`.config/chezmoi`、`.config/homebrew`、`.config/macSKK`、`.config/vscode`、`.config/zsh`は、現在のHome Manager link定義やactivationの経路を確認してから編集する。
macSKKのカナ入力規則は、直接リンクするのではなく、macSKK用activationでアプリのコンテナへコピーする。
VS CodeとZshは設定が残っているが、現在の主環境で使っているアプリ設定とは扱わない。

## 変更時の確認順

まず、この文書でアプリの現在の位置付けを確認する。
次に、表に記載した正本ファイルとHome Managerまたはnix-darwinの適用経路を確認する。
リンク済みdotfileだけを変更した場合は、対象アプリのreloadまたは再起動で確認する。
Nix module、Homebrew manifest、macSKK activation、agent skillを変更した場合は、対象構成を評価してからswitchする。
未使用、検証中、バックアップ用と記載した設定を有効化するときは、現在の役割を更新してから設定を変更する。

構成全体の責務と検証範囲は[構成と責務](architecture.md)を参照する。
適用コマンドと変更領域別の検証は[運用手順](operations.md)を参照する。
