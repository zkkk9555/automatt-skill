# Core triggers — 8 个常用 skill 什么时候必须调

> SKILL.md 触发表只负责指路，这张表负责拍板。每个核心 skill 一条：入口条件（什么时候必须调）+ 产物约定（调完必须留下什么）+ 跳过即 malformed（什么情况下算漏调）。剩下的 17 个走文末四问模板，不要凭感觉。

读法：先看入口条件，命中就调；调完对照产物约定，缺产物等于没调；明明命中却没调，JOURNAL 里要写 deviation + 下轮纠正。8 核心之外：新转正的 `implement-spec`/`pr`/`retro` 走下节专节，剩下的 19 个走文末四问模板，不要凭感觉。

## 8 core

- **`grill-with-docs`** — 入口（开局专用）：想法还模糊，有工作目录可以留痕（要改仓库里的东西、需求超过一句话能说清）。产物：打磨后的结论进 `spec.md` 或 `NOTES.md`，模糊点收敛到可写的程度。不调即 malformed：带着模糊需求直接写 spec/拆票。中途（已进 ticket/implement/resolve 上下文）一律用裸 `grilling`，调 `grill-with-docs`/`grill-me` = malformed（user-invoked 互调，见编排铁律 + 中途 grill 专节）。
- **三个 grill 的真实分工（V2.051：「调不动」不是跳过的理由）**：`grill-with-docs` 的正文就是「调 `grilling` + `domain-modeling`」，`grill-me` 的正文就是「调 `grilling`」——**它们是包装，不是另一种能力**。DSH 遵守 `disable-model-invocation`，用 Skill 工具调这两个会被拒（`not available for model invocation`）⇒ **直接调 `grilling`（需要 ADR/词表时再加 `domain-modeling`）就等价**，不必 inline 读它们的正文，也不构成「user-invoked 互调」（V2.030 已明确：inline 读正身属「读数据」）。**实测（r19/r20 共 20 轮）：只有 2 轮真烤过（都在 Lane B），其余多轮是「user-invoked 调不动 ⇒ 省了」** —— 这就是「grill 系列几乎看不到」的真实原因，不是 taste 问题。
- **烤多深按赌注分档（V2.051，用户现场诉求）**：现行只有轮次**上限**（软 4/硬 6），没有**下限** ⇒ 烤一轮就收工 ⇒ 做出来「字面满足」但真实场景一用就露馅。按赌注定档：
  | 档 | 什么算 | 轮次下限 | 必问清单（缺一项 = 没烤透） |
  | --- | --- | --- | --- |
  | 低 | 单行 typo/doc、可逆、只影响本机、不进真实流程 | 0（写一句跳过理由） | — |
  | 中 | 新功能/一个模块/改既有行为，可回滚、影响面可控 | ≥2 轮 | 边界值 / 失败会怎样 / 要不要留痕 |
  | **高** | **会被真实使用**（上线/交付给他人/长期维护）、**不可逆**（迁移/删数据/改对外接口）、**对外可见**（发布/改契约） | **≥4 轮**（软上限提到 8） | **真实场景五问**：①谁在什么场景用、数据是不是脏的 ②并发/重复提交/离线怎么办 ③失败路径长什么样、怎么发现 ④怎么撤销回滚、谁来撤 ⑤以后怎么扩展、这次写法会不会挡住下一个人 |
  **「我会长期用/给别人用/上线了」＝高赌注**，哪怕代码只有几十行 —— 不许按「改动小」降档。
  **删除分两档（V2.052）**：**可恢复**的删除（版本控制内、范围可枚举、能回滚）＝**中赌注**（≥2 轮即可）；**不可恢复**的删除/数据迁移＝高赌注（≥4 轮）。烤便宜活儿是浪费，烤不起 irreversible 才是事故。
