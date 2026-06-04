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
- 设计稿源文件
- 交互链路截图（可选）
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
~/Desktop/design-check/<feature-slug>/
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
│           ├── materials/
│           ├── report/
│           └── report-template/
├── scripts/
│   └── bootstrap_design_check.sh
└── install-skill.sh
```

## 内置模板

- `assets/templates/design-check-kit/baseline/design-spec/design-spec.md`
- `assets/templates/design-check-kit/baseline/design-source/design-source-files.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/interaction-flow.md`
- `assets/templates/design-check-kit/baseline/interaction-flow/screenshots/.gitkeep`
- `assets/templates/design-check-kit/baseline/acceptance-cases/design-acceptance-cases.md`
- `assets/templates/design-check-kit/baseline/source-doc-library/source-doc-library.md`
- `assets/templates/design-check-kit/materials/user-provided/.gitkeep`
- `assets/templates/design-check-kit/materials/ai-generated/.gitkeep`
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

如果功能名称已经知道，agent 应尽早创建桌面产物目录，并把用户提供和 AI 产出的材料都放进去。

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

在桌面上生成设计验收目录结构：

```bash
bash scripts/bootstrap_design_check.sh ~/Desktop design-check/login-page
```

## 预期工作流

代理应按下面顺序工作：

1. 先要 `design-spec.md`
2. 再要设计稿源文件
3. 再要交互链路截图，并明确说明这是可选项
4. 如果没有截图，就切到 `视觉验收` 模式
5. 基于模板生成 `design-acceptance-cases.md`
6. 再问源码仓库名称
7. 收到仓库名后，在当前工作区或已挂载项目根目录中自动定位本地项目路径
8. 如果只找到一个唯一匹配路径，就继续，不要再问用户路径
9. 如果找到多个可能路径，就问一个消歧问题
10. 如果完全找不到路径，再回退去问用户项目路径
11. 询问源码文档库路径
12. 把基线文件和材料目录都落到桌面产物根目录下
13. 检查基线是否足够完整
14. 读取源码文档库
15. 使用内置清单模板结构生成设计验收报告

代理应该一次只问一个问题，并且只追问缺失信息。

代理不应该凭空猜项目路径或设计细节。交互截图是可选项；如果没有提供，报告里必须明确写出这次只做了视觉验收。

## 触发示例

- `Use $design-check to automate design acceptance for the login page against the source documentation library.`
- `Use $design-check, ask me step by step questions, complete the baseline materials, then generate the design acceptance report.`
- `Use $design-check to scaffold ~/Desktop/design-check/payment-result and review the source documentation library against the design baseline.`
- `设计验收`

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
