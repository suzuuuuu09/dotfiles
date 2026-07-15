# AI Decision System Brief

Use this six-block format for focused decision and pilot guidance. Keep the brief roughly 900 words or less unless a critical safeguard needs more space. Do not add sections merely because more fields could be discussed.

Use exact numbers, durations, sample sizes, named owners, and legal requirements only when supplied or supported by evidence. Otherwise state the selection rule and accountable role type. Prefer `Unknown — <evidence or decision needed>` over speculative precision.

## 1. Recommendation and Risk

- **Recommended next step — Proposed:**
- **Largest unresolved risk — Unknown:**

## 2. Decision Boundary

Write one decision statement containing:

- decision unit and time;
- eligible and prohibited actions;
- objective and outcome horizon;
- current baseline;
- hard constraints;
- AI role, human authority, affected people, fallback, and reversibility.

## 3. Evaluation Contract

Use one compact table.

| Role | Measure | Promotion, non-inferiority, or stop rule |
| --- | --- | --- |
| Primary outcome |  |  |
| Quality guardrail |  |  |
| Harm guardrail |  |  |
| Operational guardrail |  |  |
| Distributional guardrail |  |  |

Name metric-gaming risks only when they change a guardrail or method.

## 4. Evidence and Methods

- **Observed:** available evidence and its coverage.
- **Estimated:** only estimates supported by stated assumptions.
- **Unknown:** missing evidence that changes method choice or risk.
- **Proposed methods:** the weakest evaluation steps that answer the current uncertainty; state why stronger causal methods are or are not supported.

## 5. Safeguards and Rollout

Cover only safeguards material to the current risk:

- data minimization, access, retention, and sensitive-data controls;
- human review, appeal or recourse, abstention, and fallback;
- shadow mode or pilot scope, promotion and stop conditions, and rollback;
- responsible role types for incidents, operations, and residual-risk acceptance.

For staged work, use at most four stages: offline, shadow, pilot, and expansion.

## 6. Blocking Unknowns and Next Decisions

- **Blocking unknowns:** only items that prevent the next stage or could change the risk posture.
- **Next decisions:** action, accountable role type, and evidence required.

## Evidence Labels

- **Observed:** directly measured or explicitly documented.
- **Estimated:** inferred under stated assumptions.
- **Proposed:** recommended design choice.
- **Unknown:** evidence not yet available.

For a comprehensive design or audit, retain these six blocks and expand only the relevant details from [evaluation-playbook.md](evaluation-playbook.md).
