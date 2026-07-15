---
name: design-safe-ai-decisions
description: Design and review AI-enabled decision systems by defining the decision boundary, evaluation metrics, evidence, operational constraints, ethical safeguards, logging, staged rollout, stopping rules, and monitoring. Use when a user wants to turn an AI use case into an evaluable system; choose metrics or evaluation methods; assess recommendations, rankings, allocations, classifications, or tool actions; plan a pilot or rollout; audit an existing AI workflow; or prevent degradation, bias, unsafe automation, or metric gaming. Do not use for simple drafting, summarization, or coding requests unless the user asks for evaluation, governance, or deployment design.
---

# Design Safe AI Decisions

Treat AI as one component of a decision system, not as an isolated answer generator. Define what a good decision means before selecting a model, prompt, or tool, then make improvement and non-degradation testable.

Scale the process to the stakes. Keep low-risk, reversible uses lightweight. Require stronger evidence, human authority, and rollback controls when decisions affect rights, health, safety, employment, credit, access, or other consequential outcomes.

## Core Rules

- Start with the decision and outcome, not the model.
- Separate the model, the decision policy, the surrounding workflow, and the final outcome.
- Compare against a named baseline; do not evaluate a proposal in isolation.
- Use a metric portfolio with one primary outcome, guardrails, and segment-level checks.
- Treat legal, ethical, operational, budget, capacity, and supply limits as design constraints.
- Distinguish observed results, estimated counterfactuals, assumptions, and recommendations.
- Prefer staged, reversible deployment with predeclared stopping and rollback rules.
- Log enough context to reconstruct what happened and why.
- Never describe a system as safe merely because average accuracy improved.
- Never claim that historical logs reveal an unobserved outcome without explicit identification assumptions and uncertainty.

## Workflow

### 1. Frame the Decision

Write a decision statement:

> For each **decision unit**, at **decision time**, choose **an action** from **eligible actions** to improve **an outcome over a time horizon**, compared with **the current baseline**, subject to **constraints**.

Identify:

- the decision owner and the people affected;
- the unit of decision, timing, eligible actions, and excluded actions;
- the current policy or human process used as the baseline;
- the outcome delay and feedback path;
- whether the AI recommends, ranks, allocates, decides, or executes;
- where a human may review, override, appeal, or stop the action;
- the cost and reversibility of false positives, false negatives, and inaction.

If the use case only generates drafts or summarizes information, say so. Do not force an assistive tool into a decision-system frame unless its output materially changes downstream choices.

### 2. Define Evaluation Before Implementation

Create an evaluation contract before recommending a model or architecture:

1. Name one primary outcome tied to the actual goal.
2. Name quality, harm, operational, and distributional guardrails.
3. Define the measurement window, population, segments, and minimum acceptable sample.
4. Define the baseline and the minimum practically meaningful improvement.
5. Define non-inferiority limits for outcomes that must not worsen.
6. State who can accept residual risk.

Challenge proxy metrics. Explain how a metric could be gamed or improve while the real outcome worsens. Never collapse materially different harms into one average score.

### 3. Establish Evidence and Logging

Inspect the available evidence before selecting an evaluation method. Determine whether there are labeled cases, historical decisions and outcomes, action probabilities, randomized traffic, a credible simulator, or only expert judgment.

Require logs to capture, where applicable:

- timestamp, decision unit, relevant input context, and eligibility set;
- selected action, score or probability, policy/model/prompt version, and tool calls;
- human review, override, rationale, and fallback path;
- immediate and delayed outcomes, including missing or censored outcomes;
- experiment assignment and exposure;
- incidents, appeals, complaints, and downstream harm signals.

Minimize sensitive data and define retention and access controls. Do not collect fields merely because they may be useful later.

Read [evaluation-playbook.md](references/evaluation-playbook.md) before choosing offline evaluation, off-policy evaluation, simulation, shadow mode, or a live experiment.

### 4. Encode Constraints and Harms

Separate hard constraints from optimization objectives.

- Encode prohibited actions, privacy boundaries, capacity limits, budgets, inventory, latency, and mandatory review as hard constraints or system controls.
- Encode quality, cost, preference satisfaction, exposure, and other trade-offs as explicit objectives only when trade-offs are acceptable.
- Identify affected groups, asymmetric harms, accessibility needs, recourse, and responsibility for failures.
- Preserve a safe fallback when inputs are missing, confidence is low, tools fail, or the request is out of distribution.
- Prevent the model from bypassing controls through prompts, tool selection, or chained actions.

Treat ethics as part of the objective and constraint design, not as a disclaimer appended after optimization.

### 5. Select the Evaluation and Rollout Ladder

Choose the weakest intervention that can answer the current uncertainty:

1. Run static and historical evaluation.
2. Run counterfactual evaluation only when its assumptions are defensible.
3. Run adversarial, edge-case, and segment-level tests.
4. Run in shadow mode without affecting users.
5. Run a small, representative, reversible pilot.
6. Expand exposure only after meeting promotion criteria.

Predeclare:

- success, non-inferiority, and promotion thresholds;
- stopping thresholds and alert owners;
- maximum exposure and experiment duration;
- rollback mechanics and the known-good fallback;
- conditions requiring human review or incident escalation.

Avoid treating “1–5%” as a universal pilot size. Choose exposure from expected harm, reversibility, outcome frequency, statistical power, and operational capacity.

### 6. Monitor the Decision System

Monitor outcomes rather than model scores alone. Track:

- primary and guardrail metrics over time and by relevant segment;
- input, action, and outcome drift;
- calibration, uncertainty, abstention, override, appeal, and fallback rates;
- delayed outcomes and feedback-loop effects;
- capacity, cost, latency, and tool failures;
- policy, model, prompt, retrieval corpus, and dependency versions.

Set a review cadence, name owners, and define when to retrain, revise policy, narrow scope, pause, or retire the system.

### 7. Produce an Actionable Brief

Use [decision-brief-template.md](references/decision-brief-template.md) when the user asks for a design, review, audit, pilot, or rollout plan. Fill unknowns with clearly labeled assumptions only when they do not materially change the risk posture. Otherwise, identify the blocking evidence or decision.

Lead with the recommendation and the largest unresolved risk. Keep model selection subordinate to the decision, evaluation, and control design.

## Evidence Discipline

When deriving a method from a public figure, paper, organization, or existing system:

- verify factual claims against current primary sources when the task requires attribution;
- label direct evidence, inference, and proposed application separately;
- do not present a reconstructed methodology as a person's stated routine;
- do not invent private tool use, prompts, motives, or habits;
- preserve uncertainty when the public record does not answer the question.

## Resources

- Read [evaluation-playbook.md](references/evaluation-playbook.md) to select metrics, evidence, evaluation methods, safeguards, and rollout controls.
- Use [decision-brief-template.md](references/decision-brief-template.md) to structure the final deliverable.
