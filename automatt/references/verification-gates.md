# verification-gates — 验证门

> 来源：瘦身前 SKILL.md §4（第 557–613 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 4. Verification gates (no gate, no done)

- Every code change: run the repo's verify command; full suite once at the
  end. Lane D gate must exercise the seam (harness asserting the behaviour).
  Exception: when the boot crash IS the user symptom, headless boot may serve
  as the Phase-1 signal — but still add one seam assertion, else mark
  gate-blind. gate-blind is Lane-D-diagnosis-only; Build/Collapse ban it.
- No-harness fallback: seam priority is pure function > guard at call site >
  throwaway assert script + smoke run. A gitignored single-file throwaway
  asserting the seam (`red = non-zero exit + signal line, green = 0`) counts
  as red-green, NOT a "new pipeline". Seam-level red may substitute E2E red;
  `BLOCKED.md` only when even seam-level red is unbuildable (time-box: ~2
  rounds / 30 min). Perf gets its own gate: baseline + p95/worst-frame
  threshold + minimal direct-to-stage fixture; if unreachable, file
  trace/bisect + gate-blind instead of faking green.
- Flakes: split seedable RNG (MUST pin) from non-seed nondeterminism (IO
  timing, threads, GC, locale — list all, fix fixture / serialize / retry
  stats). Unpinned seedable-RNG repro rates are invalid; controlled-rate
  non-seed repros are valid. Targets: loop ≤ ~30s, flake rate from ~20 harness
  runs (`100×` is the stress ceiling, not the minimum), glance = 10 minutes.
- Every implement (Lanes B and C; Lane A exempt per prelane.md): `tdd` red-green at
  pre-agreed seams (Testing Decisions first; no test at an unconfirmed seam),
  then `code-review` (Standards + Spec axes, parallel; red-line breach = hard
  violation) before commit.
- Content gates (data/i18n rows): schema-complete (fields/unique-id/bilingual
  non-empty) + count assertion + `Lang`-key-exists assertion + headless run.
  Per-class minimums: typo → `target==0 / expected>=1`; version strings →
  cross-file consistency; numbers → red-line range check.
  **扫描面（V2.044）**：typo/version/number 门的 grep **只扫产品文件**
  （源码、文档、配置、测试等本轮交付面），**排除 driver 自有产物**
  （`.scratch/`、`automatt-USAGE-LOG.md`、NOTES/audit/receipt）——那些文件里的旧串是
  「改前证据」，算进扫描面必然假红（V2.044 现场：r7 s6 / r9 s6 / r13 s6 三次都把
  `.scratch/` 里对旧串的溯源引用判成产品残留）。门脚本要显式写清排除项。
- Display-wiring gate (v8): pure format-string/call-site changes (new `%`
  slot, new arg, reordered args — zero behaviour change) carry NO red-green:
  there is no seam to assert red at, and a throwaway asserting "the 7th arg
  exists" proves nothing the smoke run doesn't. The gate is instead: (1)
  bilingual slot parity (every locale's format string has exactly the slots
  the call site passes — count `%` per locale, iter123: cn/en both 7);
  (2) call-site arg alignment (arg count == slot count, types match —
  `%d` gets int); (3) headless smoke run (a `%`/arg mismatch crashes or
  misrenders at draw time, so smoke IS the seam test). Record all three in
  the ticket/NOTES; mismatch in (1)/(2) is a hard violation (same weight as
  red-line breach in review).
- Every bug fix: Phase-1 loop re-run green + regression test passes (or the
  documented no-correct-seam finding) + all `[DEBUG-*]` grepped clean +
  throwaways removed. Regression path: D = `NOTES.md` (diag + repro) → fix
  ticket (Provenance + Acceptance IS the regression) → repo's regression dir
  if any, else throwaway (never adopt a framework silently).
- Anchor rule (overrides the old no-paths ban): specs/tickets MUST carry
  one-line anchors (`path :: symbol`); large pastes banned. Lane D diagnosis
  may carry multiple candidate anchors, converging to one at fix time; a
  documented no-correct-seam finding is exempt but must chain the architecture
  finding. Specs additionally carry `Checks: i18n Pass/N-A + evidence / save
  Pass/N-A + evidence / BALANCE Pass/N-A + evidence` — N/A needs a reason.
