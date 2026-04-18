"""システムのタイムゾーンと現在時刻を取得して表示する。"""

from datetime import datetime

local_tz = datetime.now().astimezone().tzinfo
now = datetime.now(local_tz)
print(f"System timezone : {local_tz}")
print(f"Current time    : {now.strftime('%Y-%m-%d %H:%M:%S %Z (UTC%z)')}")
