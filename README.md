<div align="center">

# dotfiles

[![DeepWiki](https://img.shields.io/badge/DeepWiki-suzuuuuu09%2Fdotfiles-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAyCAYAAAAnWDnqAAAAAXNSR0IArs4c6QAAA05JREFUaEPtmUtyEzEQhtWTQyQLHNak2AB7ZnyXZMEjXMGeK/AIi+QuHrMnbChYY7MIh8g01fJoopFb0uhhEqqcbWTp06/uv1saEDv4O3n3dV60RfP947Mm9/SQc0ICFQgzfc4CYZoTPAswgSJCCUJUnAAoRHOAUOcATwbmVLWdGoH//PB8mnKqScAhsD0kYP3j/Yt5LPQe2KvcXmGvRHcDnpxfL2zOYJ1mFwrryWTz0advv1Ut4CJgf5uhDuDj5eUcAUoahrdY/56ebRWeraTjMt/00Sh3UDtjgHtQNHwcRGOC98BJEAEymycmYcWwOprTgcB6VZ5JK5TAJ+fXGLBm3FDAmn6oPPjR4rKCAoJCal2eAiQp2x0vxTPB3ALO2CRkwmDy5WohzBDwSEFKRwPbknEggCPB/imwrycgxX2NzoMCHhPkDwqYMr9tRcP5qNrMZHkVnOjRMWwLCcr8ohBVb1OMjxLwGCvjTikrsBOiA6fNyCrm8V1rP93iVPpwaE+gO0SsWmPiXB+jikdf6SizrT5qKasx5j8ABbHpFTx+vFXp9EnYQmLx02h1QTTrl6eDqxLnGjporxl3NL3agEvXdT0WmEost648sQOYAeJS9Q7bfUVoMGnjo4AZdUMQku50McDcMWcBPvr0SzbTAFDfvJqwLzgxwATnCgnp4wDl6Aa+Ax283gghmj+vj7feE2KBBRMW3FzOpLOADl0Isb5587h/U4gGvkt5v60Z1VLG8BhYjbzRwyQZemwAd6cCR5/XFWLYZRIMpX39AR0tjaGGiGzLVyhse5C9RKC6ai42ppWPKiBagOvaYk8lO7DajerabOZP46Lby5wKjw1HCRx7p9sVMOWGzb/vA1hwiWc6jm3MvQDTogQkiqIhJV0nBQBTU+3okKCFDy9WwferkHjtxib7t3xIUQtHxnIwtx4mpg26/HfwVNVDb4oI9RHmx5WGelRVlrtiw43zboCLaxv46AZeB3IlTkwouebTr1y2NjSpHz68WNFjHvupy3q8TFn3Hos2IAk4Ju5dCo8B3wP7VPr/FGaKiG+T+v+TQqIrOqMTL1VdWV1DdmcbO8KXBz6esmYWYKPwDL5b5FA1a0hwapHiom0r/cKaoqr+27/XcrS5UwSMbQAAAABJRU5ErkJggg==)](https://deepwiki.com/suzuuuuu09/dotfiles)
[![Build](https://github.com/suzuuuuu09/dotfiles/actions/workflows/nix-build.yaml/badge.svg)](https://github.com/suzuuuuu09/dotfiles/actions/workflows/nix-build.yaml)


</div>

macOS（Apple Silicon）とNixOS-WSL向けの個人用dotfilesです。
nix-darwinとHome Managerを中心に、アプリ設定、開発ツール、Codex向けスキルを管理しています。

## 対象

- macOS: `darwinConfigurations.suzuMac`（`aarch64-darwin`）
- NixOS-WSL: `nixosConfigurations.suzuWsl`（`x86_64-linux`）
- Home Manager: `homeConfigurations.nixos` / `homeConfigurations."nixos@suzuWsl"`

設定にはユーザー名やホスト名など、この環境固有の値が含まれます。
そのまま別環境へ適用するための汎用テンプレートではありません。

## 構成

- `flake.nix`: flake inputs、macOS / WSL構成、formatter、checks
- `.config/nix/hosts/`: ホスト固有のnix-darwin / NixOS設定
- `.config/nix/home/common/`: 共通のHome Manager設定
- `.config/nix/home/darwin/`: macOS固有のHome Manager / nix-darwin設定
- `.config/nix/home/wsl/`: WSL固有のHome Manager設定
- `.config/nix/overlays/`: ローカルパッケージのoverlay
- `.config/{fish,nvim,wezterm,...}/`: 各アプリの設定
- `codex/`: Codexの共通指示とガイド
- `skills/`: ローカルのエージェントスキル
- `scripts/`: Homebrew更新、Neovimプラグイン復元などの補助スクリプト
- `.github/`: CI、Renovate、共通Action

Home Managerのdotfilesリンクは、チェックアウト先を `~/dotfiles` として作成します。
別の場所へcloneする場合は、`.config/nix/home/common/dotfiles.nix` などの `dotfilesPath` も合わせて変更してください。

## セットアップ

Nixでflakesを利用できる状態にして、このリポジトリをcloneします。

```bash
git clone https://github.com/suzuuuuu09/dotfiles.git ~/dotfiles
cd ~/dotfiles
nix flake check
```

評価・ビルド後、対象環境で構成を適用します。

```bash
# macOS
nix build --no-link .#darwinConfigurations.suzuMac.system
sudo darwin-rebuild switch --flake .#suzuMac

# NixOS-WSL
nix build --no-link .#nixosConfigurations.suzuWsl.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#suzuWsl
```

SOPSで管理する値を有効化するには、対応するage秘密鍵を `~/.config/sops/age/keys.txt` に配置する必要があります。
`.config/nix/secrets/secrets.yaml` は暗号化された状態のまま管理してください。

## 検証

```bash
# formatter、pre-commit、Statix、deadnix、各種Lint
nix flake check

# formatterを適用
nix fmt

# macOSのシステム構成
nix build --no-link .#darwinConfigurations.suzuMac.system

# Neovimプラグインの復元と起動確認
nix shell nixpkgs#neovim nixpkgs#git -c \
  ./scripts/nvim-restore.sh ~/.config/nvim
nix shell nixpkgs#neovim nixpkgs#git -c \
  nvim --headless "+qa"

# Homebrew更新対象の確認
./scripts/homebrew-update.sh --dry-run
```

CIでは、Nix構成、Neovim、WezTerm、Renovate設定、GitHub Actionsを個別に検証します。

## 再現性に関する注意

- Nix依存は `flake.lock`、Neovimプラグインは `.config/nvim/lazy-lock.json` で固定しています。
- Homebrew cask、Masonで導入するツール、WezTermプラグインなど、一部は実行時に外部配布元へアクセスします。
- `scripts/homebrew-update.sh` はNix設定内のallowlistだけを更新し、`--dry-run` で対象を確認できます。

## シークレット

- 秘密値はSOPSで暗号化し、平文の秘密鍵やAPIトークンをcommitしないでください。
- `.config/sops/age/`、`.env`、`.env.*` はGit管理対象外です。
- GitHub Actionsの秘密値はGitHub Secretsから渡します。

## 詳細ドキュメント

- [構成と責務](docs/architecture.md)
- [アプリケーション設定と操作方針](docs/applications.md)
- [運用手順](docs/operations.md)
- [用語集](CONTEXT.md)
- [設計判断](docs/adr/)
