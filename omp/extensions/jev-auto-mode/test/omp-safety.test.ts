import { test } from "node:test";
import assert from "node:assert/strict";

import { DEFAULT_SETTINGS } from "../src/settings.ts";
import { buildConfirmationDialog } from "../src/ui.ts";
import { hardDenyReasons, protectedPathReason, isReadOnlyCommandChain } from "../src/policy.ts";

test("uncertain calls require user confirmation by default", () => {
  assert.equal(DEFAULT_SETTINGS.uncertain, "ask");
  assert.equal(DEFAULT_SETTINGS.gateScope, "all");
});

test("destructive home deletion never reaches Jev", () => {
  assert.ok(hardDenyReasons("rm -rf ~/").length > 0);
});

test("OMP extension files are protected", () => {
  assert.ok(protectedPathReason("/home/suzu/.omp/agent/extensions/test.ts"));
});

test("read-only command chains use the fast path", () => {
  assert.equal(isReadOnlyCommandChain("git status && rg foo src"), true);
  assert.equal(isReadOnlyCommandChain("git status && rm -rf build"), false);
});

test("confirmation dialogs show only the essentials", () => {
  const dialog = buildConfirmationDialog({
    tool: "bash",
    command: "rm -rf build",
    reasons: ["recursive delete"],
    rationale: "Long model rationale should not appear in the short prompt",
  });
  assert.match(dialog, /Confirm: bash/);
  assert.match(dialog, /rm -rf build/);
  assert.match(dialog, /recursive delete/);
  assert.doesNotMatch(dialog, /Long model rationale/);
  assert.ok(dialog.split("\n").length <= 3);
});
