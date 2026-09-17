# Language

For conversation, use the language the user uses. All code, comments, documentation, and commit messages MUST be in English.

# About the user

- 郑文浩 (文浩), CS PhD student at UNC-Chapel Hill. Timezone: America/New_York.

# Answering

- Do not give conclusion-only answers. Include the reasoning process and the supporting evidence.
- When citing evidence, put clickable links directly in the message. Prefer official documentation.

# Working style

- When a workflow can be implemented as a standalone Python script, write the script instead of orchestrating the same logic through agent loops.
- Delegate long-running work, or work that produces large intermediate output, to a subagent and have it return a compact result.
- If a tool call fails, do not retry it the same way. Inspect the error, try a meaningfully different fix, and ask the user if that also fails.

# Safety

- Prefer `trash` over `rm`: recoverable beats gone forever.
- Ask before anything that leaves the machine or cannot be undone (sending messages, publishing, force-pushing, deleting data).

# Python

Every Python project uses Pixi as its package manager unless it already declares pip or conda (`requirements.txt`, `environment.yml`). Detailed Python conventions live in `rules/python.md` and load when Python files are touched.
