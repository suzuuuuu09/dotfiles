#!/usr/bin/env python3
"""
fetch.py — URLからWebコンテンツを取得し、Markdownに変換するコアスクリプト

使い方:
  python fetch.py <url> [--max-length N] [--start-index N] [--raw] [--cache-dir DIR]
"""

import argparse
import hashlib
import json
import sys
import time
from pathlib import Path
from typing import Optional
from urllib.parse import urlparse

import html2text
import requests

# ── デフォルト値 ──────────────────────────────────────────────
DEFAULT_MAX_LENGTH = 5000
DEFAULT_CACHE_DIR = Path.home() / ".cache" / "fetch-skill"
DEFAULT_TIMEOUT = 15
USER_AGENT = "Mozilla/5.0 (compatible; FetchSkill/1.0; +https://github.com/fetch-skill)"


# ── HTML → Markdown 変換 ──────────────────────────────────────
def html_to_markdown(html: str, base_url: str = "") -> str:
    converter = html2text.HTML2Text()
    converter.ignore_links = False
    converter.ignore_images = False
    converter.ignore_emphasis = False
    converter.body_width = 0  # 折り返しなし
    converter.unicode_snob = True
    converter.baseurl = base_url
    converter.skip_internal_links = False
    return converter.handle(html)


# ── キャッシュ ────────────────────────────────────────────────
def cache_key(url: str) -> str:
    return hashlib.sha256(url.encode()).hexdigest()


def load_cache(url: str, cache_dir: Path) -> Optional[dict]:
    path = cache_dir / (cache_key(url) + ".json")
    if not path.exists():
        return None
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        # 24時間以内のキャッシュのみ有効
        if time.time() - data.get("timestamp", 0) < 86400:
            return data
    except Exception:
        pass
    return None


def save_cache(url: str, cache_dir: Path, result: dict):
    cache_dir.mkdir(parents=True, exist_ok=True)
    path = cache_dir / (cache_key(url) + ".json")
    result["timestamp"] = time.time()
    path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")


# ── メイン取得関数 ────────────────────────────────────────────
def fetch(
    url: str,
    max_length: int = DEFAULT_MAX_LENGTH,
    start_index: int = 0,
    raw: bool = False,
    cache_dir: Optional[Path] = DEFAULT_CACHE_DIR,
    use_cache: bool = True,
) -> dict:
    """
    URLからコンテンツを取得して返す。

    Returns:
        {
            "url": str,
            "title": str,
            "content": str,       # Markdownまたは生コンテンツのスライス
            "total_length": int,  # 変換後の全文字数
            "start_index": int,
            "end_index": int,
            "has_more": bool,
            "from_cache": bool,
        }
    """
    # バリデーション
    parsed = urlparse(url)
    if parsed.scheme not in ("http", "https"):
        return {
            "error": f"不正なURLスキーム: {parsed.scheme}。http または https を使用してください。"
        }

    # キャッシュ確認（rawモードではキャッシュしない）
    if use_cache and not raw and cache_dir:
        cached = load_cache(url, cache_dir)
        if cached:
            full_content = cached["full_content"]
            title = cached.get("title", "")
            from_cache = True
        else:
            full_content, title, from_cache = None, "", False
    else:
        full_content, title, from_cache = None, "", False

    # キャッシュがなければ取得
    if full_content is None:
        try:
            resp = requests.get(
                url,
                headers={"User-Agent": USER_AGENT},
                timeout=DEFAULT_TIMEOUT,
                allow_redirects=True,
            )
            resp.raise_for_status()
        except requests.exceptions.Timeout:
            return {
                "error": f"タイムアウト: {url} への接続が {DEFAULT_TIMEOUT}秒 で完了しませんでした。"
            }
        except requests.exceptions.ConnectionError as e:
            return {"error": f"接続エラー: {e}"}
        except requests.exceptions.HTTPError as e:
            return {"error": f"HTTPエラー {resp.status_code}: {e}"}
        except Exception as e:
            return {"error": f"予期しないエラー: {e}"}

        content_type = resp.headers.get("content-type", "")

        if raw:
            full_content = resp.text
            title = url
        else:
            if "html" in content_type:
                full_content = html_to_markdown(resp.text, base_url=url)
                # タイトル抽出（簡易）
                import re

                m = re.search(
                    r"<title[^>]*>(.*?)</title>", resp.text, re.IGNORECASE | re.DOTALL
                )
                title = m.group(1).strip() if m else ""
            else:
                # HTML以外（plain textなど）はそのまま
                full_content = resp.text
                title = url

        # キャッシュ保存
        if use_cache and not raw and cache_dir:
            save_cache(url, cache_dir, {"full_content": full_content, "title": title})

    total_length = len(full_content)
    end_index = min(start_index + max_length, total_length)
    sliced = full_content[start_index:end_index]

    return {
        "url": url,
        "title": title,
        "content": sliced,
        "total_length": total_length,
        "start_index": start_index,
        "end_index": end_index,
        "has_more": end_index < total_length,
        "from_cache": from_cache,
    }


# ── CLI ──────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(
        description="URLからコンテンツを取得してMarkdownに変換します"
    )
    parser.add_argument("url", help="取得するURL")
    parser.add_argument(
        "--max-length",
        type=int,
        default=DEFAULT_MAX_LENGTH,
        help=f"返す最大文字数 (デフォルト: {DEFAULT_MAX_LENGTH})",
    )
    parser.add_argument(
        "--start-index",
        type=int,
        default=0,
        help="開始文字インデックス (デフォルト: 0)",
    )
    parser.add_argument(
        "--raw", action="store_true", help="Markdown変換せず生コンテンツを返す"
    )
    parser.add_argument(
        "--no-cache", action="store_true", help="キャッシュを使用しない"
    )
    parser.add_argument(
        "--cache-dir",
        type=Path,
        default=DEFAULT_CACHE_DIR,
        help=f"キャッシュディレクトリ (デフォルト: {DEFAULT_CACHE_DIR})",
    )
    parser.add_argument("--json", action="store_true", help="JSON形式で出力")
    args = parser.parse_args()

    result = fetch(
        url=args.url,
        max_length=args.max_length,
        start_index=args.start_index,
        raw=args.raw,
        cache_dir=args.cache_dir if not args.no_cache else None,
        use_cache=not args.no_cache,
    )

    if args.json:
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return

    if "error" in result:
        print(f"❌ エラー: {result['error']}", file=sys.stderr)
        sys.exit(1)

    # 人間が読みやすい出力
    print(f"# {result['title'] or result['url']}")
    print(f"URL: {result['url']}")
    print(f"{'（キャッシュより）' if result['from_cache'] else ''}")
    print(
        f"文字数: {result['start_index']}〜{result['end_index']} / 全{result['total_length']}文字"
    )
    if result["has_more"]:
        print(
            f"⚠️  続きがあります。--start-index {result['end_index']} で次を取得できます。"
        )
    print("\n" + "─" * 60 + "\n")
    print(result["content"])


if __name__ == "__main__":
    main()