- **「我不清楚要什么」的诉求（V2.051）**：用户给的是**目标或症状**而不是可执行需求（「做得更可靠点」「像个产品」「以后好扩展」「长期用」）⇒ 需求本身就得烤：**先烤出可判定的成功标准**（什么算做到了、能怎么验），再烤实现。这种轮**不许跳过 grill 直接写 spec**；烤出来的验收标准必须能落成「红→绿」的命令或断言，否则只是漂亮话。
- **grill→prototype 出口（V2.012，作者主循环）**：grill 中遇到 ungrillable 问题（手感/外观/状态机行为——"how should it look / how should it behave 是关键问题"，聊天答不上来）→ handoff 开原型会话 → 跑完 handoff 回来继续 grill。低保真问题（URL 放哪、字段叫啥）聊天答；高保真问题非跑起来看不见，硬烤 = malformed。
- **`to-spec`** — 入口：要动手写代码/改数据，且还没有可照着做的 spec。产物：`.scratch/<slug>/spec.md`（Problem/Solution/User-Stories/Implementation/Testing/Out-of-Scope/Glossary/Notes + `Checks:` 三行）。不调即 malformed：无 spec 直接 implement。
- **`to-tickets`** — 入口：spec 里超过 1 个可独立演示的行为，或跨文件、跨系统、有先后顺序。产物：`issues/NN-<slug>.md`（What-to-build/Anchors/Blocked-by/Status/验收项），blocker 在前。不调即 malformed：大活一锅烩在一个 ticket 里做。
- **`implement`** — 入口：有 `ready-for-agent` 的票。产物：票对应的代码改动，一票一改，ticket 内写清改了哪里。Lane B 1–3 个 slice 可直接嵌在 spec 里不拆票。不调即 malformed：绕过 ticket 直接改（Lane A 单行 typo/doc 除外）。
- **`tdd`** — 入口：每次 implement 里吞下一个 seam（可断言的行为点）之前。产物：先红后绿（红：失败输出 + 退出码；绿：同样命令通过），seam 写在 Testing Decisions 里。不调即 malformed：先写实现后补测试，或无红直接绿。
- **`code-review`** — 入口：每次提交之前（Lane A 单行 typo/doc 除外）。产物：Standards + Spec 双轴结论，hard violation（红构建、红线 breach、行为与 spec 相反）必须修，smell 只记录。不调即 malformed：未经 review 直接 commit。
- **`diagnosing-bugs`** — 入口：有报错、有必现/偶现症状、有用户原话（症状文本本身就算一条，哪怕没给复现路径），有复现路径或出错位置更好，任中其一。产物：Phase-1 反馈环先行（同一命令在当前 bug 上变红、修完变绿，断言代码缝，不编用户操作路径）+ `NOTES.md` 诊断过程，见 `references/bug-flow.md`。不调即 malformed：没建反馈环就 theorising 修 bug；零信息指连症状都没有（比如光说"修一下那个 bug"），才写 `BLOCKED.md`/`NEEDS-HUMAN.md` 先要信息。
- **`wayfinder`** — 入口：同时满足三条才进：(a) 现在写不出所有 ticket 的 Anchors+verify，(b) 决策链看不见（先画出来才知道先后），(c) 还没有指向这个目标的 map。产物：`map.md` + 决策票。well-scoped 的活（Lane B 现在就能写票）永不进，不调不算错，进错了（该 B 的画了 map）算浪费要在 trace 里记。

## 执行形态与收尾：implement-spec / pr / retro（V2.021，上游转正跟进）

- **`implement-spec`** — 入口：票图已成、frontier 有 ≥2 可并行、要落在单一集成分支（Lane C 执行轮）。产物：集成分支 + 每票按 tracker 规则关闭 + 集成后一次 `code-review`。产物另含探索记录＋清理证据（worktree list空）＋单整合PR；顺序锁死全完→code-review→PR，无review直PR = malformed。单票/逐票亲驾仍走 `implement`（fresh context per ticket）。选错形态（该并行的逐票串行拖死、该单票的起重型集成）= deviation。编排：`implement-spec` 是 user-invoked，driver 可调；其内只许调 model-invoked（`tdd`、`code-review`），不许再调 user-invoked（见编排铁律）。
- **`pr`** — 入口：要开 PR（含 `implement-spec` 的 draft PR）。产物：PR 正文按上游模板（最小可视化 + before/after 证据 + 单/双向门 + blast radius），用 `GLOSSARY.md` 词汇。Evidence必须真跑before/after（测试输出/截图/数据），口头不算；Blast Radius独立写一行。PR 正文缺证据或缺门判断 = malformed。pr永不替代code-review，仅有pr无review即malformed。`pr` 是 model-invoked，任何上下文可调。
- **`retro`** — 入口：一次构建收尾，尤其跑偏之后（P0/返工/整轮作废）。产物：环境候选（导航/检查/规范/steering/工具），按上游7分类（导航/检查/规范/AGENTS/工具经济/no-ops/信息）＋token证据摆给用户，不直接改代码；修走STOP禁auto-fix。跑法：本会话 clear 之前在当会话跑；clear 之后凭该会话记录回看。跑偏构建无复盘 = malformed。

## 剩下 19 个的四问模板

命中核心 8 个之外，先问四问再定：

