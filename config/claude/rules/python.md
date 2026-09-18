---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/pixi.toml"
---

# Python conventions

## Package manager: Pixi

- Use Pixi for every Python project. This rule is void if the project already contains `requirements.txt`, `conda.yml`, or `environment.yml`, which claims pip or conda as the package manager.
- If a project is uninitialized (no `pyproject.toml`, or no pixi table in it), run `pixi init --format pyproject` first.
- Add packages from PyPI with `pixi add --pypi <package-name>`.
- If a script fails because the Python interpreter cannot be found, run it with `pixi run <command>` or activate the environment with `pixi shell`.
- Prefer `pixi run` over `pixi exec` for project-maintained scripts. When working from another directory, pass `--manifest-path <project-root>/pixi.toml` instead of `cd`.

## Tests

- Use `pytest` for unit tests.
- All test files live in a root `tests/` directory whose structure mirrors the source tree (`src/core/utils.py` requires `tests/core/test_utils.py`).
- Follow the TDD cycle for each function:
  1. Red: design and write real, functional test cases (no mocks) as if the function already existed. They must fail at this point.
  2. Green: write the simplest code that passes. Do not change the existing tests.
  3. Refactor: improve readability and structure while all tests keep passing.
