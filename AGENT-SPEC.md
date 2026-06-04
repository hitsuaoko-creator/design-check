# design-check Agent Spec

`design-check` is a tool-agnostic skill specification for AI coding agents and IDE assistants.

It is intended to work in environments such as:

- Codex
- Cursor
- Claude Code
- Antigravity
- Trae
- any other agent environment that supports reusable prompt files, skills, slash commands, or agent instructions

## Purpose

Automate UI design acceptance against a source documentation library.

The agent must do two stages:

1. complete the acceptance baseline materials
2. generate a design acceptance report against the source documentation library

## Baseline Materials

The baseline must include:

- design spec
- design source files
- interaction-flow screenshots (optional)
- design acceptance cases
- source repository name
- source documentation library location

The report template is bundled at:

- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

## Acceptance Target

The acceptance target is the source documentation library in the project, including the relevant documentation paths, implementation notes, or source-of-truth files defined by the user.

## Required Behavior

- If this skill is triggered again in the same agent conversation, ask the user to choose one option before proceeding:
  - `1. 进入新的设计验收`
  - `2. 继续上一轮验收`
- If the user chooses `1`, restart the workflow from the beginning.
- If the user chooses `2`, continue the previous run from its current state and reuse the existing artifact root and collected materials.
- Do not proceed until the user explicitly replies with `1` or `2`.
- Ask one question at a time.
- Ask only for missing information.
- Ask for `design-spec.md` first.
- Ask for the design source file or files second.
- Ask for interaction-flow screenshots third, and treat them as optional.
- If interaction screenshots are missing, switch to `视觉验收` mode and record that limitation.
- Draft the acceptance cases from the bundled template after the first three material steps.
- Ask for the source repository name only after the baseline materials are underway.
- After the source repository name is known, try to locate the local project path automatically by matching directory names, git remotes, or repository metadata in the current workspace or mounted project roots.
- If one unique project path match is found, continue without asking the user for the path.
- If multiple plausible project path matches are found, ask one disambiguation question with the candidate paths.
- If no plausible project path match is found, ask the user for the path only as a fallback.
- Create the document structure under `~/Documents/Playground` before or while collecting answers.
- Fill the baseline files progressively.
- If the baseline is incomplete, stop the audit stage and list missing items.
- If the baseline is complete enough, read the source documentation library and generate the acceptance report.
- Keep the acceptance report aligned with the bundled spreadsheet template fields.
- Do not fabricate design details or source-library coverage.
- Keep all user-provided and AI-generated materials inside the default artifact root unless the user explicitly requests another location.

## Default Structure

```text
~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/
├── materials/
│   ├── user-provided/
│   └── ai-generated/
├── baseline/
│   ├── design-spec/
│   ├── design-source/
│   ├── interaction-flow/
│   ├── acceptance-cases/
│   └── source-doc-library/
├── report/
└── report-template/
```

## Suggested Integration

In platforms with native skill support, register `SKILL.md` as the skill entry file.

In platforms without native skill support, copy the behavior rules from `SKILL.md` or this file into:

- a reusable system prompt
- a workspace instruction file
- a slash command template
- a custom agent preset

## Output Expectation

The final artifact is not just the baseline materials. The final artifact also includes a design acceptance report generated against the source documentation library and aligned with the bundled report template.