1. 有没有工作目录可留痕？没有 → `grill-me`（无目录打磨）或 `grilling`（还要零副作用、一次性、无 carry-over 才用 bare primitive）。本条只定开局路由；中途（已进 ticket/implement/resolve）一律裸 `grilling`，见中途 grill 专节（V2.018）。
2. 要不要查外部事实？要 → `research` 丢给后台，继续手头活。
3. 要不要跑个一次性验证？要 → `prototype`（网页看 UI/状态机看 LOGIC/引擎看 headless 数字时间线），`handoff` 双向摆渡。**入口放宽（V2.012）**：不只"两方案争执"，"how should it look / how should it behave 是关键问题"就跑——wayfinder 的 prototype 票种同理，关键问题需高保真答案时默认放一张 prototype 票。
4. 是不是人墙/边界？发版花钱 credential 合规 → `wizard` 先 scope 后 STOP；跨目录/同事或版本级换 harness（见 handoff 版本交接包） → `handoff`；等别人脑子里的答案 → `to-questionnaire`（具名收件人 + 问题 + 回填钩子）；词含糊 → `domain-modeling`；两实现打架/缝错层 → `codebase-design`；闲时巡检 → `improve-codebase-architecture`（只建议不改，**产出 deepening 候选必须落 issue 等人拍板，不许 driver 自答拍板**——作者原话：人是 strategic programmer，agent 是 tactical）；**该 skill 正文要求出 temp HTML 报告/派子代理/让用户挑一个，与 `delivery-check.md:17`「HTML 看板不建」和「全程不问人」相反——本 driver 一律以其为准：只读巡检轮出对话内分级清单 + file:line，不建 HTML 看板、不派子代理、不问人，把降级写进 `deviation:`**（V2.044 现场：r7 s10 / r11 s10 / r13 s10 三次记下同一条互斥）；第一次进仓 → `setup-matt-pocock-skills`（一次）；学东西 → `teach`；话没说明白 → `wait-what`；写 agent 文档 → `writing-for-agents`；一堆 raw 输入 → `triage`（见 triage 全套规则，永不 triage `to-tickets` 的输出）。

## handoff 版本交接包：版本级换 harness（V2.013）

用户说"换个地方做下一版""去 Codex 继续""回来接着做 006"这类话 → 调 handoff 生成**版本交接包**，不是轮次内搬运：当前版本交付了什么、decisions（含出处）、待办（含阻塞）、建议 skill（下个版本开局该调谁）。文档落系统临时目录，路径告诉用户；**不自动开新对话**——handoff 只写信不送信，新对话用户自己开、文档自己粘。回来时同一套：交接包写清"从哪回来、带回什么"，落地后按包内待办继续。

跟作者用法的区别：作者是一轮内来回搬两三次（grill→prototype→grill），这里是版本之间搬一次——频率低，单次价值更高（版本交接丢的东西比轮次交接多得多）。

## triage 全套：状态机 + brief + out-of-scope（V2.012，作者视频 + 正身）

Lane E（raw pile）进 lane 前先走 triage 状态机，不是直接开干：

- **双标签**：每票恰好一 category（bug/enhancement）+ 一 state（needs-triage/needs-info/ready-for-agent/ready-for-human/wontfix）。标签串以 setup 落的 `docs/agents/triage-labels.md` 为准。
- **ready-for-agent 必须附 brief**：光改标签不算 ready——brief 写清做什么、锚点、验收（见上游 AGENT-BRIEF.md 精神）。无 brief 的 ready = malformed。implement 只认"标签+brief 双全"的票。
- **out-of-scope 目录**：拒绝过的 enhancement 写进 `.out-of-scope/`（一事一记），下次同类请求命中直接 wontfix，不重审。已实现的东西不进这个目录（那是 HIT，不是拒绝）。
- **triage→diagnosing-bugs 衔接**：triage 出的 bug 票必须独立复现一遍——**不轻信 reporter 结论**（作者原话），复现步骤自己重做，复现证据进 brief。
- **spec 审计定位（V2.012，作者"spec 用完"精神）**：spec 冻结为基线后不再改（V2.009 已有），审计只看 issues + CHANGELOG，不回看 spec——spec 是目的地文档，不是活档案。证据链不断（issues 全链），但 spec 本体封存。

## 纯理解任务：不进 lane（V2.005，不改仓，不建标记，不计工程轮）

**带症状的诉求不是只读轮（V2.053）**：用户报了**具体症状**（「这个月总额少了一分钱」「点��没反应」「导出少一列」）⇒ 这是**修复轮**（Lane D：先建反馈环再修），**不是**「帮我看看」那种只读查询；只读轮的前提是**没有可观测的错误**。判据：诉求里有没有一个**能被复现的对/错**？有 ⇒ Lane D；没有（只是问「有什么问题/值得改进」）⇒ 只读轮。**顺序（V2.033）**：setup 只允许在**首个工程轮、任何实现动作之前**运行，不写 spec，不碰仓库文件，不建 WORKFLOW-ACTIVE，不计工程轮次。**「这个项目有什么值得改进 / 有什么问题 / 帮我巡检 / 体检一下」＝只读清单请求**：给分级清单与 file:line 证据，不动文件；用户说「改 / 修 / 做 / 顺手」才另起工程轮（V2.037 现场：同一句巡检问法，round1 只读出清单、round5 直接动手改了 3 个文件还建了仓库）。做法：T0 分流判无 lane → 通读 ground-truth（README/入口/配置）→ 可派一个 Explore 子代理扫全仓 → 对话内给理解报告。setup 的首次进仓也不触发，等首个真实工程轮再做。只读轮无 verify 可贴，按 delivery-check 精神给零改动声明 + 可抽查清单。

