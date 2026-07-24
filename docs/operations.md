# 運用手順

この文書は、対象環境を導入し、設定変更を適用し、変更箇所を検証するための手順をまとめる。
個別アプリケーションの設定値は転記せず、変更時に参照する正本と適用経路を示す。

## 前提条件

このリポジトリは個人環境向けであり、汎用的なdotfiles templateではない。
ユーザー名、ホスト名、アプリケーションの配置先に環境固有の値が含まれる。

Home Managerのリンクはcheckout先を`~/dotfiles`として構築する。
別の場所へcloneする場合は、`dotfilesPath`を定義するNix moduleも同時に変更する必要がある。

SOPSで管理する設定を有効にする対象環境には、対応するage秘密鍵を`~/.config/sops/age/keys.txt`へ配置する。
秘密鍵はリポジトリへ追加しない。

## 初期導入

Nixでflakesを利用できる状態にしてから、固定されたパスへcloneする。

```bash
git clone https://github.com/suzuuuuu09/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix flake check
```

macOSでは、構成をbuildしてからnix-darwinで適用する。

```bash
nix build --no-link .#darwinConfigurations.suzuMac.system
sudo darwin-rebuild switch --flake .#suzuMac
```

NixOS-WSLでは、system closureをbuildしてからNixOS構成を適用する。

```bash
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#suzuWsl
```

WSLのHome Manager部分だけを評価するときは、`homeConfigurations.nixos`または`homeConfigurations."nixos@suzuWsl"`を使う。
両方の出力は同じHome Manager構成を参照する。

## 変更の適用

変更方法は、ファイルがリンク済みdotfileかNix moduleかで異なる。

| 変更対象 | 適用方法 | 直接の検証 |
| --- | --- | --- |
| リンク済みdotfile | 対象アプリケーションでreloadまたは再起動 | アプリケーション固有の構文検査または起動確認 |
| `home/common/` | 対象環境のHome Managerまたはsystemをswitch | `nix flake check`と対象構成のbuild |
| `home/darwin/`、`hosts/mac/` | `darwin-rebuild switch` | macOS systemのbuild |
| `home/wsl/`、`hosts/wsl/` | `nixos-rebuild switch` | WSL systemのbuild |
| `flake.nix`、`flake.lock`、overlays | 対象となるすべての構成をswitch | flake checksとmacOS、WSLのbuild |
| `skills/`、agent skill sources | Home Managerを含む構成をswitch | Nix評価後に`~/.agents/skills`を確認 |

out-of-store symlinkのため、リンク済みdotfileの内容はNix rebuildを待たずに参照先へ反映される。
パッケージ、リンク定義、SOPS template、agent skillsの構成を変えた場合は、Home Managerを再適用する。

## Nix依存の更新

flake inputsを更新するときは、lockfileを更新してから両方の対象環境をbuildする。

```bash
nix flake update
nix flake check
nix build --no-link .#darwinConfigurations.suzuMac.system
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
```

`flake.lock`にはNix、Home Manager、nix-darwin、NixOS-WSL、外部agent skillsなどの解決結果が含まれる。
更新後は、変更したinputに近い構成だけでなくmacOSとWSLの両方を確認する。

## Homebrewの更新

Homebrewの管理対象は`.config/nix/home/darwin/homebrew.nix`で宣言する。
activationでは自動更新とcleanupを行わない。

更新前にdry runで対象を確認する。

```bash
./scripts/homebrew-update.sh --dry-run
```

確認後、allowlistに含まれるformulaとcaskを更新する。

```bash
./scripts/homebrew-update.sh
```

`manualCasks`はスクリプトの対象外である。
自動更新するcaskを増やす場合は、`managedCasks`へ置くだけでなく`upgradableCasks`へ明示的に追加する。

## Neovim pluginの復元

Neovim pluginの解決結果は`.config/nvim/lazy-lock.json`で固定する。
CIと同じ復元手順は次のとおり。

```bash
nix shell nixpkgs#neovim nixpkgs#git -c \
  ./scripts/nvim-restore.sh ~/.config/nvim

nix shell nixpkgs#neovim nixpkgs#git -c \
  nvim --headless "+qa"
```

復元スクリプトはLazy.nvimを使ってlockfileの状態へ戻す。
pluginを更新した場合は、変更されたlockfileも差分として確認する。

## 変更領域別の検証

リポジトリ全体の既定検証は`nix flake check`で実行する。

```bash
nix flake check
```

変更範囲が限定される場合も、まず直接影響する検証を実行し、flakeまたは共通moduleを変更した場合は対象構成のbuildを追加する。

| 変更領域 | 最小の検証 |
| --- | --- |
| Nix | `nix flake check` |
| macOS system | `nix build --no-link .#darwinConfigurations.suzuMac.system` |
| NixOS-WSL | `nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel` |
| Neovim | plugin復元後に`nvim --headless "+qa"` |
| WezTerm | `.github/workflows/wezterm-linter.yaml`と同じ設定読み込み |
| Homebrew manifest | `./scripts/homebrew-update.sh --dry-run` |
| GitHub Actions | flakeの`actionlint` check |
| Python製skill scripts | flakeの`ruff` check |

`nix fmt`はファイルを書き換える。
既存の未コミット変更がある場合は、対象範囲を確認してから実行する。

## シークレット

`.config/nix/secrets/secrets.yaml`は暗号化された状態でのみ管理する。
通常の調査、レビュー、文書作成では内容を開かない。

Home ManagerはSOPSのplaceholderから`.wakatime.cfg`を生成する。
生成先のファイルとage秘密鍵はGitで管理しない。

GitHub Actionsのtokenや秘密鍵はGitHub Secretsからworkflowへ渡す。
workflow、ログ、ローカルの雛形ファイルへ秘密値を埋め込まない。

## 問題の切り分け

設定変更が反映されない場合は、最初に適用経路を確認する。

1. `readlink`で対象が`~/dotfiles`を指しているか確認する。
2. `.config/nix/home/common/dotfiles.nix`またはDarwin固有のlink定義に対象があるか確認する。
3. リンク済みdotfileなら対象アプリケーションをreloadする。
4. Nix moduleなら対象構成をbuildし、成功後にswitchする。

Nix評価に失敗する場合は、macOS用とWSL用の出力を分けてbuildする。
一方だけが失敗する場合は、`home/common/`ではなくplatformまたはhost moduleの変更を先に確認する。

Neovimが起動しない場合は、lockfileからpluginを復元してからheadless起動を実行する。
Homebrewのアプリケーションが更新されない場合は、そのアプリケーションが`manualCasks`またはallowlist外に分類されていないか確認する。

agent skillが見つからない場合は、`.config/nix/home/common/agent-skills.nix`のsourceと選択規則を確認し、Home Managerを含む構成を再適用する。
