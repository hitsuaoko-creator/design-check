# design-check

`design-check` is a reusable, tool-agnostic agent skill for automated UI design acceptance.

It can be adapted for:

- Codex
- Cursor
- Claude Code
- Antigravity
- Trae
- other agent-based IDEs or automation runtimes

Its goal is to automate a complete design acceptance workflow around a source documentation library.

## What This Skill Does

`design-check` works in two stages:

1. complete the acceptance baseline materials
2. generate a design acceptance report against the source documentation library

The acceptance baseline includes:

- design spec
- design source links
- interaction-flow screenshots
- design acceptance cases

The acceptance target includes:

- source repository name
- source documentation library location

The bundled design acceptance report template lives at:

- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

## Acceptance Object

The acceptance object is the source documentation library in the target project.

This can include:

- documentation directories
- implementation handoff documents
- source-of-truth UI description files
- feature documentation paths defined by the user

The report should evaluate whether the source documentation library reflects the baseline materials.

## Default Output Structure

```text
docs/design-check/<feature-slug>/
├── baseline/
│   ├── design-spec/
│   │   └── design-spec.md
│   ├── design-source/
│   │   └── design-source-links.md
│   ├── interaction-flow/
│   │   ├── interaction-flow.md
│   │   └── screenshots/
│   ├── acceptance-cases/
│   │   └── design-acceptance-cases.md
│   └── source-doc-library/
│       └── source-doc-library.md
├── report/
│   └── design-acceptance-report.md
└── report-template/
    ├── design-acceptance-checklist-template.xlsx
    └── design-acceptance-checklist-template-notes.md
```

## Repository Structure

```text
design-check/
├── AGENT-SPEC.md
├── SKILL.md
├── agents/
│   └── openai.yaml
├── assets/
│   └── templates/
│       └── design-check-kit/
│           ├── baseline/
│           ├── report/
│           └── report-template/
├── scripts/
│   └── bootstrap_design_check.sh
└── install-skill.sh
```

## Included Templates

- `assets/templates/design-check-kit/baseline/design-spec/design-spec.md`
- `assets/templates/design-check-kit/baseline/design-source/design-source-links.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/interaction-flow.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/screenshots/.gitkeep`
- `assets/templates/design-check-kit/baseline/acceptance-cases/design-acceptance-cases.md`
- `assets/templates/design-check-kit/baseline/source-doc-library/source-doc-library.md`
- `assets/templates/design-check-kit/report/design-acceptance-report.md`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template-notes.md`

## How To Use In Different Tools

For platforms with native skill support:

- use `SKILL.md` as the skill entry file

For platforms without native skill support:

- use `AGENT-SPEC.md` as a reusable agent instruction
- or copy the rules into a custom prompt, slash command, or workspace instruction

`agents/openai.yaml` is optional metadata for platforms that support UI-facing skill registration. It is not required for the core workflow.

## Slash Command Setup

This repository also includes ready-to-install slash command files for:

- Cursor: `.cursor/commands/design-check.md`
- Claude Code: `.claude/commands/design-check.md`

Install them into a target code repository:

```bash
bash scripts/install_slash_commands.sh /abs/path/to/project both
```

Or install only one platform:

```bash
bash scripts/install_slash_commands.sh /abs/path/to/project cursor
bash scripts/install_slash_commands.sh /abs/path/to/project claude
```

The installer also copies support files into:

```text
.design-check/
├── AGENT-SPEC.md
└── design-check-kit/
```

After installation, you can trigger the workflow from chat with:

- `/design-check` in Cursor
- `/design-check` in Claude Code

After `/design-check`, the agent should immediately enter the guided intake flow. You should not need to add another instruction.

If the source repository name is still missing, the first required follow-up question is:

- `请告诉我你的“源码仓库名称”。`

The purpose of this question is to help locate the pending diff source.

If the source repository name is already known, the agent should first try to resolve the local project path automatically instead of asking the user to find it.

The agent should ask about the path only when:

- multiple plausible project path candidates are found and one needs to be confirmed
- no plausible project path candidate can be found at all

## Install

Install into the default Codex skills directory:

```bash
bash install-skill.sh
```

Install into a custom directory:

```bash
bash install-skill.sh /path/to/skills-root
```

If you are not using Codex, you can still copy this repository or only the `SKILL.md` and template files into your own agent setup.

## Bootstrap a Document Kit

Generate the document structure inside a target project:

```bash
bash scripts/bootstrap_design_check.sh /abs/path/to/project docs/design-check/login-page
```

## Expected Workflow

The agent should:

1. if the source repository name is still unknown, ask `请告诉我你的“源码仓库名称”。`
2. the purpose of this question is to help locate the pending diff source
3. after the repository name is received, auto-locate the local project path in the current workspace or mounted project roots
4. if there is one unique path match, continue without asking the user for a path
5. if there are multiple plausible path matches, ask one disambiguation question
6. if there is no plausible path match, fall back to asking the user for the path
7. confirm the feature name, document path, and source documentation library path
8. ask for design source links
9. ask for the design spec summary
10. ask for the interaction flow and screenshots
11. ask for the design acceptance cases
12. fill the baseline files
13. verify whether the baseline is complete enough
14. read the source documentation library
15. generate the design acceptance report with the bundled checklist template structure

The agent should ask one question at a time and only ask for missing information.

If the source repository name is not known, the agent should not guess it. If the repository name is known, the agent should try path discovery first and only ask the user when discovery is ambiguous or fails.

## Trigger Examples

- `Use $design-check to automate design acceptance for the login page against the source documentation library.`
- `Use $design-check, ask me step by step questions, complete the baseline materials, then generate the design acceptance report.`
- `Use $design-check to scaffold docs/design-check/payment-result and review the source documentation library against the design baseline.`
- `设计验收`

A typical opening exchange can be:

- user says: `设计验收`
- agent asks: `请告诉我你的“源码仓库名称”。`
- user replies with one repository name
- agent resolves the local path automatically and continues
- if multiple candidates exist, the agent asks the user to choose one

## Main Files

- `SKILL.md`: skill trigger conditions and agent workflow
- `AGENT-SPEC.md`: tool-agnostic integration guidance
- `scripts/bootstrap_design_check.sh`: scaffolds the acceptance document kit
- `scripts/install_slash_commands.sh`: installs slash command files into a target repository
- `install-skill.sh`: installs the skill into a Codex skills directory

## Notes

- This skill is designed for automated design acceptance, not only document collection.
- If baseline materials are incomplete, the report should remain in a blocked state and list the missing items.
- If spreadsheet output is supported, the agent can also export `design-acceptance-report.xlsx` from the bundled template.