**只读/查询轮最小协议（V2.025，四件；V2.036 补硬门）：** ①首段=开工卡/卡刷新（无 lane 轮照发，含 T0 downshift 声明）；②分流行：一句分类（纯理解/查询/外部事实/混合）——含「处理意图」判据（「很久没处理 / 该跟进 / 看看新动静」＝要动手的事项，先审 Lane E 或按项目流程另起工程轮）；③证据行：写明查过哪些面（水位线区/archive/JOURNAL/git log/README…），命中给 `file:line`；「看有没有」类强制负证据口径（N 面 × 零命中，`trace-discipline.md` V2.011）；④收尾在对话内给检索清单（产物=检索面 + 命中计数 + 零改动声明；偏差按档位语法；只写 skill 侧；本 build 无日志本）。产物只落对话，不碰仓库文件。⑤ **最终回复最后一行必须写 `本轮流程: …`**（V2.055，与条目 `链:` 同序同集合；只读轮免写 NOTES，但这一行照写）——聊天里一眼看出这轮走了哪条链。用户点名的历史检索不受「中间历史不读」约束（点名即解锁定向 grep）。

**只读轮的检索面字段（V2.041）**：条目里用 `检索面: <面清单>｜命中=<n>｜零改动=<是|否>` 一行承载「查过哪些面 + 命中计数」，不要自造别的字段名；`产物:` 写 `ask-matt(inline)=对话内报告`（无路径，不受 `test -f` 约束）。

**只读轮的三处合法落点（V2.039，别再每轮重新发明）：** ①开工卡（含 `正身：…｜必读集：…` 行）在对话里——只读轮不写 NOTES，卡就是卡本身；②`审计:` 指 `.scratch/<slug>/audit.log`（driver 自有审计日志，不算仓库文件，路径真实存在）；③`Skills called:` 锚点 = 最终消息里一行 + 条目内同序 `链:`。三处都不算「碰仓库文件」，与「产物只落对话」不冲突（V2.039 现场：s4/s5 各自为「审计指哪」「正身写哪」重开一次讨论）。

**理解→动手边界（V2.016）**：理解轮内出现改动意图（"顺手修了""顺便加了"）→ 停手，另起工程轮（理解报告先交付，改动走新一轮 T0 + Gate 0 + lane）。一轮之内"先理解后动手"必须有书面 transition（"理解结束，转 Lane X"），无 transition 的混合轮 = malformed。反例：同轮先写"判为纯理解轮"又写"走 Lane C 先 chart"——两张皮，必拆两轮。

## 调用面：工具被拒 ≠ 未安装（V2.030）

harness 遵守子 skill 的 `disable-model-invocation: true` 时（DSH），Skill 工具会回 `not available for model invocation`——该 skill 已安装，只是不能模型调用。此时按 `references/invocation.md`：读已安装正文 inline 执行，`Skills called:` 标 `name(inline)`，开工卡写 `调用面:` ＋ 正文 `file:line`；不记 deviation。只有安装目录里也没有正文，才按 `missing` 走 bundled fallback + deviation。同一 skill 被拒后不重试工具（重试 = 空转，记 deviation）。T0 `ask-matt` 被拒 = inline 读正文并作为本轮第一动作；**加载 automatt 本身不是 T0**。

## 子 skill 只回文档：inline 执行并注记（V2.005）

子 skill 经 Skill 工具调用只返回文档文本、不实际执行 → 按文档步骤 inline 手动执行，效果等同调用，并在 trace/JOURNAL 注记 substitution。T0 ask-matt 若只回通用文档、无 Lane 裁决，Gate 0/shield/lane 判定按 prelane/bug-flow 自行落子并记录。

## 正身优先：fallback 只留给"未安装"（V2.006）

