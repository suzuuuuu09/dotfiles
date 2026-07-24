# Personal Environment Configuration

macOSとNixOS-WSLで使う個人用の開発環境を、一つのリポジトリから再構成し、継続的に保守するためのコンテキスト。

## Language

**対象環境（Target Environment）**：
設定を評価して適用する単位となる、OS、ホスト、ユーザーの組み合わせ。
_Avoid_: プラットフォーム、マシン

**主環境（Primary Environment）**：
日常的に使用し、設定と検証の基準にする対象環境。
_Avoid_: 補助対象環境、既定環境

**補助対象環境（Auxiliary Target Environment）**：
主環境とは別のOSで作業するときに、共通ユーザー環境を利用するための対象環境。
主環境と同じ利用頻度や将来の保守水準を意味しない。
_Avoid_: 主環境、試験環境

**共通ユーザー環境（Shared User Environment）**：
複数の対象環境で同じ振る舞いを保つ、シェル、CLI、エディタ、エージェントの設定群。
_Avoid_: 共通ホスト設定、ベースシステム

**ホスト構成（Host Configuration）**：
一つの対象環境に固有のOS設定、サービス、デバイス設定をまとめたもの。
_Avoid_: 共通設定、ユーザー環境

**設定の正本（Configuration Source of Truth）**：
実行環境へ反映される設定について、編集対象として扱う唯一の版。
_Avoid_: コピー、生成物

**リンク済みdotfile（Linked Dotfile）**：
設定の正本を保ったまま、対象アプリケーションから参照できる位置へ公開された設定。
_Avoid_: 管理対象パッケージ、生成済み設定

**管理対象アプリ（Managed Application）**：
構成の適用によって、インストール状態が自動的に調整されるアプリケーション。
_Avoid_: 手動管理アプリ、設定済みアプリ

**手動管理アプリ（Manual Application）**：
構成内に存在を記録するが、自動的なインストール、更新、削除の対象にはしないアプリケーション。
_Avoid_: 管理対象アプリ、未管理アプリ

**Agent Skill Source**：
利用するエージェントスキルを選択する元となる、外部またはローカルのスキル集合。
_Avoid_: Agent skill、エージェント設定
