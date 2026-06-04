---
name: design-check
description: Use this skill when the user wants to automate UI design acceptance against a source documentation library, or explicitly says `设计验收`. This skill first collects `design-spec.md`, design source files, optional interaction screenshots, then drafts acceptance cases from the template and generates a design acceptance report against the source documentation library.
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
- `design source files`
- `interaction-flow screenshots` (optional)
- `design acceptance cases`

The acceptance target must also be defined:

- `source repository name`
- `source documentation library location`

If any baseline item is missing, ask only for the missing item and write it into the corresponding file.

## Required Output Structure

Unless the user explicitly asks for another location, use this default structure in a separate folder under `~/Documents/Playground`. By default, name the artifact folder `设计验收YY.MM.DD` using the current local date:

```text
~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/
├── materials/
│   ├── user-provided/
│   └── ai-generated/
├── baseline/
│   ├── design-spec/
│   │   └── design-spec.md
│   ├── design-source/
│   │   └── design-source-files.md
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

If the default artifact folder does not already have the structure, create it by copying the bundled template or by running:

```bash
bash scripts/bootstrap_design_check.sh ~/Documents/Playground design-check-artifacts/设计验收YY.MM.DD
```

## Required Workflow

### 0. Handle repeated triggers in the same agent conversation

If this skill is triggered again in the same agent conversation, do not immediately resume asking for materials.

Ask the user to choose exactly one option first:

1. `进入新的设计验收`
2. `继续上一轮验收`

After the user replies with `1` or `2`, continue as follows:

- if the user chooses `1`, start a new design acceptance run from the beginning and return to step 1 of this workflow
- if the user chooses `2`, continue the previous design acceptance run from its current state, reusing the existing artifact root and already collected materials

Do not start a new run or continue an old run until the user has explicitly chosen `1` or `2`.

### 1. Collect baseline materials first

Ask for only the missing information.

Use this order:

1. ask for `design-spec.md` first
2. ask for the design source file or files second
3. ask for interaction-flow screenshots third
4. draft `design-acceptance-cases.md` from the bundled template fourth

The first required follow-up question is:

- `请提供 design-spec.md，或者把 design spec 内容贴给我。`

At this stage, do not start by asking for the repository name.

At this step, do not ask bundled follow-up questions in the same message. Wait for the user to reply with the requested material only, then continue.

If a feature name is not yet known, infer it from the design spec when possible. If it still cannot be inferred, ask for the page or feature name only after receiving the design spec.

The feature name should be recorded inside the baseline documents. Do not use it as the default artifact folder name unless the user explicitly asks for that naming scheme.

### 2. Create the artifact folder early

As soon as the artifact root is known:

- create `~/Documents/Playground/design-check-artifacts/设计验收YY.MM.DD/`
- create or update all baseline files, report files, and materials folders there
- preserve any existing user content

All user-provided files, copied evidence, and AI-generated outputs must live under this artifact root.

### 3. Ask step by step, one question at a time

Do not ask a large batch of questions at once.

Use this order:

1. ask for `design-spec.md`
2. ask for the design source file or files
3. ask for the interaction-flow screenshots and explicitly say they are optional
4. if screenshots are not provided, switch the audit mode to `视觉验收`
5. fill `design-acceptance-cases.md` from the bundled template based on the materials already collected
6. ask for the source repository name
7. after the repository name is received, auto-locate the project path
8. only if the path is ambiguous or not found, ask one clarification question
9. ask for the source documentation library path or paths
10. confirm the acceptance scope only if it is still unclear

Only move to the next question after the previous answer is received or explicitly skipped.

### 4. Scaffold first, then fill

As soon as the artifact root is known:

- create the default artifact folder structure if it does not exist
- create or update the baseline files, materials folders, and the report file
- preserve any existing user content

Do not leave the structure implicit in chat only. Materialize it in files.

### 5. Fill the baseline materials

Update the files with the user's answers.

Required file intent:

- `baseline/design-spec/design-spec.md`: page goals, mandatory UI constraints, states, acceptance focus
- `baseline/design-source/design-source-files.md`: design file paths, links, frame identifiers, export packages, related source references
- `baseline/interaction-flow/interaction-flow.md`: ordered flow steps, expected state per step, screenshot mapping, or a visual-only note when screenshots are absent
- `baseline/acceptance-cases/design-acceptance-cases.md`: template-based acceptance checks drafted from the design materials, expected result, pass criteria, priority
- `baseline/source-doc-library/source-doc-library.md`: source repository name, diff-source purpose, resolved project path, doc root, source files, entry points, excluded paths
- `materials/user-provided/`: copies, references, or manifests of files provided by the user
- `materials/ai-generated/`: generated acceptance cases, reports, and other AI-produced artifacts

If an answer is missing, record it as `待补充` instead of inventing details.

### 6. Handle screenshots explicitly

The `baseline/interaction-flow/screenshots/` directory is required even when screenshots are optional.

If screenshots are already available:

- ask for the exact file paths
- reference them from `interaction-flow.md`
- copy or index them under the artifact root when practical

If screenshots do not exist yet:

- mark the audit mode as `视觉验收`
- write that the interaction evidence was not provided
- keep the `screenshots/` folder ready for later assets

### 7. Check baseline completeness

Before generating the acceptance report, verify whether the baseline is complete enough.

Minimum condition to proceed:

- source repository name is known
- source documentation library location is known
- design spec is present
- design source file is present
- at least one acceptance case is present

Interaction-flow screenshots are optional. If they are absent, proceed in `视觉验收` mode and record that limitation in the report.

If the minimum condition is not met:

- stop the audit stage
- list the missing items
- keep the report file in `blocked` state

### 8. Run the acceptance review against the source documentation library

When the minimum condition is met:

- read the source documentation library files in scope
- compare them against the baseline materials
- evaluate each acceptance case against the source documentation library
- identify matched, missing, inconsistent, and blocked items
- generate `report/design-acceptance-report.md`
- follow the bundled report template structure at `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- explicitly label the audit mode as either `视觉验收` or `视觉+交互验收`

The report must focus on whether the source documentation library reflects the baseline, not whether the baseline itself is ideal.

### 9. Produce the acceptance report

The report must follow the bundled design acceptance checklist template.

If the current environment can write spreadsheet outputs, also generate `report/design-acceptance-report.xlsx` based on the bundled template.

If the current environment cannot write spreadsheet outputs, generate a Markdown report that preserves the same field order and semantics as the spreadsheet template.

The report must contain:

1. target summary
2. baseline completeness
3. audit mode
4. source documentation library scope
5. acceptance case results
6. findings and gaps
7. blocked or unclear items
8. next actions

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
- keep all materials under the default artifact root unless the user explicitly requests another location

## Template Files

This skill ships with:

- `assets/templates/design-check-kit/baseline/design-spec/design-spec.md`
- `assets/templates/design-check-kit/baseline/design-source/design-source-files.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/interaction-flow.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/screenshots/`
- `assets/templates/design-check-kit/baseline/acceptance-cases/design-acceptance-cases.md`
- `assets/templates/design-check-kit/baseline/source-doc-library/source-doc-library.md`
- `assets/templates/design-check-kit/materials/user-provided/`
- `assets/templates/design-check-kit/materials/ai-generated/`
- `assets/templates/design-check-kit/report/design-acceptance-report.md`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template-notes.md`

Use them as the starting point whenever the user wants a new automated design acceptance kit.