子 skill 已安装 → 动手前先经 Skill 工具加载它（哪怕它只返回文档正文），然后按其正文 inline 代执行——这叫代执行，合法；工具因 harness 过滤被拒 → 按 `references/invocation.md` 读已安装正文 inline（`name(inline)`＋`调用面:`＋file:line），同样合法。`references/` 里的速记版 fallback 只允许在对应 skill 未安装（或正文缺失）时使用。既没调工具、也没读正身就干活 = malformed，JOURNAL 必记 deviation（未加载正身）。已装与否以本机技能目录实测为准（`<your local skills directory>\`），不靠记忆。

**开工点名（V2.019，连续 5 轮未加载正身换来）：** 动手前在 trace/NOTES 写一行本轮要调的正身清单（例：`正身清单：diagnosing-bugs、tdd、code-review`），然后逐一经 Skill 工具调用（被拒则读已安装正文 inline，见 `references/invocation.md`）；代执行仍先加载再 inline。清单缺一项、或清单有点名但无对应调用痕 = deviation（自觉守不住的，点名替自觉）。**收尾调用痕自查（V2.020，点名只管写不管调换来）：** 收尾前 grep JOURNAL `Skills called` 行（无 JOURNAL 仓看 NOTES 顶部同名行），清单每项须有对应调用痕；有点名无调用痕 = deviation 当轮补记（v1.182–v1.184 code-review 连犯 3 轮换来）。（V2.025：点名并入开工卡「正身」行，不再另写一份；V2.039 起该行是卡的固定字段 `正身：<skill 清单>｜必读集：<paths:lines>`，不必再自造行。）

**driver 自己也要有加载痕（2.0.57）：** 这条对**子 skill** 说的是「点名必须有调用痕」；同一个要求先落在 **driver 自己**身上——本轮要么有 `skill` 工具调用 `automatt`，要么 inline 读过安装副本并在卡上记 `automatt=inline(read path:line)`。**没有这条痕就不许出开工卡/账本条目/`本轮流程:`**（那三样是加载的产物，不是加载的替代品）；`正身:` 里也不许写 `automatt`（driver 不是正身）。现场：另一个项目里多轮打印 `卡刷新｜…｜正身=automatt (无子 skill)`、`本轮流程: (无子 skill 调用)`，全程没加载过 skill —— 仪式在、流程不在，比不接管更坏（让「有没有跑流程」不可判）。

**正身硬痕（V2.023，读=调混淆终结）：** 点名清单每项须有调用痕＋正文引用：Skill 工具返回（正身版本/行或返回要点一句），或 `inline(read <path>:<line>)`＋一句正文引用（工具被 harness 拒绝时）；inline 代执行须先有调用痕（工具或 inline 读）＋注 substitution ＋正身行号，无痕 inline = malformed。收尾从grep JOURNAL文本升为调用痕＋产物双验：清单每项须同时有调用痕与对应产物（spec/ticket/红绿输出/review结论），缺一 = deviation当轮补记。

## research 硬入口（V2.006 立项，V2.010 量化）

任务所需的外部事实（选型对比、强弱排序、上游/竞品行为、文档真相）→ 调 research 正身，走它的形态：后台代理调查 + 带引文的 Markdown 落盘，主线程继续干活；写进 spec/ticket 的事实必须有落盘文件或可引用来源。对话内顺手答一句常识不算任务调研。直接搜索顶替 research 形态 = deviation 必记。

**量化门（V2.010）**：同一任务需要 ≥2 处外部事实 → 必须调 research；只有 1 处且 5 分钟内可确认 → 可顺手查，但写进 spec 的事实仍需注明来源。

## 并行 brief 与互审配额（V2.022）

派子 Agent 并行（implementer/探针/审计）时，brief 必含三件：完整导出清单（含 async 与否）＋接线变量语义（哪个名字指向 state、主 Agent 会怎么接线）＋判据落点（这份交付由哪条门验）。缺一件而接线返工 = deviation（6-Agent 两轮返工换来：`initExits` 导出形态不明、同步/异步挂载各一、接线点名实不符）。

每轮至少一个 Agent 只审主 Agent 本轮改的判据/门，不写新功能，且带"找 N 个以上缺口"量化要求——新模块有测试兜着，判据没人审才是系统性风险（三轮互审连抓 P0 假绿/D21 绕过/注释撒谎换来；无量化要求的复核只会顺着主 Agent 思路全绿）。

**独立对抗审计（V2.026，前置·结论级）：** 互审管「改动后必有人审」；本节管「实现/采信前先被证伪」，并存不互替。
- **载重结论红队（时序前置）**：凡「错了就翻项目方向 / 白烧数小时」级的结论（如「外部依赖已死」「根因在 X 层」），采信/发布**前**先派独立方（子代理或自带红队角色）做**反例搜索**；红队对象＝**结论本身**，不许只审其更窄的子命题（v1.287 只审「keyless 已关」而漏审「整层关停」，次日被证伪）。
- **判据/门初稿预审**：新判据先被独立审一遍（带回 blocker 数）再实现；不许「实现完再审」。
- **提案实测审**：实施方照做提案时同步实测审计；抓到提案 bug 即停改＋回报——提案也要被实测审（v1.282 fix-4 实例）。
- **审计产物**：被证伪点/修复点/**撤回项**（对抗方撤回自己哪条判词）写进 NOTES 或本轮 trace；无落盘不得称「已审」。
- **降级**：无 subagent harness 走自证伪协议（可证伪断言＋最小反例实跑/同刻对照）＋ JOURNAL 注记（沿 V2.022 快档先例）。
- **并行写边界（随行句，V2.026）**：并行派发时写域独占（各 Agent 各碰各的文件）＋子代理不提交、不碰版本号（发起方统一提交）＋轮次/长任务在跑时只派只读或新建文件的任务——这三条「必须写进每个 prompt」。

## 自扫清单：15 秒自问（V2.006 立项，V2.008 扩展）

对照**已加载的**判据自问，绝不重新读文件——例外：每轮开头必读 `references/anchor.md`（V2.025 每轮再锚）；其余重读只在会话首轮、compact 后、版本不符、拿不准时。以下任一时刻命中，就过一遍 8 核心 + research/prototype/handoff/wizard 四支持，命中即调正身：

- **常规自扫**：每吞完一个 slice（Lane B/C）、每完成一个诊断步骤（Lane D）。
- **红转绿后**：问"这个缝还锁着别的行为吗？还能再往前锁一步吗？"——邻接行为、边界、护栏用例，值得锁就加（v1.033 日志测试、v1.034 诱饵测试都是绿了之后才发现还能再锁一步）。
- **同一问题连续失败 ≥3 次**：停下，把踩坑固化进 NOTES 或脚本再继续——连踩七坑靠自觉不是靠机制（v1.051 打包）。
- **新轮次病灶与既往已修缝同文件**：本轮冒烟必须覆盖既往缝（三缝冒烟，V2.008 转正）。
- **出现第 2 种修复方案之争，或单轮改动跨 ≥3 源文件**：自扫提示考虑 codebase-design——设计分叉靠 review 兜底就太晚了。
- **中途起雾（V2.018）**：prototype 回来结论未定、research 回包与 spec 冲突、seam 形状未定、review 报 spec 相反、hypothesise 多假设并存、红转绿后有邻接可锁、连败 ≥3 次——命中 6 硬门禁即调裸 `grilling`（见中途 grill 专节），命中 2 软提醒建议调。中途无起雾不硬烤，有起雾不烤 = malformed（硬门禁）或 trace 欠一句（软提醒）。

## 外部 review 意见处理（V2.008）

CodeRabbit/人类在 PR 上的意见：**先复现，有效才修，修完在 review 线程贴红→绿证据回复**；无效意见驳回并附证据（先数学实证再动手，v1.034 反例：CodeRabbit 说会压穿 min，实证后确认有效才改）。tautological 断言可拒（jsdom 无布局能力，快照锁不住样式行为）——但审稿人坚持就加上，无害的锁。混入无关文件的 PR（继承分支带脏 commit）→ 重建干净分支强推，diff 收敛到本次工作。

## 评审与 verify 永不豁免（V2.006，用户政策）

用户政策：宁可多花 token，也不让人参与。code-review（双轴）在每次提交之前必跑，纯静态 UI/展示层改动也不豁免——评审收益小时走快档（单轴 diff 自查 + 全量 verify 贴绿），但不许零评审提交。verify 同理：能自己跑就跑，多跑几遍、多贴几段原文都行；库没有验证命令就自发明 seam 断言 + 冒烟。人的参与只保留在 STOP 清单（高危/外部可见/真缺 token 换不到的信息）里。非 git 仓库：code-review 正身的 git 流程（fixed point/diff）无处安放时，快档就是明文许可的完整替代，不算漏、不必再问人。**无 subagent 的 harness（V2.022，连 5 轮同族换来；V2.035：delegation depth 0 / 子会话额度用尽同判）：** 双轴子代理派不出时，快档 = 双轴自查（Standards＋Spec 逐条过、HARD 全修）＋全量 verify＋JOURNAL 写明 harness 限制，即完整替代，不算漏、不记 deviation——但收尾须以一行 `快档：<下单|单轴>｜harness：<限制>｜理由：<…>` 留痕（V2.025 收窄）；单轴 diff 自查只够非 git 仓。**（V2.053：口径覆盖 review 路径本身）**——委派深度用尽/额度耗尽时，`code-review` 要派的两个并行子代理派不出来，**这与「无 subagent harness」同判** ⇒ 双轴自查（Standards＋Spec 逐条过、HARD 全修）＋全量 verify＝完整替代，不算漏、**不记 deviation**；留痕字段与审计降级一致（`快档：<下单|单轴>｜harness：<限制>｜理由：<…>` ＋ 账本摩擦条），别只在 NOTES 里写一句。有真双子代理的 harness 回到双正身，不走本条。

## setup 判据（V2.006 立项，V2.010 状态位）

**状态位**：setup 跑完必须在项目里留下机器可查的标记——`docs/agents/` 目录存在即视为已跑（setup 的官方产物）。driver 不猜、不问、不看记忆：标记存在 → 跳过；标记不存在 → 本轮先跑 setup，再进 lane。**查的时机（V2.041）**：Step 0 侦察里就查，结论写进开工卡 `分流:` 行的 `setup <done|needed|n/a>`——不要等改完代码才想起（V2.041 现场：s9 实现完才发现 `docs/agents/` 缺失，补跑属越界，只能记 deviation）。**同轮 chore 提交（V2.037）**：setup 可以作为**同轮的独立 chore 提交**完成（chore 提交不 bump 版本、不算 lane 交付），所以「首个工程轮先跑 setup」与「一轮一提交」不冲突；只有**实现之后**才补 setup 才是 scope 越界（V2.037 现场：两条旧句互相夹逼，agent 只能记 deviation 把 setup 无限推迟）。

**新项目默认先跑**：空仓、无 AGENTS.md、无 tracker 痕迹 → 等同于"setup 没跑过"，进门第一轮先跑 setup（AFK 自答默认值：local-markdown tracker + 默认 triage 标签 + 单上下文 + 自答建 AGENTS.md）。纯理解轮（只读+汇报）不算 first touch、不触发 setup，但也不许动代码。连续推迟 = deviation 必记。**n/a 豁免（V2.053，三次复现后立的）**：项目**没有票面/工单/tracker 需求**（评测夹具、一次性演练仓、纯脚本仓）⇒ setup 状态位可判 §n/a§，**这是合规判断，不记摩擦条**（r18 s6 / r19 s6 / r20 h6 三次都把合规的 n/a 记成摩擦 + 反思卡 ⇒ 噪声）。判 n/a 时在卡的 §分流§ 行写清理由（如「本仓无 tracker 需求，跑 setup 会新增无关的 docs/agents/」）。**顺序（V2.033）**：setup 只允许在**首个工程轮、任何实现动作之前**运行；实现后再补 setup / 改 AGENTS.md、docs 属 scope 越界，必须记 deviation 并在条目 `skill 侧卡点` 指明，不得静默。

## grill 方向盘：每次改动先打磨（V2.010，向官方靠拢；V2.018 放宽到 frontier-empty）

官方规则：每次改动前都走 grill。开局路由：有目录用 `grill-with-docs`，无目录用 `grill-me`，零副作用一次性用裸 `grilling`（见 8 core + 四问 Q1）。AFK 自答保留（用户不在场），但"走 grill 流程"这个动作不许省：需求超过"改一个已定位的东西"时（新功能、新行为、新系统、新文案结构），必须有 frontier 提问 → 自答 → 收敛的书面过程进 spec/NOTES，然后才写 spec。"需求一句话说清就不调"是漏洞——一句话的需求恰恰最需要打磨。单行 typo/doc、已定位的纯修复，可跳过 grill，但要在 trace 里写一句为什么跳过。**轮次（V2.018，质量优先不计 token）**：开局 grill 跑到 frontier-empty 为止，软上限 4 轮、硬上限 6 轮；收敛判据 = 空（frontier 空）+ 稳（连续一轮无新增决策点）+ 净（每项自答有引用：文件/issue/子代理报告，无引用不计收敛）；发散刹车 = frontier 连续两轮不缩小即 STOP 写 `NEEDS-HUMAN.md`；不可逆清单/数值项永不计入收敛，单独走 HITL。找事实派子代理（research/prototype/Explore）并行，不占 grill 轮次；无证据的 `NEEDS-HUMAN` = malformed。

## 中途 grill 专节：continuous-grilling（V2.018，质量优先）

开局之后全程可烤。中途只许裸 `grilling`（按需配 `domain-modeling` consult：只读词汇表定词，不跑 session、不写 `GLOSSARY.md`）；中途调 `grill-with-docs`/`grill-me` = malformed（user-invoked 互调）。中途产物只写三处：ticket `## Answer` 增量（frontier 问答 ≤3 组 + 结论 ≤5 行）+ map 指针 + `NOTES.md`；ADR/spec/`GLOSSARY.md` 落盘归外层统一做，内层直写 = malformed。审计口径：只扫 JOURNAL `Skills called` 行 + Skill 调用痕，不扫正文提及；开局首个 user-invoked 不计套娃。

