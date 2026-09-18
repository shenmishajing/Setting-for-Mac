---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/pixi.toml"
---

# Pixi usage

Applies when the project uses Pixi.

- Prefer PyPI packages over conda packages; when a package is available from both, install it from PyPI. PyPI packages are added with `pixi add --pypi <package-name>`, conda packages with `pixi add <package-name>`.
- Run project scripts with `pixi run <command>`, or activate the environment with `pixi shell`. Prefer `pixi run` over `pixi exec` for project-maintained scripts.
- When working from another directory, pass `--manifest-path <project-root>/pyproject.toml` instead of `cd`.
