# Python package manager

- Prefer Pixi for our own projects and for projects whose tooling is not settled yet.
- If a project has already chosen its tooling (for example someone else's project with `requirements.txt`, `environment.yml`, `uv.lock`, `poetry.lock`, or a `[tool.uv]` / `[tool.poetry]` table in `pyproject.toml`), follow that choice instead.
- When a project of ours is not initialized yet (no `pyproject.toml`), run `pixi init --format pyproject`.