**6 硬门禁（命中未调裸 `grilling` = malformed）**：①prototype 回来必回烤（手感/外观跑起来才知道 → 结论变决策，1–2 轮）；②research 回包必烤（外部事实落盘后"事实变决策"，与 spec 冲突处逐条裁决）；③Lane C resolve 挖出 spec 范围外的新系统/依赖/管线/成本/合规 → 先烤方向（还做不做/Destination 改不改/STOP 还是另起 map）再按结论走，禁直接 Collapse/Build；④tdd 吞缝前缝位未定（两实现打架/调用方知道太多/第二同形 adapter/跨 ≥3 文件）→ 先微烤接口形状与调用方知识，收敛再定 seam，consult codebase-design 在烤后；⑤code-review 报"行为与 spec 相反/红线 breach"→ 先回烤（改码还是改 spec），结论写进 ticket/NOTES 再修；⑥diagnosing-bugs hypothesise（Phase-1 红已建后）→ 必烤假设语句排序（3–5 可证伪假设排下一实验序，见 bug-flow 加注）。中途单点默认 1–2 轮，frontier 未空且有进展可加 1 轮；B-vs-D 拿不准允许先烤 1 轮分流判据（可复现否/有无 Phase-1 红/行为错还是需求不明），烤完必须落 B 或 D，禁连烤。

