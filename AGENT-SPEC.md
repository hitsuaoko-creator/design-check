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
- design source links
- interaction-flow screenshots
- design acceptance cases
- source documentation library location

The report template is bundled at:

- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

## Acceptance Target

The acceptance target is the source documentation library in the project, including the relevant documentation paths, implementation notes, or source-of-truth files defined by the user.

## Required Behavior

- Ask one question at a time.
- Ask only for missing information.
- If the code repository is known but the project path is still missing, ask `对应项目的路径是什么？` as the next message and wait for that single answer.
- Create the document structure before or while collecting answers.
- Fill the baseline files progressively.
- If the baseline is incomplete, stop the audit stage and list missing items.
- If the baseline is complete enough, read the source documentation library and generate the acceptance report.
- Keep the acceptance report aligned with the bundled spreadsheet template fields.
- Do not fabricate design details or source-library coverage.

## Default Structure

```text
docs/design-check/<feature-slug>/
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
