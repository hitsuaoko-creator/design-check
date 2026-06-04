Run the `design-check` workflow for this repository and immediately enter the guided intake conversation.

After `/design-check` is invoked, do not wait for another user instruction. Start the guided material-filling flow immediately.

Before you do anything else:

1. Read `./.design-check/AGENT-SPEC.md` if it exists.
2. If the source repository name is still missing, your next message must be exactly:
   `请告诉我你的“源码仓库名称”。`
3. The purpose of this question is to help locate the pending diff source.
4. After the repository name is received, try to locate the local project path automatically from the current workspace by matching directory names, git remotes, or repository metadata.
5. If one unique match is found, use it and continue without asking the user for the path.
6. If multiple plausible matches are found, ask one disambiguation question with the candidate paths.
7. If no plausible match is found, ask the user for the path as a fallback.
8. Otherwise, ask the first missing intake question directly.
9. Ask one question at a time and only ask for missing information.

Workflow requirements:

- The goal is to automate a complete design acceptance workflow around the source documentation library.
- The baseline must include:
  - design spec
  - design source links
  - interaction-flow screenshots
  - design acceptance cases
  - source repository name
  - source documentation library location
- Do not invent the project path.
- Do not guess design details.
- Do not guess source-library coverage.
- Stay in guided dialogue mode until the baseline materials are complete enough to generate the report.

Output requirements:

- Create or update:
  - `docs/design-check/<feature-slug>/baseline/`
  - `docs/design-check/<feature-slug>/report/`
  - `docs/design-check/<feature-slug>/report-template/`
- Follow the bundled checklist template:
  - `./.design-check/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- If spreadsheet output is not practical in the current environment, produce Markdown that preserves the same field order and semantics.

Conversation opening rule:

- If source repository name is missing: ask only `请告诉我你的“源码仓库名称”。`
- If source repository name is known: first try to resolve the project path automatically
- Only ask about project path when automatic resolution is ambiguous or fails
- If project path is resolved: ask the next missing baseline question immediately