**2 软提醒（建议调，不记 malformed，未调写一句为什么）**：①红转绿后"还能再锁一步吗"→ 烤一轮候选 seam（邻接行为/边界/护栏），值得锁就加，不值得写一句；②同一问题连续失败 ≥3 次 → 停下重烤策略（停不停/踩坑如何固化/冒烟怎么补），只记 NOTES 不重烤不许继续。切片/Collapse 边界争议（>3 slices 转 Lane C、parked-collapse 多分支）暂放建议级，V2.019 再议。

## prototype 硬入口：跑起来才知道就先跑（V2.010）

出现以下任一，动手写生产代码之前必须二选一：①两种方案争执（A 还是 B 拿不准）；②状态机/交互/手感跑起来才知道。选 prototype（30 分钟内可跑出：按官方分支选 LOGIC 可分享单文件 / UI 多变体，throwaway 标记、一键即跑、无持久化，结论折进真代码，原型挂 throwaway 位置留指针）或 codebase-design 的 design-it-twice（跑不出来时）。两个都不调直接开写 = malformed。

## codebase-design 前置到 tdd（V2.010）

tdd 吞缝之前先问一句"缝的位置和接口形状定了吗"——没定（两个实现打架、调用方知道太多、第二个同形 adapter 出现），先翻 codebase-design 词汇表做 consult（读正身、不跑 session；跑不出来才走 design-it-twice 并行设计），定了再写测试。官方 tdd 正文原话的落地。（V2.018：consult 之前先过一轮裸 `grilling` 微烤——只问接口形状与调用方知识，收敛再定 seam；见中途 grill 专节硬门禁④。）

