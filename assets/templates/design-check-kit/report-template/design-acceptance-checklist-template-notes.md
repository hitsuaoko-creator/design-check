# Design Acceptance Checklist Template Notes

This file explains how to use the bundled spreadsheet template:

- `design-acceptance-checklist-template.xlsx`

## Template Source

- Original source imported into this skill from: `/Users/chang/Desktop/设计验收走查文档.xlsx`
- Bundled skill path: `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

## Sheet Structure

Observed sheet title:

- `工作表1`

Observed checklist columns:

1. `验收时间`
2. `问题类型`
3. `问题描述`
4. `问题截图`
5. `预期截图`
6. `发现人`
7. `跟进人`
8. `开发修复状态`
9. `验收状态`
10. `备注`

## Output Rule

When generating a design acceptance report:

- use the spreadsheet template as the field-level source of truth
- keep the same column order and semantics
- if spreadsheet output is supported, generate an `.xlsx` report from this template
- if spreadsheet output is not supported, generate Markdown with an equivalent table using the same fields

## Recommended Mappings

- `问题类型`: usually `UI问题`, `交互问题`, or another user-defined issue category
- `问题截图`: actual implementation evidence path or screenshot reference
- `预期截图`: design-source or expected-state evidence path
- `开发修复状态`: e.g. `开发待解决`, `修复中`, `已修复`
- `验收状态`: e.g. `YES`, `NO`, `BLOCKED`
