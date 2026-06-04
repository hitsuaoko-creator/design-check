# design-check

`design-check` 是一个通用型、与具体平台无关的 agent skill，用于自动化做 UI 设计验收。

适用范围包括：

- Codex
- Cursor
- Claude Code
- Antigravity
- Trae
- 其他支持 agent、prompt skill、slash command 或工作区指令的环境

这个 skill 的目标是围绕“源码文档库”完成一整套自动化设计验收流程。

## 这个 Skill 做什么

`design-check` 分成两个阶段：

1. 补齐设计验收基线材料
2. 基于源码文档库生成设计验收报告

设计验收基线包括：

- design spec
- 设计源文件链接
- 交互链路截图
- 设计验收用例

设计验收对象包括：

- 源码仓库名称
- 源码文档库位置

内置的设计验收报告模板物理路径为：

- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`

## 验收对象

真正被验收的对象是目标项目中的“源码文档库”，而不是对话本身。

这里的源码文档库可以包括：

- 文档目录
- 交付说明文档
- UI 的 source-of-truth 描述文件
- 用户指定的功能说明或实现文档路径

最终报告要回答的是：源码文档库是否准确反映了设计验收基线。

## 默认输出结构

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

## 仓库结构

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

## 内置模板

- `assets/templates/design-check-kit/baseline/design-spec/design-spec.md`
- `assets/templates/design-check-kit/baseline/design-source/design-source-links.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/interaction-flow.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/screenshots/.gitkeep`
- `assets/templates/design-check-kit/baseline/acceptance-cases/design-acceptance-cases.md`
- `assets/templates/design-check-kit/baseline/source-doc-library/source-doc-library.md`
- `assets/templates/design-check-kit/report/design-acceptance-report.md`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template.xlsx`
- `assets/templates/design-check-kit/report-template/design-acceptance-checklist-template-notes.md`

## 如何在不同工具中使用

对于支持原生 skill 机制的平台：

- 直接把 `SKILL.md` 作为 skill 入口文件使用

对于不支持原生 skill 机制的平台：

- 使用 `AGENT-SPEC.md` 作为通用 agent 指令
- 或者把其中规则复制到自定义 prompt、slash command、workspace instruction 中

`agents/openai.yaml` 只是给支持界面化 skill 注册的平台准备的元数据，不是核心流程依赖。

## Slash Command 安装

这个仓库已经内置了可安装的 slash command 文件：

- Cursor：`.cursor/commands/design-check.md`
- Claude Code：`.claude/commands/design-check.md`

安装到目标代码仓库：

```bash
bash scripts/install_slash_commands.sh /abs/path/to/project both
```

如果只装单个平台：

```bash
bash scripts/install_slash_commands.sh /abs/path/to/project cursor
bash scripts/install_slash_commands.sh /abs/path/to/project claude
```

安装时还会把支撑文件复制到：

```text
.design-check/
├── AGENT-SPEC.md
└── design-check-kit/
```

安装完成后，你可以在聊天输入中直接触发：

- Cursor 里输入 `/design-check`
- Claude Code 里输入 `/design-check`

触发后会立刻进入“引导式资料补齐”对话，不需要你再补一句说明。

如果“源码仓库名称”还没给，第一句要求的追问是：

- `请告诉我你的“源码仓库名称”。`

这个问题的目的是帮助定位待测 diff 源。

如果源码仓库名称已经给了、但项目路径还没给，下一句要求的追问是：

- `对应项目的路径是什么？`

如果项目路径已经给了，代理就应该直接开始问下一个缺失项。

## 安装方式

安装到默认的 Codex skills 目录：

```bash
bash install-skill.sh
```

安装到自定义目录：

```bash
bash install-skill.sh /path/to/skills-root
```

如果你不用 Codex，也仍然可以直接复制这个仓库，或者只复用其中的 `SKILL.md`、`AGENT-SPEC.md` 和模板文件。

## 初始化资料结构

在目标项目中生成设计验收目录结构：

```bash
bash scripts/bootstrap_design_check.sh /abs/path/to/project docs/design-check/login-page
```

## 预期工作流

代理应按下面顺序工作：

1. 如果还不知道“源码仓库名称”，先在对话中问：`请告诉我你的“源码仓库名称”。`
2. 这个问题的目的，是帮助定位待测 diff 源
3. 如果源码仓库名称已经知道、但项目路径还不知道，再问：`对应项目的路径是什么？`
4. 用户只回复项目路径后，再确认功能名、文档路径、源码文档库路径
5. 询问设计源文件链接
6. 询问 design spec 摘要
7. 询问交互链路和截图
8. 询问设计验收用例
9. 回填基线材料文件
10. 检查基线材料是否足够完整
11. 读取源码文档库
12. 按内置验收模板结构生成设计验收报告

代理应该一次只问一个问题，并且只追问缺失信息。

如果源码仓库名称还没给到，代理不应该自己猜。项目路径也一样，不应该自己猜，而应该先等开发或用户回复。

## 触发示例

- `Use $design-check to automate design acceptance for the login page against the source documentation library.`
- `Use $design-check, ask me step by step questions, complete the baseline materials, then generate the design acceptance report.`
- `Use $design-check to scaffold docs/design-check/payment-result and review the source documentation library against the design baseline.`
- `设计验收`

典型对话起手可以是：

- 用户先说：`设计验收`
- 代理追问：`请告诉我你的“源码仓库名称”。`
- 用户回复一个仓库名
- 代理再追问：`对应项目的路径是什么？`
- 用户只回复一个路径，例如：`/Users/name/workspace/project/web`

## 关键文件说明

- `SKILL.md`：skill 的触发条件与代理执行流程
- `AGENT-SPEC.md`：通用 agent 集成说明
- `scripts/bootstrap_design_check.sh`：用于初始化验收目录结构
- `scripts/install_slash_commands.sh`：用于安装 slash command 到目标仓库
- `install-skill.sh`：用于安装到 Codex skills 目录

## 说明

- 这个 skill 的定位是“自动化设计验收”，不只是资料收集。
- 如果基线材料不完整，报告应保持 `blocked` 状态，并明确列出缺失项。
- 如果当前环境支持表格输出，也可以基于内置模板额外导出 `design-acceptance-report.xlsx`。