## 编排铁律：user-invoked 不互调（V2.010，官方原文）

官方规则：user-invoked skill 只编排，可调 model-invoked，但永远不调另一个 user-invoked。driver 自己是编排者，调谁都行；但被调的 user-invoked skill（to-spec、to-tickets、implement、implement-spec、grill-with-docs、wayfinder、triage 等）不许再调另一个 user-invoked——to-spec 里不许调 implement，implement 里不许调 code-review（implement 正文的"/tdd…/code-review"指运行其纪律，不是调其 skill）。model-invoked（tdd、code-review、diagnosing-bugs、prototype、research、codebase-design、`grilling`、`domain-modeling` 等）可由任何人调——其中裸 `grilling` 与 `domain-modeling` consult 中途任何上下文可调；`grill-me`/`grill-with-docs` 是 user-invoked（正身 `disable-model-invocation: true`），中途禁调（见中途 grill 专节 V2.018）。违反 = malformed。V2.030 补充：harness 拒绝模型调用时，inline 读正身属于「读数据」，不算 user-invoked 互调；`ask-matt` 的 inline 读是 T0 的合法形态。

## 长任务 spec 演进位：冻结基线 + issues 增量（V2.009）

跨轮长任务（Lane C，多轮同一目标）：第一轮落定的 `spec.md` 即冻结为 M0 基线，后续轮次不再改它——增量只记决策票（`issues/NN-*.md`）+ CHANGELOG，审计以 issues + CHANGELOG 为准。审计类轮次不再因"spec 没更新"误报。短任务（单轮 Lane B）不受影响，照旧 spec 内嵌 slices。

## tdd 不适用的既定解释（V2.009）

纯渲染/文案/纯文档/只读审计轮没有可吞的 seam → 记 `tdd n/a` 是合规的，不是漏用。但门禁不许裸奔：回归全绿 + 包验/语法（或哈希验签）必须有。连续四轮以上同一解释无歧义即视为既定解释，不必每轮论证。
