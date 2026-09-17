---
name: job
description: Structured multi-step implementation workflow: named job, code analysis with knowledge reuse under .claude/jobs/, recursive hierarchical plan approved by the user, then TDD execution through subagents with progress tracking. Use for substantial coding tasks that deserve planning and traceability.
disable-model-invocation: true
---

# Job workflow

## Core principles

1. **Structured thinking**: every task is a "job". We think before we act.
2. **Modularity and reusability**: we use a file-system-based approach for modularity and reuse past analyses to work smarter, always considering the timeliness of information.
3. **Recursive execution and dynamic adaptation**: we execute tasks as a recursive tree traversal. We verify results at each step and re-plan if execution deviates from expectation.
4. **User in the loop**: all plans must be reviewed and approved by the user before execution begins.
5. **Pure test-driven development**: all implementation is driven by real, functional tests, following the Red-Green-Refactor cycle.

## Phase 1: job initialization and analysis

1. **Job naming**
    - For a new requirement, first propose a short, descriptive, kebab-case `<job-name>`. For a modification of an existing job, reuse the same `<job-name>`.
    - The descriptive name is crucial for future knowledge reuse.

2. **Analysis and knowledge reuse**
    - **A. Reuse past work**: before reading any source code, list the directories in `.claude/jobs/`. Identify jobs with names relevant to the current task and read their `code_analysis.md`.
      - Check the timestamp at the top of the old analysis. Consider whether subsequent code changes have made it obsolete.
      - The code analysis for a job was written before its execution. To understand the result of a past job, read the current source code or an older relevant job's analysis, not that job's own analysis.
    - **B. New analysis**: perform any additional analysis needed by reading relevant files in the codebase.
    - **C. Synthesize and timestamp**: combine reused knowledge with new findings into `.claude/jobs/<job-name>/main/code_analysis.md`. Record the current date, time, and timezone at the very top.

## Phase 2: hierarchical planning

1. **Plan strategy**: based on `code_analysis.md`, write a comprehensive plan into `plan.md`, built recursively:
    - **Leaf node plan**: for a requirement simple enough to implement directly, a detailed TDD specification containing:
      - **Objective**: a clear one-sentence goal.
      - **Input/output spec**: expected inputs and outputs.
      - **Test cases**: the specific test cases to be written.
      - **Implementation strategy**: how the code will be written, at a high level.
    - **Parent node plan**: for a complex requirement, decompose it into a logical sequence of smaller steps. For each step, propose a descriptive `<sub-job-name>` and recursively generate its plan with this same strategy.
    The top-level `plan.md` contains the entire nested structure, using markdown headings and nested lists to represent the tree.

2. **Plan review**: present the complete nested plan to the user. The user must approve it before Phase 3.

## Phase 3: execute the plan (recursive engine)

Start from the root node after approval.

### Parent node (project manager)

If the current node's `plan.md` lists sub-jobs:

1. **Create to-do list**: `progress.md` is a to-do list of the child sub-jobs.
2. **Iterate and delegate**, for each `<sub-job-name>` in order:
    a. **Create workspace**: `.claude/jobs/<parent-job-name>/<sub-job-name>/main/`.
    b. **Provide context**: populate the sub-job's `code_analysis.md` and `plan.md` by copying only the relevant information from the parent scratchpad, so the sub-job has what it needs while staying focused.
    c. **Delegate**: start a subagent to execute the sub-job.
    d. **Verify and adapt**: await the result and verify it meets the objective.
       - If successful: check off the item in `progress.md` with a timestamp.
       - If failed or unexpected: announce the failure, re-enter the analysis/planning loop (read more code, modify `plan.md`, alter `progress.md`), then re-attempt.
    e. **Proceed** to the next child.

### Leaf node (implementer)

If the current node's `plan.md` is a TDD spec:

1. **Optional analysis**: perform fine-grained analysis if needed and record it, timestamped, in the node's own `code_analysis.md`.
2. **Create TDD to-do list** in `progress.md`:
    - `- [ ] Write failing tests`
    - `- [ ] Implement code to pass tests`
    - `- [ ] Refactor and verify`
3. **Execute the TDD cycle**:
    a. **Red**: write the tests designed in `plan.md`. They must be real, functional tests, not mocks, testing the final desired behavior even if the code does not exist yet. They fail at this point.
    b. **Green**: write the simplest, cleanest code that makes the tests pass. Do not modify the tests.
    c. **Refactor**: improve structure and quality without changing external behavior. All tests keep passing.
4. **Track progress**: check off each step in `progress.md` with a timestamp.
5. **Return result**: report success and the final implementation back to the parent node.

## Phase 4: job completion

The job is finished when the root node's `progress.md` is fully checked off. Provide a final report summarizing the requirement, the actions taken, the code created or modified, and the final result.
