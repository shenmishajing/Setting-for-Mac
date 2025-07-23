# Language

All code, comments, documentation, and commit messages MUST be in English. For conversation, you MUST use the language user uses.

# Unit Test

All test files MUST be placed in a root tests/ directory.

The tests/ directory structure MUST mirror the source code's structure (e.g., src/core/utils.py requires tests/core/test_utils.py).

For python projects, you MUST use `pytest` for unit tests.

# Python Package Manager

For any Python project, you are required to use Pixi as the package manager. This rule is void if the project already contains requirements.txt, conda.yml, or environment.yml, which claims pip or conda as package manager.

- If a project is uninitialized, e.g. without a pyproject.toml or no pixi table in pyproject.toml, run `pixi init --format pyproject` to init it first.
- Always add python packages from PyPI using `pixi add --pypi <package-name>`.
- If a script fails because the Python interpreter cannot be found, run `pixi shell` to activate the environment first or use `pixi run` to run that command in pixi environment.

# Agentic Workflow

## Core Principles

1. **Structured Thinking**: Every task is a "job". We think before we act.
2. **Modularity & Reusability**: We use a file-system-based approach for modularity and reuse past analyses to work smarter, always considering the timeliness of information.
3. **Recursive Execution & Dynamic Adaptation**: We execute tasks as a recursive tree traversal. We verify results at each step and are prepared to re-plan if execution deviates from expectation.
4. **User-in-the-Loop**: All plans must be reviewed and approved by the user before execution begins.
5. **Pure Test-Driven Development (TDD)**: All implementation is driven by real, functional tests, following the Red-Green-Refactor cycle.

## The Workflow You Must Follow

### Phase 1: Job Initialization & Analysis

1. **Job Naming**:

    - When I give you a new requirement, first propose a short, descriptive, kebab-case `<job-name>`. If I ask for the modification of an existing job, you must use the same `<job-name>`.
    - The descriptive name is crucial for future knowledge reuse.

2. **Analysis & Knowledge Reuse**:
    - **A. Reuse Past Work**: Before reading any source code, first, list the directories in `.claude/jobs/`. Identify any jobs with names relevant to the current task. If you find any, read their `code_analysis.md` file.
      - **CRITICAL REMINDER**: You must check the timestamp at the top of the old analysis file. You must consider if subsequent code changes have made that analysis obsolete.
      - **Note on Code Analysis**: Remember, the code analysis for one job was written before its execution. To understand the result of a past job, read the current source code or any other older relevant job's analysis, not the analysis of that job.
    - **B. New Analysis**: Perform any additional analysis needed by reading relevant files in the current codebase.
    - **C. Synthesize & Timestamp**: Combine reused knowledge with new findings and write a comprehensive summary into the current job's `.claude/jobs/<job-name>/main/code_analysis.md` file. At the very top of this file, you **must** record the current date, time, and timezone.

### Phase 2: Hierarchical Planning

1. **Plan Strategy**: Based on your analysis in `code_analysis.md`, create a comprehensive plan and write it into `plan.md`. You will follow a recursive strategy to build this plan:

    - **Base Case (Leaf Node)**: If a requirement is simple enough to be implemented directly, its plan is a **Leaf Node Plan**. This plan must be a detailed TDD specification containing:
      - **Objective**: A clear one-sentence goal.
      - **Input/Output Spec**: A description of expected inputs and outputs.
      - **Test Cases**: A list of specific test cases to be written.
      - **Implementation Strategy**: A high-level description of how you plan to write the code.
    - **Recursive Step (Parent Node)**: If a requirement is complex, its plan is a **Parent Node Plan**. You must decompose it into a logical sequence of smaller steps. For each step, you will: 1. Propose a descriptive `<sub-job-name>`. 2. **Recursively generate the plan for that sub-job**, following this exact same planning strategy. The result will be either another Parent Node Plan or a Leaf Node Plan.
      The final `plan.md` for the top-level job must contain this entire nested structure, representing the complete, detailed plan for the whole requirement tree. You can use markdown headings and nested lists to represent the tree structure.

2. **Plan Review**: Present the complete, deeply-nested plan from `plan.md` to me for review. I must approve this plan before you proceed to the next phase.

### Phase 3: Execute Plan (Recursive Engine)

This phase begins after I approve your plan. You will execute the plan tree starting from the root node.

#### Parent Node Responsibilities (Project Manager)

If the current node you are executing is a parent node (its `plan.md` lists sub-jobs):

1. **Create To-Do List**: Your `progress.md` file is a to-do list of its child nodes (the sub-jobs).
2. **Iterate and Delegate**: Process the children one by one. For each `<sub-job-name>` in your to-do list:
    a. **Create Workspace**: Create the sub-job's directory: `.claude/jobs/<parent-job-name>/<sub-job-name>/main/`.
    b. **Provide Context**: Populate the sub-job's scratchpad (`code_analysis.md`, `plan.md`) by copying only relevant information from your own scratchpad to make sure the sub-job has all the context it needs while focusing on its task.
    c. **Delegate**: Start a sub-agent to execute the task defined for that sub-job.
    d. **Verify & Adapt**: Await the result from the sub-agent. **Verify if the result meets the objective.**
    _**If successful**: Check off the item in your `progress.md`, adding a timestamp.
    _ **If failed or unexpected**: Announce the failure. You must re-enter an analysis/planning loop. You may need to read more code, modify your `plan.md`, and alter your `progress.md`. Then, re-attempt the step.
    e. **Proceed**: Move to the next child node in the list.

#### Leaf Node Responsibilities (Implementer)

If the current node you are executing is a leaf node (its `plan.md` is a TDD spec):

1. **Optional Analysis**: If needed, you can perform additional, fine-grained code analysis and record it in your own `code_analysis.md` with a timestamp.
2. **Create TDD To-Do List**: Your `progress.md` should be created with the following items, based on your TDD plan:
    - `-[ ] Write failing tests`
    - `-[ ] Implement code to pass tests`
    - `-[ ] Refactor and verify`
3. **Execute TDD Cycle**:
    a. **Red Phase (Write Tests)**: Write the tests as designed in your `plan.md`. \* **TDD Philosophy**: These must be **real, functional tests**, not mocks. They should test the final desired behavior, even if the underlying functions or classes do not exist yet. Naturally, these tests will fail.
    b. **Green Phase (Implement Code)**: Write the simplest, cleanest code necessary to make the tests pass. Do not modify the tests.
    c. **Refactor Phase**: Improve the code's structure and quality without changing its external behavior. Ensure all tests continue to pass.
4. **Track Progress**: After completing each of the three steps above, check it off in your `progress.md` and add a timestamp.
5. **Return Result**: Once your local to-do list is complete, report your success and final implementation back to your parent node.

### Phase 4: Job Completion

The entire job is finished when the **root node's** `progress.md` to-do list is fully completed. At this point, you must provide a final, comprehensive report summarizing the requirement, the actions taken, the code created/modified, and the final result.
