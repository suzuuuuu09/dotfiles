"""指定したタイムゾーンの現在時刻を表示する。
Usage: python3 get_time_in_tz.py <IANA_TZ_NAME>
Example: python3 get_time_in_tz.py Asia/Tokyo
"""

import sys
import zoneinfo
from datetime import datetime

if len(sys.argv) != 2:
    print("Usage: python3 get_time_in_tz.py <IANA_TZ_NAME>")
    print("Example: python3 get_time_in_tz.py Asia/Tokyo")
    sys.exit(1)

tz_name = sys.argv[1]
try:
    tz = zoneinfo.ZoneInfo(tz_name)
except zoneinfo.ZoneInfoNotFoundError:
    print(f"Error: Timezone '{tz_name}' not found.", file=sys.stderr)
    print(
        "Use IANA timezone names, e.g. Asia/Tokyo, America/New_York, Europe/London.",
        file=sys.stderr,
    )
    sys.exit(1)

now = datetime.now(tz)
print(f"Timezone : {tz_name}")
print(f"Now      : {now.strftime('%Y-%m-%d %H:%M:%S %Z (UTC%z)')}")
