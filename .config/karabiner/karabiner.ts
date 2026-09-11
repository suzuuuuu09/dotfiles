import { fileURLToPath } from "node:url";
import {
  ifApp,
  layer,
  map,
  rule,
  writeToProfile,
} from "karabiner.ts";

const karabinerJsonPath = fileURLToPath(
  new URL("./karabiner.json", import.meta.url),
);

const remoteDesktopApps = [
  /^com\.2X\.Client\.Mac$/,
  /^com\.microsoft\.rdc\.macos$/,
];

const rdpInputSourceRule = rule(
  "[RDP] RDPアプリ以外では、コマンドキーを単体で押したときに、英数・かなキーを送信する。（左コマンドキーは英数、右コマンドキーはかな） (rev 3)",
  ifApp({ bundle_identifiers: remoteDesktopApps }).unless(),
).manipulators([
  map("left_command", "optionalAny")
    .to({ key_code: "left_command", lazy: true })
    .toIfAlone("japanese_eisuu")
    .toIfHeldDown("left_command")
    .parameters({
      "basic.to_if_held_down_threshold_milliseconds": 100,
    }),
  map("right_command", "optionalAny")
    .to({ key_code: "right_command", lazy: true })
    .toIfAlone("japanese_kana")
    .toIfHeldDown("right_command")
    .parameters({
      "basic.to_if_held_down_threshold_milliseconds": 100,
    }),
]);

const capsLockNavigation = layer("caps_lock", "caps_lock-navigation").manipulators([
  map("h").to("←"),
  map("j").to("↓"),
  map("k").to("↑"),
  map("l").to("→"),
]);

writeToProfile(
  { name: "Default profile", karabinerJsonPath },
  [capsLockNavigation, rdpInputSourceRule],
);
