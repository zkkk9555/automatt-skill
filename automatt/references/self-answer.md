# self-answer — AFK 自答与 STOP

> 来源：瘦身前 SKILL.md §2（第 449–540 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 2. Self-answer policy (what makes this automatt)

`grill-with-docs` / `grilling` normally interview the user. Here the user is
AFK: work the design tree in rounds but answer each frontier question yourself:

1. Repo, docs, or code already say it → take that, cite the file.
2. A tracker issue, spec, or ADR constrains it → take the constrained option.
3. Genuinely open → smallest reversible option, record as ADR, keep going —
   EXCEPT numeric self-answers (damage, cooldown, price, threshold): check
   each against the red-line anchors first; any breach → `NEEDS-HUMAN.md`,
   never ADR-and-continue. Finding facts is your job (explore, dispatch
   subagents); decisions default per this list.

**Irreversible list** (save format, core loop, numeric system, glossary term,
release branch, version/engine declaration, locked content manifest, new
system/dependency/pipeline/ external service/cost/compliance — whether inside
or outside the request):
involving any item with no covering ADR/red-line → forced `grilling` (HITL)
ticket, no self-answered ADR. Locked-manifest growth (e.g. a "30 items"
content lock becoming 31): allowed only with the reason recorded inline in the
manifest itself, plus every dependent counter (achievements, docs, counts)
migrated in the same change — a partial migration is a red-line breach.
Prototype-gated items need a passing prototype
before collapse. In-request new pipelines (mobile port + IAP SDK) STOP after
charting: keep the map, ban Collapse/Build.

**History rule.** Milestone/roadmap history rows are append-only records: never
rewrite what a milestone claimed at its time — annotate current status beside
it ("30 at M3; 31 now"). The present-tense pointers (README index, plan
manifest, BALANCE) always state the CURRENT count.

**Termination (V2.018, quality-first: grill runs to frontier-empty).** Opening grill: soft cap 4 rounds, hard cap 6; converge = 空+稳+净 (frontier empty + one round with zero new decision points + every self-answer cited to file/issue/subagent report — uncited answers don't count as converged); divergence brake = frontier fails to shrink two rounds running → STOP with `NEEDS-HUMAN.md`; irreversible-list / numeric items never count as converged, HITL separately. Mid-lane micro-grills default 1–2 rounds, +1 on progress (see 中途 grill 专节 in core-triggers). Fact-finding subagents (research/prototype/Explore) run parallel, never consume grill rounds; `NEEDS-HUMAN` with no subagent/dispatch evidence = malformed.
Per wayfinder ticket ≤ 2 resolve rounds; two consecutive unconverged tickets →
whole effort STOP. Review blocks only on hard violations (red build, red-line
breach, behaviour opposite the spec); smells are logged, not fixed in-lane.

**Ticket Status lifecycle (v7).** `needs-triage` → (`claimed` while worked) →
exactly one terminal state: `resolved` (Answer recorded, evidence cited),
`ready-for-human` (AFK work complete, a human pick/act remains — ticket MUST
point at its `NEEDS-HUMAN.md` / `BLOCKED.md`), or `wontfix` (with reason).
`needs-info` is a waiting-room, never a resolve: a ticket parked for a human
pick carries `ready-for-human`, not `needs-info` (iter121: combo03's pick was
recorded as needs-info and the map had to re-explain it — the Status line
lied). `resolved` with an open human pick inside is a contradiction; the
verifier for this is grep-level: no `resolved` ticket may contain an
unanswered "HUMAN DECISION NEEDED" / unpicked candidate list.

**Blocking semantics (v7).** `Blocked by:` lists true data dependencies only
(code facts or numbers this ticket consumes). A ticket whose work needs no
input from its listed blocker is a pseudo-dependency: resolve out of order
with a one-line note in the ticket, keep the listed blocker gating collapse
only (iter119: combo04's reader inventory needed nothing from the decay
formula, so it resolved ahead with the note; 03 still gates collapse).
Charting-time "combo-related therefore blocked-by" guesses do not bind
resolve order — re-check at claim time.

**Comment-truth rule (v7).** A code comment asserting visible behaviour
("shown dimmed", "audible cue", "logged") is a claim about the product, not
about intent: Gate 0 treats comment-vs-implementation mismatch as a finding
(iter117: `ward.gd` had no dim branch, so silent wards were invisible despite
the comment). The fix ticket closes the gap in either direction (implement
the behaviour OR delete the comment), and the ticket's Answer cites which.
No lane may quote a behaviour comment as evidence without checking the code
it describes. Verifier is grep-level: search behaviour verbs
(`shown|dimmed|audible|logged|displayed`) in comments, then confirm each
hit's implementation exists (iter125: full-sweep found only the closed
ward-dim comment plus a `shown` local-var false positive).

**JOURNAL draft discipline (v7).** A `## 发布后迭代#NNN` entry drafted in
the worktree but uncommitted is not iteration NNN — it is a draft. Two
commits must never share one iteration number (iter121 landed twice:
`0e32f78` half-round and `67fdb63` close-out — the second commit re-used
the number with a different scope note). If a committed entry's scope turns
out partial, the follow-up takes the NEXT number and cites the earlier one
("补账 iter121" → iter122), never rewrites the committed entry's meaning.
Before committing, grep JOURNAL for the number: exactly one entry.

