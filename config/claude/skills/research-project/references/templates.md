# Templates for the research-project workflow

## `.research_log/project.yaml`

```yaml
project:
  project_name: "Human-readable project name"
  project_id: my_project_id
  runtime: local            # or "user@host"
  path:
    local_path: ~/Projects/my_project
    remote_path: null       # required when runtime is an SSH target
  resources:
    gpu_available: true
    gpu_count: 1
    cpu_cores: null
  notes: ""
```

## `.research_log/state.json`

```json
{
  "project_id": "my_project_id",
  "current_state": "idea",
  "round": 0,
  "idea_version": 0,
  "last_transition_at": "2026-01-01T00:00:00-05:00",
  "history": [
    {
      "round": 0,
      "idea_version": 0,
      "from": null,
      "to": "idea",
      "at": "2026-01-01T00:00:00-05:00",
      "reason": "project initialized"
    }
  ]
}
```

Field notes: `round` starts at 0; `idea_version` is the version within the current round and starts at 0; `history` is append-only; `from` is `null` only at initialization.

## `round_<N>/idea/idea_state.json`

```json
{
  "round": 0,
  "latest_idea_version": 0,
  "plans": ["plan_v0.md"]
}
```

## `round_<N>/idea/plan_v<v>.md`

```markdown
# Plan v<v> (round <N>)

## Changelog
<differences from plan_v<v-1>.md in this round, or from the previous round's final plan when v = 0>

## Background and problem definition
## Motivation
## Method sketch (module level)
## Related work and differences
## Experiment design
### Dataset
### Metric
### Baseline
### Ablation
### Deep analysis feasibility
## Success and failure criteria

## Review (appended in the `review` state)
1. Problem real and worth solving?
2. Sufficiently novel and differentiated?
3. Experiment design reasonable and fair?
4. Claims supportable by the experiments?
5. Deep analysis executable and meaningful?
6. Decision: proceed | revise, with rationale
```

## `round_<N>/implement/implement.md`

```markdown
# Implementation (round <N>)

## Scope
## Added
- <item>: tests used; results observed
## Modified
- <item>: tests used; results observed
## Deleted
- <item>: tests used; results observed
```

## `round_<N>/run_experiment/experiment.md`

```markdown
# Experiments (round <N>)

## <experiment name>
- Purpose:
- Runs:
  - id/status:
  - output path:
  - log path:
```

## `round_<N>/analyze/analysis.md`

```markdown
# Analysis (round <N>)

## 1. Per-experiment analysis
## 2. Aggregated analysis
## 3. Conclusion and recommendations
- Pass/fail against target criteria:
- Suggested modification directions:
- Next steps:
```

## `round_<N>/summary.md`

```markdown
# Round <N> summary

- Objective:
- State transitions:
- Key artifacts:
- Code/config traceability:
- Core results:
- Conclusion and next step:
```

## `.gitignore` entry

```gitignore
.research_log/
```
