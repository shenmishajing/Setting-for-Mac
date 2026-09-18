---
paths:
  - "**/*.py"
---

# Python tests

- Use `pytest` for unit tests.
- All test files live in a root `tests/` directory whose structure mirrors the source tree (`src/core/utils.py` requires `tests/core/test_utils.py`).
- Follow the TDD cycle for each function:
  1. Red: design and write real, functional test cases (no mocks) as if the function already existed. They must fail at this point.
  2. Green: write the simplest code that passes. Do not change the existing tests.
  3. Refactor: improve readability and structure while all tests keep passing.
