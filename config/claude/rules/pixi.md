---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/pixi.toml"
---

# Pixi usage

Applies when the project uses Pixi.

- Add packages from PyPI with `pixi add --pypi <package-name>`; use plain `pixi add` only for conda-forge packages.
- Run project scripts with `pixi run <command>`, or activate the environment with `pixi shell`. Prefer `pixi run` over `pixi exec` for project-maintained scripts.
- When working from another directory, pass `--manifest-path <project-root>/pyproject.toml` instead of `cd`.
