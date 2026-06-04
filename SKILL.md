---
name: design-check
description: Use this skill when the user wants to automate UI design acceptance against a source documentation library, or explicitly says `设计验收`. This skill first asks step by step questions to complete the acceptance baseline materials, including design spec, design source links, interaction-flow screenshots, design acceptance cases, and source documentation library location, then generates a design acceptance report against the source documentation library.
---

# design-check

Use this skill to automate UI design acceptance for one page, one feature, or one interaction flow at a time.

This is a two-stage skill:

1. collect and complete the acceptance baseline materials
2. generate a design acceptance document against the source documentation library

The acceptance object is the source documentation library, not the chat transcript.

## Use This Skill For

- 自动化做设计验收
- 补齐设计验收基线材料
- 收集源码文档库位置
- 基于基线材料对源码文档库做设计验收
- 输出结构化设计验收文档

## Acceptance Baseline

The acceptance baseline must include all of the following:

- `design spec`
- `design source links`
- `interaction-flow screenshots`
- `design acceptance cases`

The acceptance target must also be defined:

- `source repository name`
- `source documentation library location`

If any baseline item is missing, ask only for the missing item and write it into the corresponding file.

## Required Output Structure

Unless the user gives another location, use this default structure inside the target project:

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
│   ├── design-acceptance-report.md
│   └── design-acceptance-report.xlsx (optional)
└── report-template/
    ├── design-acceptance-checklist-template.xlsx
    └── design-acceptance-checklist-template-notes.md
```

The bundled template lives at `assets/templates/design-check-kit/`.

If the target project does not already have the structure, create it by copying the bundled template or by running:

```bash
bash scripts/bootstrap_design_check.sh /abs/path/to/project docs/design-check/<feature-slug>
```

## Required Workflow

### 1. Lock the acceptance target

Ask for only the missing information.

Always identify:

- source repository name
- target project path
- page or feature name
- document root path
- source documentation library path or paths
- acceptance scope

If the source repository name is still missing, the next question in the dialogue must be:

- `请告诉我你的“源码仓库名称”。`

The purpose of this question is to help locate the pending diff source.

At this step, do not ask bundled follow-up questions in the same message. Wait for the user to reply with the repository name only, then continue.

If the source repository name is already known but the corresponding project path is still missing, the next question in the dialogue must be:

- `对应项目的路径是什么？`

At this step, do not ask bundled follow-up questions in the same message. Wait for the user to reply with the path only, then continue.

If the user does not provide a document root path, propose `docs/design-check/<feature-slug>` and ask for confirmation.

### 2. Ask step by step, one question at a time

Do not ask a large batch of questions at once.

Use this order:

1. if the source repository name is still unknown, ask `请告诉我你的“源码仓库名称”。`
2. if the source repository name is known but the project path is still unknown, ask `对应项目的路径是什么？`
3. confirm the page or feature name, doc path, and source documentation library path
4. ask for the design source link or links
5. ask for the design spec summary that must be preserved in implementation
6. ask for the interaction path or user journey that needs screenshots
7. ask whether screenshots already exist and where they are stored
8. ask for the design acceptance cases

Only move to the next question after the previous answer is received or explicitly skipped.

### 3. Scaffold first, then fill

As soon as the target path is known:

- create the folder structure if it does not exist
- create or update the baseline files and the report file
- preserve any existing user content

Do not leave the structure implicit in chat only. Materialize it in files.

### 4. Fill the baseline materials

Update the files with the user's answers.

Required file intent:

- `baseline/design-spec/design-spec.md`: page goals, mandatory UI constraints, states, acceptance focus
- `baseline/design-source/design-source-links.md`: Figma, MasterGo, prototype, handoff, related ticket links
- `baseline/interaction-flow/interaction-flow.md`: ordered flow steps, expected state per step, screenshot mapping, missing evidence
- `baseline/acceptance-cases/design-acceptance-cases.md`: explicit acceptance checks, expected result, pass criteria, priority
- `baseline/source-doc-library/source-doc-library.md`: source repository name, diff-source purpose, project path, doc root, source files, entry points, excluded paths

If an answer is missing, record it as `待补充` instead of inventing details.

### 5. Handle screenshots explicitly

The `baseline/interaction-flow/screenshots/` directory is required.

If screenshots are already available:

- ask for the exact file paths
- reference them from `interaction-flow.md`

If screenshots do not exist yet:

- list which screens still need capture
- write them into `interaction-flow.md`
- keep the `screenshots/` folder ready for later assets

### 6. Check baseline completeness

Before generating the acceptance report, verify whether the baseline is complete enough.

Minimum condition to proceed:

- source repository name is known
- source documentation library location is known
- design spec is present
- design source link is present
- interaction flow is present
- at least one acceptance case is present

If the minimum condition is not met:

- stop the audit stage
- list the missing items
- keep the report file in `blocked` state

### 7. Run the acceptance review against the source documentation library

When the minimum condition is met:

- read the source documentation library files in scope
- compare them against the baseline materials
- evaluate each acceptance case against the source documentation library
- identify matched, missing, inconsistent, and blocked items
- generate `report/design-acceptance-report.md`
- follow the bundled report template structure at `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

The report must focus on whether the source documentation library reflects the baseline, not whether the baseline itself is ideal.

### 8. Produce the acceptance report

The report must follow the bundled design acceptance checklist template.

If the current environment can write spreadsheet outputs, also generate `report/design-acceptance-report.xlsx` based on the bundled template.

If the current environment cannot write spreadsheet outputs, generate a Markdown report that preserves the same field order and semantics as the spreadsheet template.

The report must contain:

1. target summary
2. baseline completeness
3. source documentation library scope
4. acceptance case results
5. findings and gaps
6. blocked or unclear items
7. next actions

## Output Rules

When using this skill:

- keep questions short and concrete
- ask one question at a time
- prefer editing files over leaving guidance only in chat
- do not fabricate design details
- do not fabricate source-library coverage
- preserve the report columns defined by the bundled checklist template
- preserve existing content and append or refine where possible
- keep the report tied to the source documentation library

## Template Files

This skill ships with:

- `assets/templates/design-check-kit/baseline/design-spec/design-spec.md`
- `assets/templates/design-check-kit/baseline/design-source/design-source-links.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/interaction-flow.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/screenshots/`
- `assets/templates/design-check-kit/baseline/acceptance-cases/design-acceptance-cases.md`
- `assets/templates/design-check-kit/baseline/source-doc-library/source-doc-library.md`
- `assets/templates/design-check-kit/report/design-acceptance-report.md`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template-notes.md`

Use them as the starting point whenever the user wants a new automated design acceptance kit.
