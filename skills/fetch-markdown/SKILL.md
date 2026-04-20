---
name: fetch-markdown
description: >
  WebページのURLからコンテンツを取得し、HTMLをMarkdown形式に変換して処理するスキル。
  ユーザーがURLの内容を読みたい・要約したい・抽出したい場合、またはWebページのテキストを
  利用・分析したい場合に必ず使用してください。「このURLを見て」「このページの内容を教えて」
  「URLからデータを取得して」「Webページをスクレイピングして」「このリンクを開いて」など
  URLに関する操作が含まれるときは積極的にこのスキルを参照してください。
  HTMLのパース、Markdownへの変換、長いページの部分取得（ページング）にも対応しています。
---

# Fetch スキル

WebページのURLからコンテンツを取得し、HTMLをMarkdownに変換して扱いやすい形式で提供します。

## ツール仕様

`web_fetch` ツール（または同等の fetch ツール）を使用します。

### パラメータ

| パラメータ | 型 | 必須 | デフォルト | 説明 |
|---|---|---|---|---|
| `url` | string | ✅ | — | 取得するURL（httpまたはhttps） |
| `max_length` | integer | ❌ | 5000 | 返す最大文字数 |
| `start_index` | integer | ❌ | 0 | 開始文字インデックス（ページング用） |
| `raw` | boolean | ❌ | false | trueの場合、Markdown変換せず生コンテンツを返す |

## 基本的な使い方

### 1. 通常のページ取得

```
url: "https://example.com"
```

HTMLを自動的にMarkdownへ変換して返します。見出し・リスト・リンクなどの構造が保持されます。

### 2. 文字数を制限して取得

```
url: "https://example.com/long-article"
max_length: 2000
```

大きなページの要約や冒頭部分だけが必要なときに使います。

### 3. ページング（続きを取得）

前回の取得で `max_length` に達した場合、次の部分を取得できます:

```
url: "https://example.com/long-article"
start_index: 5000
max_length: 5000
```

### 4. 生のHTMLを取得

```
url: "https://example.com"
raw: true
```

Markdown変換せず、生のHTML/テキストをそのまま返します。HTMLの構造自体を解析したい場合に使用します。

## スクリプト

### `scripts/fetch.py` — コア取得スクリプト

単一のURLを取得してMarkdownに変換します。キャッシュ機能付き。

```bash
# 基本取得
python scripts/fetch.py https://example.com

# 文字数制限 + JSON出力
python scripts/fetch.py https://example.com --max-length 2000 --json

# 続きを取得（ページング）
python scripts/fetch.py https://example.com --start-index 5000

# 生HTMLを取得
python scripts/fetch.py https://example.com --raw

# キャッシュ無効化
python scripts/fetch.py https://example.com --no-cache
```

返り値（JSON）:
```json
{
  "url": "https://example.com",
  "title": "ページタイトル",
  "content": "Markdown形式のコンテンツ（スライス済み）",
  "total_length": 12345,
  "start_index": 0,
  "end_index": 5000,
  "has_more": true,
  "from_cache": false
}
```

### `scripts/fetch_all.py` — 全文自動取得スクリプト

ページングを自動化し、長いページを全文取得します。

```bash
# 全文取得
python scripts/fetch_all.py https://example.com

# チャンクサイズと上限を指定
python scripts/fetch_all.py https://example.com --chunk-size 3000 --max-total 30000

# Markdownファイルに保存
python scripts/fetch_all.py https://example.com --output article.md

# JSONファイルに保存
python scripts/fetch_all.py https://example.com --output result.json
```

### キャッシュについて

- デフォルトで `~/.cache/fetch-skill/` にキャッシュを保存
- キャッシュ有効期間: 24時間
- `--no-cache` フラグで無効化可能
- rawモードではキャッシュしない

## ワークフロー

### ユーザーがURLの内容を求めている場合

1. `web_fetch` でURLを取得する
2. 返ってきたMarkdownコンテンツを読む
3. ユーザーの質問・目的に応じて要約・抽出・回答する

### コンテンツが長い場合

1. 最初のリクエストで `max_length: 5000`（デフォルト）で取得
2. レスポンスが `max_length` 文字に達している場合、続きがある可能性がある
3. `start_index` を前回の終端に設定して追加取得
4. 必要な情報が揃うまで繰り返す

### URLが複数ある場合

複数のURLを順次取得し、内容を比較・統合することができます。

## 注意事項

- **認証が必要なページ**（ログイン必須など）はコンテンツを取得できません
- **JavaScriptで動的に生成されるコンテンツ**は取得できない場合があります
- **robots.txtで制限されているページ**はアクセスできない場合があります
- PDFや画像などのバイナリファイルは `raw: false` のMarkdown変換の対象外です

## 出力形式

取得成功時は以下の情報が返ります：
- ページタイトル（あれば）
- Markdown形式に変換されたテキストコンテンツ
- リンク・見出し・リストなどの構造情報

取得失敗時はエラーメッセージが返ります（404、タイムアウト、接続拒否など）。

## 使用例

**ユーザー:** 「https://docs.python.org/3/library/os.html の内容を教えて」

**Claudeの動作:**
1. `web_fetch(url="https://docs.python.org/3/library/os.html", max_length=5000)` を実行
2. 返ってきたMarkdownを解析
3. `os` モジュールの概要をユーザーに説明

---

**ユーザー:** 「このニュース記事を要約して: https://example-news.com/article/123」

**Claudeの動作:**
1. `web_fetch(url="https://example-news.com/article/123")` を実行
2. 記事全文（必要なら複数回取得）を読む
3. 記事の要点をまとめてユーザーに提示
