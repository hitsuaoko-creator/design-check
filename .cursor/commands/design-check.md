Run the `design-check` workflow for this repository and immediately enter the guided intake conversation.

After `/design-check` is invoked, do not wait for another user instruction. Start the guided material-filling flow immediately.

Before you do anything else:

1. Read `./.design-check/AGENT-SPEC.md` if it exists.
2. If this workflow was already triggered earlier in the same conversation, first ask the user to choose:
   - `1. 进入新的设计验收`
   - `2. 继续上一轮验收`
3. Do not proceed until the user explicitly replies with `1` or `2`.
4. If the user chooses `1`, restart from asking for `design-spec.md`.
5. If the user chooses `2`, continue the previous run from its current state and reuse the existing artifact root and collected materials.
6. Otherwise, for a first-time trigger, start by asking for `design-spec.md`.
7. Ask one question at a time and only ask for missing information.
8. Ask for design source files second.
9. Ask for interaction screenshots third and state that they are optional.
10. If screenshots are missing, switch to `视觉验收` mode and record that explicitly.
11. Draft acceptance cases from the bundled template before asking for the source repository.
12. Ask for the source repository name only after the baseline materials are underway.
13. After the repository name is received, try to locate the local project path automatically from the current workspace by matching directory names, git remotes, or repository metadata.
14. If one unique match is found, use it and continue without asking the user for the path.
15. If multiple plausible matches are found, ask one disambiguation question with the candidate paths.
16. If no plausible match is found, ask the user for the path as a fallback.

Workflow requirements:

- The goal is to automate a complete design acceptance workflow around the source documentation library.
- The baseline must include:
  - design spec
  - design source files
  - interaction-flow screenshots (optional)
  - design acceptance cases
  - source repository name
  - source documentation library location
- Do not invent the project path.
- Do not guess design details.
- Do not guess source-library coverage.
- Stay in guided dialogue mode until the baseline materials are complete enough to generate the report.
- Keep all user-provided and AI-generated materials in a separate artifact folder under `~/Documents/Playground`.

Output requirements:

- Create or update:
  - `~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/materials/`
  - `~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/baseline/`
  - `~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/report/`
  - `~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/report-template/`
- Follow the bundled checklist template:
  - `./.design-check/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- If spreadsheet output is not practical in the current environment, produce Markdown that preserves the same field order and semantics.

Conversation opening rule:

- On repeated trigger in the same conversation, ask the user to choose `1` or `2` before anything else
- For a new run, first ask for `design-spec.md`
- Do not start with the repository question
- Only ask about project path when automatic resolution is ambiguous or fails
