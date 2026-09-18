# Skills

Skills under this directory are symlinked to `~/.claude/skills/` by `scripts/config.sh`.

## Where a skill lives

One rule decides it:

- **Has a `pixi.toml` (bundles Python code)** → its own git repository, added here as a git submodule. Own history, own tests, own lock file, installable on its own with a single `git clone` into `~/.claude/skills/`.
- **Pure Markdown (`SKILL.md` plus optional `references/`)** → committed directly in this repository. It evolves together with `CLAUDE.md` and `rules/`, so one change is one commit.

## What goes where

- `rules/*.md` without `paths:` frontmatter: one topic per file, loaded every session (there is no CLAUDE.md; unscoped rules load exactly like one would). Splitting by topic lets a single topic be switched off with `claudeMdExcludes` in `settings.json`.
- `rules/*.md` with `paths:` frontmatter: conventions that only matter for certain file types; they load when Claude reads matching files.
- `skills/<name>/SKILL.md`: procedures, templates, and tooling that load on demand. A skill is switched off or restricted with `skillOverrides` in `settings.json` (`on`, `name-only`, `user-invocable-only`, `off`).

## Format for a code-bearing skill

```
<name>/
├── SKILL.md        # frontmatter: name, description; commands use ${CLAUDE_SKILL_DIR}
├── pixi.toml       # own environment; entry points defined under [tasks]
├── scripts/        # entry-point scripts and library code
├── references/     # detailed docs loaded by Claude only when needed
└── tests/          # pytest, mirrors scripts/
```

Commands in `SKILL.md` are written as

```bash
pixi run --manifest-path ${CLAUDE_SKILL_DIR}/pixi.toml <task> [args]
```

so they work wherever the skill is installed and create the environment on first use.

## Invocation control

- Heavy or side-effecting procedures set `disable-model-invocation: true` so only the user triggers them with `/<name>`.
- Knowledge and tooling skills keep the default so Claude can load them when the task matches their `description`.
