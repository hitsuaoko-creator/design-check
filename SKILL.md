---
name: UI-check
description: Use this skill when the user wants automated UI design acceptance preparation, design review intake, or a reusable document structure for collecting design spec notes, design source links, and interaction-flow screenshots. This skill asks step by step questions, scaffolds the required files, and helps fill the documents before visual QA or design acceptance starts.
---

# UI-check

Use this skill to prepare a complete UI design acceptance package before implementation review, QA walkthrough, or release sign-off.

This skill is for intake and evidence collection. It does not replace the final visual audit by itself.

## Use This Skill For

- 自动化设计验收前的资料补齐
- 为页面或功能建立 UI 验收文档结构
- 收集设计稿链接、设计说明、交互链路截图
- 在设计走查前把缺失信息逐项问清楚
- 将零散输入整理成规范的 Markdown 文档

## Required Output Structure

Unless the user gives another location, use this default structure inside the target project:

```text
docs/ui-check/<feature-slug>/
├── design-spec/
│   └── design-spec.md
├── design-source/
│   └── design-source-links.md
└── interaction-flow/
    ├── interaction-flow.md
    └── screenshots/
```

The bundled template lives at `assets/templates/ui-check-kit/`.

If the target project does not already have the structure, create it by copying the bundled template or by running:

```bash
bash scripts/bootstrap_ui_check.sh /abs/path/to/project docs/ui-check/<feature-slug>
```

## Required Workflow

### 1. Lock the target

Ask for only the missing information.

Always identify:

- target project path
- page or feature name
- document root path

If the user does not provide a document root path, propose `docs/ui-check/<feature-slug>` and ask for confirmation.

### 2. Ask step by step, one question at a time

Do not ask a large batch of questions at once.

Use this order:

1. confirm the target page or feature name and document path
2. ask for the design source link or links
3. ask for the design spec summary that must be preserved in implementation
4. ask for the interaction path or user journey that needs screenshots
5. ask whether screenshots already exist and where they are stored

Only move to the next question after the previous answer is received or explicitly skipped.

### 3. Scaffold first, then fill

As soon as the target path is known:

- create the folder structure if it does not exist
- create or update the three required Markdown files
- preserve any existing user content

Do not leave the structure implicit in chat only. Materialize it in files.

### 4. Fill the required documents

Update the files with the user's answers.

Required file intent:

- `design-spec/design-spec.md`: page goals, mandatory UI constraints, states, acceptance focus
- `design-source/design-source-links.md`: Figma, MasterGo, prototype, handoff, related ticket links
- `interaction-flow/interaction-flow.md`: ordered flow steps, expected state per step, screenshot mapping, missing evidence

If an answer is missing, record it as `待补充` instead of inventing details.

### 5. Handle screenshots explicitly

The `interaction-flow/screenshots/` directory is required.

If screenshots are already available:

- ask for the exact file paths
- reference them from `interaction-flow.md`

If screenshots do not exist yet:

- list which screens still need capture
- write them into `interaction-flow.md`
- keep the `screenshots/` folder ready for later assets

### 6. Finish with a readiness summary

At the end, report:

- which files were created or updated
- which acceptance inputs are complete
- which items are still missing before a formal UI audit can start

## Output Rules

When using this skill:

- keep questions short and concrete
- ask one question at a time
- prefer editing files over leaving guidance only in chat
- do not fabricate design details
- preserve existing content and append or refine where possible

## Template Files

This skill ships with:

- `assets/templates/ui-check-kit/design-spec/design-spec.md`
- `assets/templates/ui-check-kit/design-source/design-source-links.md`
- `assets/templates/ui-check-kit/interaction-flow/interaction-flow.md`
- `assets/templates/ui-check-kit/interaction-flow/screenshots/`

Use them as the starting point whenever the user wants a new acceptance kit.
