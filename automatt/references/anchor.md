# anchor — 每轮再锚（V2.025；≤1 屏，自含）

> 每轮开头真读本文件（工具调用，非记忆检查），缺读 = deviation。全文重读仅限：会话首轮 / compact·clear 后 / 版本不符 / 拿不准。

- **goal 续跑轮（V2.049）**：harness 自己续跑目标（`<goal_round>` / 「继续执行目标」/ 定时续跑）= **一轮新的 round** —— 重读本文件（工具调用）＋ 开头一行 `卡刷新｜lane=…｜正身=…｜下一步=…` ＋ 收尾**自己一条**中央条目（`触发=resume`）；续跑不是上一轮的尾巴，上一轮的条目归上一轮。
- **改名迁移（V2.054，只换接入点）**：开工前只看**接入点** —— 项目 `AGENTS.md` 里指向本 skill 的旧名（凭据行 `autopilot: on`、调用指引里的 `autopilot` / `/autopilot`）、本 skill 自己的指针目录 `.autopilot/`；是就本轮换成新名（`AGENTS.md` 里的旧名 → `automatt`、指针目录 → `.automatt/`，可枚举、git 可回滚 ⇒ 直接做），逐条列进条目；**`AGENTS.md` 之外的项目文件一律不动**（README/docs/脚本/配置/旧本名里的旧名是用户自己的文字），只当信息；只读轮不换，只给一行迁移提示；工作区之外不越界写。
- **必读集（V2.053）**：至少含 `references/conventions.md`（slug/文件布局/提交口径）与本文件 —— 晚读提交口径会在收尾时和「`.scratch` 进不进仓」打架。
- **轮卡**：首轮发完整开工卡（**六行、每行一个字段**：任务·slug·lane·档位 ｜ 本轮调用 ｜ 调用面 ｜ 分流（shield·Gate0·setup）｜ 正身·必读集 ｜ 链·产物·第一动作；字段与**排版**定义见 `SKILL.md` Round protocol，V2.050 起一行不挤两个字段、卡内不写 `**`、聊天端吞换行就整卡包围栏）；其后每轮以一行 `卡刷新｜lane=…｜正身=…｜下一步=…` 开场；新任务、新 slug、理解转动手 → 回 Step 0 重发全卡。
- **车道一行**：A=单行直接改＋per-class 门 ｜ B=spec 嵌 ≤3 切片＋红绿＋review ｜ C=map＋票图（`effort-flow.md`）｜ D=先建反馈环再修（`bug-flow.md`）｜ E=triage 后只做 ready 票。
- **档位**：默认 full；lite 五件地板（卡/车道/一个通道产物/验证一句/日志一行）缺一 = malformed；na 仅限纯理解·误触发·STOP（`self-answer.md`）。
- **纯理解/查询轮**：不碰仓库文件；四件最小产物 = 分流行 ＋ 检索面/命中计数（含负证据口径；**不抄命中内容**）＋ 对话内检索清单（`core-triggers.md` 只读节；本 build 无日志本）。**只读轮也是任务**：T0（ask-matt tool/inline）＋卡/刷新＋收尾条，缺一 = malformed；`lane=none` 不是免记理由（V2.036）。
- **没加载就别出卡（2.0.57，反伪造）**：开工卡 / 账本条目 / `本轮流程:` 三样都是**driver 加载之后**的产物。当轮必须有加载痕（`skill` 工具调 `automatt`，或 inline 读安装副本并记 `automatt=inline(read path:line)`）；**没有加载痕却出了这三样 = 伪造接管 = malformed**。自查一句话：卡上的 `正身:` 只列子 skill（**不写 `automatt`**）；`本轮流程:` 至少一个真调过的 skill 名（`(无子 skill 调用)`／`(none)`／空 = malformed）。发现自己正凭记忆或凭 `AGENTS.md` 模板写卡 ⇒ 停：要么去加载，要么按普通流程干、三样都不写。
- **收尾三件（V2.055）**：① `Skills called:` 按调用序；② 本轮 trace 三行（产物/deviation/审计；本 build 无日志本）；③ **最终回复的最后一行是 `本轮流程: …`**（与 `Skills called:` 同序同集合，只写 skill 名、不写 driver 名 / lane；只读轮与 STOP 轮同样要有）。`链` 与 `Skills called` 同序；删标记（单轮开闭照旧记豁免行）。

**你读到的正文可能不是最新版（V2.047）**：harness 加载的是**安装副本**（`~/.dsh/skills/<skill>`、`~/.codex/skills/<skill>`），不是开发仓里的源目录——两者不同步时，你会按旧规则干活却不自知。开发/验收语境下，开工前核对**本轮实际加载的正文版本行**与源仓 `VERSION`：不一致先同步（或明确记 deviation）。自检脚本：`node evals/check-install.mjs`（有安装副本落后即退出码 1）。
