---
name: research-project
description: Run a research project as a traceable, reviewable iteration loop (idea -> review -> implement -> run_experiment -> analyze -> write_paper) with a hidden .research_log/ workspace, per-round artifacts, and explicit state transitions. Use when the user starts or continues a research project under this workflow.
disable-model-invocation: true
---

# Research project iteration guide

Goal: turn "research idea -> implementation -> experiments -> paper" into an executable, traceable, and reviewable process. Scope: one independent research project per project root.

File skeletons for everything below are in `${CLAUDE_SKILL_DIR}/references/templates.md`.

## 0. Core principles

1. **Design before code**: no implementation before the plan passes review.
2. **Every round has state, artifacts, and decisions**: discussion alone is not enough.
3. **Traceability first**: each round records changes, configs, results, and conclusions.
4. **Reviewer lens early**: every new or revised idea is pre-checked with reject-risk questions.
5. **Execution details stay separate**: this guide defines the research flow and artifacts; how to run tools is governed by the normal coding rules.

## 1. Project initialization (one time)

Follow this order strictly.

### 1.1 Confirm project metadata first

Before creating any project files, confirm all required metadata with the user. If anything is missing, ask; do not proceed with partial metadata. After confirmation, write it to `<project_root>/.research_log/project.yaml` using the schema in the templates:

- `project_name`: human-readable name.
- `project_id`: machine-friendly id (lowercase + underscore), used in folder and file names.
- `runtime`: `local`, or a concrete SSH target string such as `user@host` when the project runs remotely.
- `path.local_path`: local project root, normally under `~/Projects/...`.
- `path.remote_path`: execution path on the remote machine; required only when `runtime` is an SSH target, otherwise `null`. Must be user-specified.
- `resources.gpu_available`, `resources.gpu_count`, `resources.cpu_cores` (`null` if unknown).
- `notes`: free-form constraints, assumptions, setup notes.

Only the two path fields above are allowed.

### 1.2 Create the paths

1. Create the local project path.
2. If `runtime` is an SSH target, create or confirm the remote path on the remote machine.
3. Do not continue until the required paths are ready and accessible.

### 1.3 Workflow workspace layout

Create a hidden, git-ignored folder `<project_root>/.research_log/` (add `.research_log/` to `.gitignore`) with:

- `project.yaml`
- `state.json`
- `papers/` with optional `papers/notes.md` and zero or more `papers/<paper_id>/` (each with optional `paper.pdf` and `notes.md`)
- `round_<N>/` for each round, containing `<state>/` folders as required below

Rules: organize artifacts by round first, then by state. `idea` always uses `round_<N>/idea/`. `papers/` is cross-round shared storage.

### 1.4 Paper ids

Prefer meaningful semantic ids over opaque ones: `<topic>_<core_method>_<first_author>_<year>`, for example `long_context_rag_sparse_retrieval_zhang_2025`. Keep arXiv id or DOI as metadata inside the notes.

## 2. State machine (strict)

State order: `idea -> review -> implement -> run_experiment -> analyze -> write_paper`. At any time there is exactly one `current_state` in `state.json`, whose schema is in the templates. `history` is append-only.

### State A: `idea`

**Entry**: initialization complete, or returning from `review` or `analyze`.

**Do**: clarify the research problem and the exact target claims; read relevant recent papers and extract reusable ideas and risks; compare candidate approaches and select one concrete plan version; make the experiment design executable (datasets, metrics, baselines, ablations, analysis methods); define explicit success and failure criteria.

**Required files**: `round_<N>/idea/idea_state.json`, `round_<N>/idea/plan_v<v>.md` (required), `round_<N>/idea/notes_v<v>.md` (optional), and paper notes under `papers/`.

**Paper notes**: per-paper `notes.md` is free-form; recommended coverage is background and problem definition, motivation, module-level method sketch, and related-work comparison. Summarize important cross-paper findings in `papers/notes.md`.

**Versioning**: `v` is the idea version within the current round, starting at 0. `idea_state.json` records the latest version.

**`plan_v<v>.md` must**:
- start with a changelog describing differences from the previous version in this round, or, when `v = 0`, from the final version of the previous round;
- contain unambiguous sections for background and problem definition, motivation, module-level method sketch, related-work comparison and differences, and an experiment design draft with: dataset (names and why), metric (names, why, whether mainstream), baseline (names, methods, fairness justification), ablation (component-level), and deep-analysis feasibility (mechanism analysis or case study);
- have a realistic, executable experiment design and explicit result-evaluation criteria.

**Exit**: the current `plan_v<v>.md` is complete and execution-ready.

### State B: `review`

**Entry**: the latest plan in the current round is complete.

**Do**: evaluate the plan as a conference reviewer; identify the top rejection risks and whether they are fixable now; verify novelty and experiment fairness against known prior work; decide `proceed` or `revise` with concrete rationale.

**Storage**: no separate folder. Append a review section to the current `plan_v<v>.md`.

**Required questions**:
1. Is the problem real, meaningful, and worth solving?
2. Is the proposal sufficiently novel, with clear differentiation from prior work?
3. Is the experiment design reasonable and fair (dataset, metric, baseline, ablation)?
4. Can the planned claims be sufficiently supported by the experiments?
5. Is the deep analysis executable and likely to produce meaningful findings?
6. Overall: proceed or revise?

**Decision**: `revise` stays in the same round, sets `v = v + 1`, and returns to `idea` for a new `plan_v<v>.md`. `proceed` moves to `implement`.

### State C: `implement`

**Entry**: review says proceed.

**Do**: implement the approved plan with traceable code and config changes; keep scope aligned with the current claims, no silent scope creep; for each add, modify, or delete, run validation tests that directly prove correctness; fix blocking defects before exiting.

**Required file**: `round_<N>/implement/implement.md` with the detailed scope, what was added, modified, and deleted, and for each item the tests used and the results observed.

**Exit**: implementation details and validation evidence are complete and traceable.

### State D: `run_experiment`

**Entry**: implement exit criteria satisfied.

**Do**: launch the planned experiment matrix (main runs, baselines, ablations, analyses); track every run with reproducible identifiers and artifact paths; monitor run health and record restarts or skips explicitly; ensure outputs are complete and readable.

**Required file**: `round_<N>/run_experiment/experiment.md` listing every experiment, its purpose, and for each run the output path, log path, and job identifier or status.

**Exit**: experiment records are complete and sufficient for analysis.

### State E: `analyze`

**Entry**: experiment artifacts available and readable.

**Do**: analyze each experiment individually against expected behavior; aggregate evidence across runs to test each major claim; diagnose failure modes and separate signal from noise; produce a go/no-go recommendation with concrete next actions.

**Required file**: `round_<N>/analyze/analysis.md`, in this order: per-experiment analysis, aggregated cross-experiment analysis, then conclusion and recommendations (pass/fail against target criteria, suggested modification directions, practical next steps).

**Exit**: an explicit decision to move to `write_paper` or return to `idea`.

### State F: `write_paper`

**Entry**: analysis concludes results are sufficient.

**Do**: convert validated findings into paper structure and narrative; back each claim with explicit evidence; document reproducibility pointers; identify remaining writing gaps.

**Required files**: `round_<N>/write_paper/paper_outline.md` and `round_<N>/final_report.md`. The final report contains an end-to-end round summary, a claim-evidence map, and a reproducibility index (commit, config, data, log pointers).

**Exit**: the draft is submission-ready or ready for the next writing iteration.

## 3. Round summary (every round)

`round_<N>/summary.md` with: round objective, state transitions in this round, key artifact index, code and config traceability, core results, conclusion and next step.
