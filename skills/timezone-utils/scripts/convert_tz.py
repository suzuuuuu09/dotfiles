"""タイムゾーン間で日時を変換して表示する。
Usage: python3 convert_tz.py <FROM_TZ> <TO_TZ> <DATETIME>
        DATETIME 形式: "YYYY-MM-DD HH:MM" または "YYYY-MM-DD HH:MM:SS"
Example: python3 convert_tz.py Asia/Tokyo America/New_York "2026-04-18 15:30"
"""

import datetime
import sys
import zoneinfo

if len(sys.argv) < 4:
    print("Usage: python3 convert_tz.py <FROM_TZ> <TO_TZ> <DATETIME>", file=sys.stderr)
    print(
        'Example: python3 convert_tz.py Asia/Tokyo America/New_York "2026-04-18 15:30"',
        file=sys.stderr,
    )
    sys.exit(1)

from_tz_name = sys.argv[1]
to_tz_name = sys.argv[2]
dt_str = sys.argv[3]

# タイムゾーン解決
for tz_name in (from_tz_name, to_tz_name):
    try:
        zoneinfo.ZoneInfo(tz_name)
    except zoneinfo.ZoneInfoNotFoundError:
        print(f"Error: Unknown timezone '{tz_name}'", file=sys.stderr)
        sys.exit(1)

# 日時パース（秒なしも許容）
for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M"):
    try:
        naive_dt = datetime.datetime.strptime(dt_str, fmt)
        break
    except ValueError:
        pass
else:
    print(f"Error: Cannot parse datetime '{dt_str}'", file=sys.stderr)
    print("Expected format: YYYY-MM-DD HH:MM  or  YYYY-MM-DD HH:MM:SS", file=sys.stderr)
    sys.exit(1)

from_tz = zoneinfo.ZoneInfo(from_tz_name)
to_tz = zoneinfo.ZoneInfo(to_tz_name)

dt_from = naive_dt.replace(tzinfo=from_tz)
dt_to = dt_from.astimezone(to_tz)

print(f"FROM : {dt_from.strftime('%Y-%m-%d %H:%M:%S %Z (UTC%z)')}")
print(f"TO   : {dt_to.strftime('%Y-%m-%d %H:%M:%S %Z (UTC%z)')}")
