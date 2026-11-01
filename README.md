[English](./README.en.md) | 简体中文

# automatt

> **改名说明**：本 skill 原名 `autopilot`，现更名为 `automatt`（同名易记、避免与其他 skill 撞名）；命令、启用凭据 `automatt: on` 与安装器同步改名。
>
> **升级后不用你手改**：V2.054 起，driver 只换**接入点**、不留过渡期——项目 `AGENTS.md` 里指向本 skill 的旧名（启用凭据行 `autopilot: on`、调用指引里的 `autopilot`）与 driver 自己的指针目录 `.autopilot/` 会在那一轮换成新名，并在条目里逐条列出改了哪些路径；**`AGENTS.md` 之外的项目文件（README/docs/脚本/配置）一律不动**（那是你的文字，我们不替你改），也不会因此新建第二本日志本。旧凭据行**不算已接入**——命中就换掉，换完照常干活。

**点一次，说句人话，剩下的全自动。** 一个包着 [mattpocock/skills](https://github.com/mattpocock/skills) 工作流（27 个子 skill）的全自动 driver：用户说一句日常人话（中英文都行），它就把整个任务自己做完——分流、打磨、写 spec、拆票、实现、红绿测试、双轴评审、验证交付，中途不需要人参与。

> **给谁用的**：想用这套工作流、但不会用的人。你不需要认识 27 个子 skill，也不需要知道什么时候该调谁——你只需要调这一个 skill，它会在需要时自动调用工作流里的 skill，新手直接用就行。

## 为什么需要它

裸 agent 在"自以为拿得准"的时候会跳步：直接开写、跳过打磨、忘了回归测试。这个 driver 把"质量靠自觉"变成"质量靠流程"：

- **每轮 T0 分流**——动手前先由 `ask-matt` 判定走哪条路。
- **正身优先**——已安装的子 skill 必须先加载再干活；速记版 fallback 只留给未安装的 skill。
- **自扫检查点**——每干完一段、每次红转绿、连续失败、设计分叉，都有 15 秒自扫。
- **评审与验证永不豁免**——每次改动都贴真实退出码的验证证据；宁可多花 token，不让人参与。
- **给不会写代码的人的交付**——每个任务收尾三件套：一句话改动说明 + 照着点就能验的手工清单 + 验证原文输出。

## 安装

> **一句话安装**：复制下面这段话发给你的 Agent，它会装好一切：
>
> ```
> 帮我装一下这个 skill：https://github.com/zkkk9555/automatt-skill
> 要求：driver（automatt）+ 上游 27 个工作流 skill 共 28 个必需项，一个不能少；
> 装到当前 harness 的用户级 skills 目录；上游新增的 skill 照单全收；
> 装完逐个确认这 28 个都在：automatt, ask-matt, code-review, codebase-design, diagnosing-bugs, domain-modeling, grill-me, grill-with-docs, grilling, handoff, implement, implement-spec, improve-codebase-architecture, pr, prototype, research, retro, setup-matt-pocock-skills, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-for-agents；缺哪个、装到哪了，告诉我。
> ```
>
> 上面这段话发给 Agent 即可安装。下面是给想自己动手的进阶内容，看不懂直接跳过。

<details>
<summary>进阶：前置说明与一键命令</summary>

本 driver 是指挥官，真正干活的是上游 27 个工作流 skill（[mattpocock/skills](https://github.com/mattpocock/skills)，MIT）。**从 V2.054 起，上游那 27 个已经随本仓一起分发**（`skills/` 目录，许可声明见 `THIRD-PARTY-NOTICES.md`）——你只需要去**一个仓库**拿齐 driver + 上游共 28 个，不用再去上游仓自己拼。上游更新时我们同步这一份快照即可。

bash（macOS / Linux / Git Bash）：

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.sh | bash
```

Windows PowerShell（若报执行策略错误，先跑 `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`）：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.ps1)))
```

默认装到 `~/.agents/skills/`（DeepSeek Harness 读这个目录）；脚本会自动探测当前 harness，命中且唯一时多写一份（支持 claude / codex / cursor / opencode / zcode / dsh / workbuddy）。装完**必须去工具里确认 skill 列表出现了 automatt**。常用变体：`--harness dsh` 指定 harness，`--ref 2.0.56` 装指定版本（**默认就钉在当前版本 tag 上**，所以「我装的是哪一版」有答案），`--dry-run` 预览，`--slim` 只要 driver，`--dir` 自定义目录，`--uninstall` 卸载。怕装错？先 `--dry-run` 预览。

</details>

<details>
<summary>进阶：其他装法（npx / 插件市场 / 手动）</summary>

- `npx skills`（备选）：`npx skills@latest add zkkk9555/automatt-skill -g -a zcode -y`（`-a` 换 claude-code|codex|cursor）。上游 27 个已在本仓 `skills/` 里，按需一并取。注意它按 harness 分目录装。
- Claude Code 插件市场：`/plugin marketplace add zkkk9555/automatt-skill` 后 `/plugin install automatt`（**只含 driver**；上游 27 个请用上面的安装脚本补齐）。
- 手动（未知 harness）：找你的 skills 目录 → clone 本仓 → `automatt/` 与 `skills/*` 各自拷过去（`skills/` 下每个子目录就是一个 skill）→ 验证 28 个 → 重启说“切换按钮失效了，去检查修一下”。
- 目录对照：`~/.agents/skills/`（ZCode/Cursor/OpenCode/DeepSeek Harness 等）|`~/.dsh/skills/`（DeepSeek Harness）|`~/.zcode/skills/`（ZCode）|`~/.claude/skills/`（Claude Code）|`~/.codex/skills/`（Codex）|`<项目>/.agents/skills/`（仅当前项目）。没有任何目录是全宇宙通用的，装完必须确认。

</details>

## 使用

**先启用要用的项目**（默认关闭）：在该项目的 `AGENTS.md` 里加独占一行 `automatt: on`（删掉该行、或改成 `automatt: off` 即关闭）。任何时候说一句「用 automatt 做 X」或 `/automatt` 都能强制接管，不需要凭据。

像说话一样说一次就够：

- 切换按钮失效了，去检查修一下。
- 给我加个新的小按钮，点一下能实现 XX，要稳定好用。
- 我想做个 XX 小项目。

driver 自己选路：报错/症状 → 先建反馈环再修的 bug 流；小功能 → 打磨 → spec → 红绿 → 双轴评审；大雾项目 → 先访谈画图、分阶段推进。只有删数据、花钱、对外发布这类高危动作才会停下来等你拍板。

## 状态与贡献

> 本 skill 处于**早期开发阶段**，还可能存在触发时机不准、子 skill 衔接不顺之类的问题。欢迎：
>
> - 在 [Issues](https://github.com/zkkk9555/automatt-skill/issues) 提交问题（附上你的使用场景和 driver 的实际行为）。
> - 在 [Pull Requests](https://github.com/zkkk9555/automatt-skill/pulls) 提交修复（基于 `main` 分支）。
>
> 任何反馈都有帮助——正是来自真实使用的反馈，才推动了从 V2.001 走到现在。

## 版本

单一版本号 `V2.00N`，见 [`automatt/CHANGELOG.md`](./automatt/CHANGELOG.md)。

## 许可

MIT，见 [LICENSE](./LICENSE)。