**STOP前置（V2.023）：** 开工前过irreversible/numeric/shield checklist（Irreversible list＋numeric红线＋prelane shield关键词），有命中无NEEDS-HUMAN.md = malformed。各lane无产物不得收尾：B spec+slices+verify、C map+单PR、D NOTES+Phase-1红绿+回归、A provenance+per-class门；缺产物收尾 = malformed。

STOP and write `.scratch/<slug>/NEEDS-HUMAN.md`, then end the turn, when:

- The step deletes data, rewrites published history, publishes/deploys
  externally, spends money, rotates credentials, touches compliance / legal /
  store submission, contradicts a verified version/engine declaration, or
  upgrades engine/dependencies.
- It introduces a new system, dependency, pipeline, runner, external service,
  cost, or compliance surface — inside or outside the request. Adopting a test
  framework or CI counts. A single gitignored throwaway assert script plus a
  handful of fixtures does NOT (whitelist, see verification-gates.md §4).
- Two options are both irreversible and the repo gives no signal.

Otherwise: no questions, no hedging. Record the call (spec, ticket, or ADR)
and continue.

**收尾证据门（V2.024）：** 收尾产物不仅要有，还要**够判读**——按项目域清单留证（逐路 JSON 存档 / POST / identity / 快照窗口等）；**缺关键证据即判不可判**，禁把缺件当绿；事后重跑只作定性、记 `provenance-gap`，不倒填改判（同 `verification-gates.md` 的 Closeout & round settlement V2.024）。

**档位与显性化（V2.025 execution-trust）：** 开工卡带 `档位：full|lite(因)|na(因)`。
- **full** = 默认。**lite** = 弱模型/受限 harness 的最小协议，五件地板缺一 = malformed：①开工卡 ②车道 ③一个通道产物（A=commit Provenance 行｜B=spec/slices/红绿｜C=map 或当前票｜D=NOTES+红绿+回归｜E=票+brief）④验证一句（真跑；无 harness 走自发明 seam）⑤日志一行。
- **永不降清单**：STOP 清单、危险护栏、如实报告、收尾必写、不许编证据——lite 不是省 token 手段；只升不静降（中途做不到当轮补 `AUTO-DOWN：mode=lite｜cause=…`，禁事后静默）；强档走 lite = deviation；连续 lite 收尾日志点名。
- **na** 仅限三类：纯理解/只读报告（附 file:line＋零改动声明）｜误触发无活可干｜BLOCKED/NEEDS-HUMAN 停。**typo / 文案 / 单行 config-row 是 Lane A，不是 na**（V2.034 现场：README 错字被误判 na → 没 T0、没账本、没提交）；na 轮也必须写中央条（`链: ask-matt`，产物=改动或零改动声明）并提交（非 git 仓除外），“子会话留给父会话记”= malformed。
- `deviation: <环节>|<类：capability|config|na|skipped>|<补偿|无>|<位置>`——该做未做/降级替代**当轮**写；收尾日志强制 `deviation: none|逐项`。既无动作又无 deviation 行 = 静默跳过（最高坏轮）。
- **提交是你自己的事（2.0.62）**：**不要**以「留给你/父会话 commit」结束一轮——没有父会话会来收尾。日志本/`.scratch` 在仓内 ⇒ 你提交（只读轮交 `chore`）；STOP 轮不动工作区是唯一例外。现场：held-out 两题把改动留在 index/未跟踪文件里，换个机器就等于这轮没发生。
- **收尾硬序（含审计）**：**先重读 `references/anchor.md`（2.0.58：这是「重锚=anchor@收尾」那一步，不是走过场）** → **数一遍本轮 `skill` 调用次数，写进 `自检: 调用=<n>`，并让链的名字数与它相等（2.0.60）** → lane 产物齐 → 派只读审计子代理（三查：开工卡+marker／调用痕×产物双验／lane 产物门；量化找 ≥3 缺口；结论引 file:line；只读盘、不看自述；缺件写「不可判」不许绿）→ 把产物/偏差/审计行写进本轮 trace（只写结论摘要 + 回执路径；本 build 无日志本）→ **最终回复最后一行写 `本轮流程: …`**（与 `Skills called:` 同序同集合）→ 删标记。无子代理 harness = 一条 shell 三查，条目只写结论摘要 + 回执路径（命令原文落项目文件或 `.scratch/<slug>/audit.log`），标 `脚本降级`；审计代理 pin 主会话同款模型；不允许自述顶包。

**Token-for-human principle (V2.006, user policy).** The user has plenty of
tokens and does not want to be involved: whenever extra tokens can replace a
human step — more verification runs, a background research agent, a wider
self-scan, re-running the suite twice — spend the tokens. Human involvement
is reserved for the STOP list only (destructive, externally visible, two
irreversibles, or information no amount of tokens can find). Never trim
verification, review, or research to save tokens.


**ready-for-human 单独立票（V2.017）**：凡是必须真人动手的验收（真机联调、对方耳朵确认、试听三选一），必须写成唯一的 `ready-for-human` 票，不许淹没在"已交付"里。票 MUST 指向其 `NEEDS-HUMAN.md`；`resolved` 票内出现未完成的人工环节 = contradiction（与 v7 Status lifecycle 同罚）。机器侧全绿 + 人工票 open = "程序侧交付，待人验"，不许说"交付完成"。
