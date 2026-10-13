/** Decision records stay in session metadata, not in the model's prompt. */
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import type { ConditionReport, DecisionSource } from "./decide.ts";

export const DECISION_ENTRY_TYPE = "jev-auto-mode-decision";

export interface DecisionRecord {
  readonly tool: string;
  readonly summary: string;
  readonly reasons: readonly string[];
  readonly status: "allowed" | "blocked" | "confirmed" | "cancelled";
  readonly source: DecisionSource;
  readonly rationale: string;
  readonly conditions?: readonly ConditionReport[];
  readonly decidingRule?: string;
  readonly clearedByIntent?: readonly string[];
  readonly probabilities?: Readonly<Record<string, number>>;
  readonly model?: string;
  readonly latencyMs?: number;
  readonly timestamp: number;
}

export type DecisionRecorder = (record: DecisionRecord) => void;

/**
 * OMP does not implement upstream Pi's registerEntryRenderer.
 * Preserve the audit record without adding always-visible transcript clutter.
 */
export function createRecorder(pi: Pick<ExtensionAPI, "appendEntry">): DecisionRecorder {
  return (record) => {
    try {
      pi.appendEntry(DECISION_ENTRY_TYPE, record);
    } catch (error) {
      console.warn("[jev-auto-mode] could not record a decision:", error);
    }
  };
}
