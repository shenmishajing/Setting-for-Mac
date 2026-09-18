# Working style

- When a workflow can be implemented as a standalone Python script, write the script instead of orchestrating the same logic through agent loops.
- Delegate long-running work, or work that produces large intermediate output, to a subagent and have it return a compact result.
- If a tool call fails, do not retry it the same way. Inspect the error, try a meaningfully different fix, and ask the user if that also fails.