- Slice E2E rule: every Lane C vertical slice needs end-to-end demo evidence;
  seam-red is a prerequisite, never the substitute.
- Edit hygiene (v18): before editing, re-read the anchor's ±5 lines and check
  block alignment (`if`/`else`, nesting depth); after editing, re-read the
  hunk before smoking (R59: an `else` shifted one level = parse error caught
  only by smoke — see JOURNAL #192).

## 6. Field-distilled additions (V2.008)

- **门误伤 ≥3 次 ⇒ 改门，不改文案（V2.055，另一台机器同族 3 次）。** 同一个门连续三次把**合法内容**判红（禁词表把「剧透」这个词本身判成泄露、把「不写 X」「X 是禁词」这种解释句式判成泄露），说明**门的判据错了**，不是文案错了：第三次起必须**先改门**（加 allowlist / 收紧到陈述句 / 先剥标签再匹配），并在 NOTES 记「门改了什么、为什么」。拿改文案绕过门 = 把门的可信度磨掉；**门一旦常红就等价于没有门**（见 §4 的老规矩）。
- **新加的断言 / 判定脚本，先拿真产物跑一次（V2.055）。** 新写的门第一个动作：拿**当前真产物**跑它（期望绿），或拿**旧产物**跑它（期望红）——跑完再继续写实现。现场三例：一条新写的指纹断言把 `content="11120 · sha"` 写成 `content="11120·sha"`（少个空格），写完没在真产物上验，直到数据涨到一万条才红；另两次是**自拟判定脚本自己算错**（一次假绿 19 条、一次假红 9 条）。**判定逻辑不许自拟**：能复用既有门就复用，自写就必须先做上面这次双向试跑。
- **无 git / 无固定点时，审查基线怎么写（V2.055，跨机器同族 ≥3 次）。** `code-review` 只给「`git diff <fixed-point>...HEAD`」；项目没有 git 历史（空目录新建）或本轮没有固定点时：用**时间点文件快照清单**当基线（开工那一刻的文件清单 + sha256 落一份 `.scratch/<slug>/baseline.txt`），在 `deviation:` 记「无 git，基线=快照清单」，然后照常做双轴审查。**不许因为拿不到 diff 就跳过审查。**


- **No-harness expected-value discipline.** Every invented assertion's
  expected value MUST cite an independent source in the NOTES (contract
  comment / upstream standard behaviour / the user's own words) — never
  derived by running the buggy code. At least one guard assertion must have
  an expectation that differs from the buggy output (the sum(10,-4)
  mis-derivation as 14 was exactly the buggy value; the red gate would have
  "passed" the bug). If the only truth source is an in-file comment, verify
  the contract itself per the comment-truth rule before locking red/green
  to it.
- **Test-registry discipline.** The moment a repo holds ≥2 standalone test
  scripts, create/adopt ONE unified entry (npm test / run-all) and register
  every test there. Every new test file is registered in the same round it
  lands — a test missing from the entry point is an incomplete delivery
  (v1.055 shipped a suite the entry point didn't run; v1.056 had to patch).
  Costly tests (paid APIs, real quotas) are tiered and labelled in the entry
  (free-full / smoke / paid-manual), never silently mixed in.
- **Windows/MSYS notes.** Subprocess tests redirect output to a FILE, not a
  pipe (a .bat's hidden grandchild process holds the pipe write-open and
  communicate() hangs forever). node under MSYS bash cannot
  require('/tmp/…') — cd into the directory and require relatively. Scripted
  edits (str.replace / regex) on files containing real escape characters
  silently no-op — use the Edit tool; when a scripted edit is unavoidable,
  assert the replacement hit count (a zero-match python replace once dropped
  a README version row silently).
- **Chore/metadata commits.** Driver-owned lifecycle files (WORKFLOW-ACTIVE.md,
  DRIVER-PROPOSAL.md, local log pointers) are chore: add/remove without
  bumping the project version, never as a standalone versioned commit — ride
  along with the next real commit or a plain chore commit per repo rules.
- **Gate-credibility (V2.022).** A gate nobody checked is a costume: every new
  gate ships with (1) a red-baseline — feed it a known defect, it MUST go red;
  self-check baselines are auto-found by defect signature in history, never a
  hard-coded commit (a HEAD baseline is green forever); (2) real-data
  injection — hand-made fixtures cannot catch real shape drift (D14's scanner
  idled since the V2 port); (3) both assertion kinds — "must-have" AND
  "must-not-miss" (count + sequence continuity: two writers halving the work
  still adds up). Shadow judges (self-checkers, fixtures, in-gate fixtures,
  injected alert text) MUST read the master's product fields, never recompute;
  on missing fields they abstain, and abstention is never reported as clean.
  When a gate misbehaves, first ask who owns the signal and land the final
  resolved value in the ledger — not "is the threshold right". Forward and
  reverse gates MUST call the same predicate function; the reverse gate only
  swaps inputs (re-writing the predicate re-proves nothing — four inverted
  assertions in one round). Review always asks one fixed question: was every
  new comment and gate calibrated against the measured object. Gates that
  depend on external state (process / deploy / route / config) MUST verify
  from the outside in their done-criteria (`version===runtimeVersion` before
  a pressure round); known blind spots are written down, never pretended
  covered.

**门落地标定（V2.026）。** 新门/新判据上链前，四条随门留痕（缺 = malformed，写进 NOTES 或提交信息）：
1. **可满足性算例**：回答「什么样的**真实**轮次/数据能让它 PASS？」并附一个真实数据算例；答不出＝门有病，先标定再上链（#5/#9 结构性不可满足门的实例）。
2. **最坏方向**：只证「不会假绿」不够——「会不会**永远红**/目标物理不可达」必须一起论证（quiescence 用全局 MAX(time_created) 把 CLEAN 变成永远不可达的实例）。
3. **常数边界**：判据/提案里每个常数（预算/窗口/下限/阈值）问一句「最坏输入下是多少」（CLOSEOUT_TS 实例）；保守起点显式记「待标定」。
4. **覆盖声明**：新门当轮进统一链（V2.008 注册条）；「全链绿/全绿」声明必须写明**覆盖范围**——链外的门＝盲区，禁把链绿说成全绿（shape_gate 全红而链绿覆盖不到的实例）。
5. **读数出处（骑带句，V2.026）**：判决依据的每个统计量/字段，在 NOTES 留一行**写入点引用**（V2.022「门故障时首问信号源归谁」扩域到任何判决读数）；引用「某客户端/某一跳被拒」必须写明**那一跳由谁发出、字节由谁产出**（CONNECT 两段状态行、交接单漏签名的实例）。

**Verdict-trust (V2.023).** (1)收紧/放宽判据须真数据跑一遍＋独立实现对照一致，反向门自洽≠正确（v1.237/238同族）。(2)吞错禁令：批量mv/cp禁2>/dev/null||true吞错；报告数须独立重数文件系统核对；catch/重试须先报告失败因（v1.239/243/244）。(3)锚与不可判：源码扫描锚须过变异体（注释敏感即锚错）；不可判须活到输出，选下游grep最安全形（?/NA），0禁冒充无（门15/门14第3例）。

**Closeout & round settlement (V2.024).** 素材：V2.023 水位线后 v1.250–v1.269（单项目，同族 ≥3 经 10 路交叉验证收敛）。四条一次说清——**轮无效怎么裁、增量怎么数、收尾留什么证**：

1. **轮次结算（b 轮替代）**：仪器或执行偏离致某轮证据无效（档位静默落错档、时序竞态、账本执行偏离）→ 判 **INVALID** 并**留痕**（作废因与修门合写入同轮；作废不得销声），不计 CLEAN、不计 FAIL、不清零连击、不罚网关；修门后以**同轮号 b 轮**替代重跑（R6→R6b / R1→R1b / R5→R5b 三例）。口径换代（判据或体裁变，如 A/B 组 → 完整 30 会话）时旧连击**不继承、从零计**。
2. **增量口径**：跨轮累积指标先扣**轮间 ambient 漂移**，只计**本轮窗口新增**；设计内已吸收的错误（如被吸收的上游 429）不计失败；单实例类判据核**监听 pid 唯一**、残影从严排除。
3. **收尾证据清单**：收尾须按清单留证（清单由项目域给：逐路 JSON 存档 / POST / identity / 快照窗口等）；**缺关键证据即结论不可判**（禁把缺件当绿）。事后重跑与**收尾时刻读数**不一致时只作定性、记 `provenance-gap`，**不得倒填改判**（兑现 V2.022 park 的"不可判显式化，待第 3 例"）。

## 8. Destructive-guard (V2.011)

Paid for by a real production accident (24 local versions lost when a
SIGTERM hit a stash-triggered gc mid-red-phase):

- **Red-phase rollback prefers file-level backup.** `cp` the files first,
  then revert by hand. Never change git state to obtain red —
  `stash`/`reset`/`rebase`/`checkout --` are banned without a prior
  file-level backup. Before any history-rewriting command, ask "what happens
  if this gets interrupted" — then back up first.
- **Baselines before bulk changes.** Before the first `mv`/rename/batch edit
  of a round, take a count/snapshot baseline (`find . -type f | wc -l`,
  `git status` benchmark before running file-writing "tests"). Reconcile
  after: baseline + delta = final, or explain the gap.
- **Heartbeat review object (V2.016).** Zero-change heartbeat rounds have no
  diff to review — the review object is product freshness instead: package
  timestamps are this round's, CHECKS rewritten, smoke re-run. "All green"
  without a freshness check is not a review. Full heartbeat shape:
  full-regression + dual-package rebuild + portable sync — all three or it
  is not a complete heartbeat.
- **Zero-hit means switch approach.** First grep version zero hits →
  constant tables / full dumps / two-way pincer — never bigger regexes.
  When fixing environment bugs, close by asking "which sibling risks share
  this hole" (same-class sweep, not just the one instance).

## 7. Closing audits (V2.009)

Before every commit, run these four cheap greps — each has caught a real
shipped defect in the field:

- **Version-string grep.** Search every version literal touched this round
  (package versions, doc headers, panel banners, footers); all copies must
  agree. Three field misses caught only by this audit.
- **Doc-template placeholders.** No path-shaped placeholder (`X.Y.Z`,
  `YYYY-MM-DD`, unfinished `TODO(path)`) may survive: templates reference
  "see <file>" instead of writing fake paths; the links-gate (below) is its
  machine form.
- **Assertion-string copy-paste.** Never hand-type an assertion string: copy
  it from the product file. Two consecutive red runs were both test-string
  typos, zero product changes.
- **Triple-source expected values.** Every invented expectation is checked
  against three independent sources where available (contract comment /
  sibling code / spec section) and hand-computed once — never derived by
  running the buggy code (see §6 no-harness discipline above).
- **Structural self-edit audit (V2.019).** Before every commit, assert the
  round's own edits did not silently damage structure: version titles strictly
  decreasing + package version has its title + README version line agrees;
  no placeholder-shaped leftovers (`X.Y.Z`, `YYYY-MM-DD`, unfinished
  `TODO(path)`); doc-template links point at real files. A hand edit that
  deletes what eyes cannot see (swallowed headings, dropped rows) is a defect
  class of its own — machine-check it, never eyeball it.
- **Review-last (V2.035).** `code-review` closes the chain: every `tdd`/`implement` entry precedes it; review-before-tests is a deviation and must be recorded in the ledger. Single-round subagent: card at NOTES top + repeated as the final message's first paragraph is legal (no intermediate visible channel).

- **Grill-gate audit (V2.018).** Grep JOURNAL `Skills called` at each hard-gate trigger (prototype return / research return / spec-external new system / undecided seam / review-vs-spec / hypothesise ranking) for mid-lane `grilling`; trigger with no grill trace = malformed; mid-lane `grill-with-docs`/`grill-me` hit = malformed; soft-gate trigger with no one-line why = trace debt.

