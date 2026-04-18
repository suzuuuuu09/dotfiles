---
name: timezone-utils
description: >
  現在時刻の取得とタイムゾーン変換を行うスキル。
  以下のいずれかに該当するときは必ずこのスキルを使うこと：
  - 現在時刻・今の時間を知りたい（「今何時？」「現在時刻は？」「今の時間を教えて」）
  - 特定タイムゾーンの現在時刻を取得したい（「東京の今の時刻」「NYは何時？」「UTCで今何時？」）
  - タイムゾーン間で時刻を変換したい（「JST 15:00 を UTC に変換して」「ニューヨーク時間に直して」「この時間をロンドン時間で教えて」）
  - システムのタイムゾーン確認（「サーバーのタイムゾーンは？」「ローカルのタイムゾーンを教えて」）
  - timezone-utils スキルの開発・テスト・修正・動作確認をしたい
  時刻・タイムゾーンに関する質問が来たら、説明だけせず必ずこのスキルの手順でスクリプトを実行して実際の値を取得すること。
---

# Timezone Utils スキル

現在時刻の取得と、タイムゾーン間の時刻変換を行うスキル。
Python の `datetime` / `zoneinfo`（標準ライブラリ）のみを使用するため、追加インストール不要。

スクリプトは `scripts/` ディレクトリに格納されている。実行前にスキルのパスを確認すること。

---

## スクリプト一覧

| スクリプト | 用途 |
|-----------|------|
| `scripts/get_system_time.py` | システムのタイムゾーンと現在時刻を取得 |
| `scripts/get_time_in_tz.py <TZ>` | 指定タイムゾーンの現在時刻を取得 |
| `scripts/convert_tz.py <FROM> <TO> "<DATETIME>"` | 日時をタイムゾーン間で変換 |

---

## 実行方法

スキルのパスを `SKILL_DIR` に設定してから実行する。
インストール済み環境では `/mnt/skills/user/timezone-utils`、
開発中は `/home/claude/timezone-utils` など実際のパスに合わせること。

### 1. システムのタイムゾーンと現在時刻を取得する

```bash
SKILL_DIR=/mnt/skills/user/timezone-utils
python3 "$SKILL_DIR/scripts/get_system_time.py"
```

出力例：
```
System timezone : Asia/Tokyo
Current time    : 2026-04-18 12:39:13 JST (UTC+0900)
```

---

### 2. 指定タイムゾーンの現在時刻を取得する

```bash
SKILL_DIR=/mnt/skills/user/timezone-utils
python3 "$SKILL_DIR/scripts/get_time_in_tz.py" "Asia/Tokyo"
```

出力例：
```
Timezone : Asia/Tokyo
Now      : 2026-04-18 12:39:13 JST (UTC+0900)
```

---

### 3. タイムゾーンを変換する

```bash
SKILL_DIR=/mnt/skills/user/timezone-utils
python3 "$SKILL_DIR/scripts/convert_tz.py" "Asia/Tokyo" "America/New_York" "2026-04-18 15:30"
```

出力例：
```
FROM : 2026-04-18 15:30:00 JST (UTC+0900)
TO   : 2026-04-18 02:30:00 EDT (UTC-0400)
```

---

## よく使うタイムゾーン名

| 地域 | IANA 名 |
|------|---------|
| 日本（JST） | `Asia/Tokyo` |
| UTC | `UTC` |
| 米国東部（ET） | `America/New_York` |
| 米国西部（PT） | `America/Los_Angeles` |
| 英国（GMT/BST） | `Europe/London` |
| 中央ヨーロッパ（CET） | `Europe/Paris` |
| インド（IST） | `Asia/Kolkata` |
| 中国（CST） | `Asia/Shanghai` |
| オーストラリア東部 | `Australia/Sydney` |

---

## ユーザー入力のパターン対応

| ユーザーの表現 | 使うスクリプト |
|---------------|---------------|
| 「今何時？」 | `get_system_time.py` |
| 「東京は今何時？」 | `get_time_in_tz.py Asia/Tokyo` |
| 「JST の 15:00 を UTC に変換して」 | `convert_tz.py`（日付は本日） |
| 「14:30 NY 時間をロンドンに変換」 | `convert_tz.py America/New_York Europe/London` |
| タイムゾーン名が略称の場合 | 上のテーブルで IANA 名に変換してから使用 |

日付が明示されていない場合はセクション 1 で取得した今日の日付を使うこと。

---

## エラー対処

- `ZoneInfoNotFoundError` → タイムゾーン名が正しいか確認（大文字小文字に注意）
- Python 3.9 未満 → `zoneinfo` が使えないため `python3 -c "import datetime; print(datetime.datetime.utcnow())"` で UTC を取得
- スクリプトが見つからない → `SKILL_DIR` のパスが正しいか確認する
