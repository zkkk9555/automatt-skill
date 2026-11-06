# trace-discipline — 追踪纪律

> 来源：瘦身前 SKILL.md §5（第 614–626 行） 逐字拆出（仅加本文件头两行）。行为以此为准，SKILL 主体只保留指针。

## 5. Trace discipline

- One effort per `.scratch/<slug>/` (multi-intent → multiple slugs):
  `spec.md`, `issues/NN-*.md`, `NOTES.md`, `map.md` (Lane C), `BLOCKED.md` /
  `NEEDS-HUMAN.md` when stopped. `.scratch/<slug>/` is committed
  (spec/map/tickets are review artifacts); solo single-branch repos push a
  one-commit-per-ticket linear sequence; diagnosis itself doesn't commit.
- Publishing = writing `Status: ready-for-agent` into the issue file (a file
  line, not a commit attribute).
- Never mix lanes or slugs in one commit. Never invent vocabulary: reuse
  `GLOSSARY.md` terms; genuine gaps go to the spec Glossary →
  `domain-modeling`, not synonyms.
- WORKFLOW-ACTIVE marker (V2.006/V2.011 counter, V2.025 lane fields): at the first engineering round of a task,
  write `.scratch/WORKFLOW-ACTIVE.md` (one line: active slug(s) + start date
  + driver version + `工程轮次: N` + `车道:X｜本轮:<first action>`（the lane fields refresh at each engineering round's step 0）); when a prior task closed this session,
  rebuild the marker with the carried count +1 (the count lives in session context — the marker is deleted at every task close, so it is
  rebuilt per task, never updated in place *except the lane fields above*);
  delete it again when the task
  closes (delivered/STOP/BLOCKED with the delivery-check triple handed over). The
  marker count is for continuity only. setup
  (`setup-matt-pocock-skills`) adds one standing line to the project's
  AGENTS.md: 若 `.scratch/WORKFLOW-ACTIVE.md` 存在 → 先调 automatt（**没加载 driver 就不要写开工卡/账本条目/`本轮流程:` —— 那三样是加载后的产物，仿制它们等于伪造证据**，2.0.57）（V2.054 改名迁移：旧凭据行 `autopilot: on` **不算已接入**、无宽限期 —— 认到它就**先换接入点**（那一行 → `automatt: on`，指针目录 `.autopilot/` → `.automatt/`）再照常驱动；只读轮不换，给一行迁移提示）
  再继续；新任务开局拿不准走哪条路时 → 也先调它分流 — this is how a fresh window re-invokes the driver without the
  user asking, and how an unsure opening routes through T0 without re-reading
  the whole driver (a dozen words, not 8k tokens). **Single-round open-close
  exemption (V2.019):** a task that opens and closes inside one round (marker
  would have no cross-window function) skips the marker — note the skip in
  one line (`单轮开闭，免建标记`) instead of creating and deleting it.
- No-JOURNAL repos (V2.008): when the workspace has no JOURNAL, write the
  `Skills called:` line at the top of the task's NOTES.md so the grep-level
  audit survives (three-round eval precedent).
- Closeout receipt (V2.031/V2.033): append the central entry, then read `落本:`
  back (`sed -n '<range>p'` must hit the entry title) before writing
  `Skills called:` or sending the final message. A B–E child session writes
  `.scratch/<slug>/LOGBOOK-RECEIPT.md` (`central: <path> | appended: <title> |
  at: <ISO>`); read-only/query rounds skip it (use the entry's `readback:`).
  `链:` must equal `Skills called:` in order; emit the entry's `自检:` line
  (`v` / watermark / chain×product). A missing receipt or self-check is a
  deviation, never a reason for the parent to ghost-write.
- Invocation surfaces (V2.030): `Skills called:` marks every refused-but-inlined
  skill as `name(inline)`, and the round card carries a `调用面:` line. A
  `(inline)` entry without `inline(read <path>:<line>)` + one quoted clause +
  `substitution` is malformed; retrying a refused tool call is a deviation
  (idle spin). See `references/invocation.md`.
- External PRs / forks (V2.008): upstream OSS PR work (fork → branch → push →
  CodeRabbit loop) counts as engineering rounds in the WORKFLOW-ACTIVE
  counter; PR follow-up rounds re-using an existing evidence chain stay
  Lane-D-disciplined (reproduce → red → fix → green → reply in review
  thread). Project commit rules (one-commit-per-ticket) apply to the repo's
  own history, not to fork branches — fork history serves the PR.
- Steady-heartbeat rounds (V2.009): when Gate 0 finds no new seam in an AFK
  long task, the round re-runs the unified entry + package-hash check and
  commits nothing. Fresh run-all + hash evidence IS the Gate 0 verdict for
  that round — not idling. Log it as a task entry like any other round.
- Negative evidence (V2.011): proving "absent" needs N zero-hit evidences —
  which places, which keys, how many hits each — never "not found". Three
  zero-hits across independent surfaces outranks one eloquent absence claim.
- T0-no-verdict signal (V2.011立项, V2.015正名): `ask-matt` is a routing map,
  not a judge — expect the generic doc, take the lane from your own prelane
  decision. Log `T0 恒空` ONCE per project (the first round it proves
  verdict-less), then stop counting: one signal is enough for skill-creator.
  In a proven-verdictless project, invoke T0 only in the session's first
  round and route via prelane directly afterwards (downshift — saves tokens
  and noise). Counting every round ("空转第 N 次") is banned: signal, not noise.
- Duplicate-PR pre-check (V2.009): before opening any upstream PR — (1) open
  the target issue's timeline and read cross-referenced PRs; (2) search the
  repo for `close #<issue>` / `closes #<issue>`; (3) confirm no OPEN
  competitor PR exists. A closed old attempt is not "nobody is working on
  it". If an OPEN competitor exists, discuss in its thread first instead of
  opening a new PR.
- Real-world对照优先（V2.017）: 行为结论必须有"直采 vs 引擎/工具"对照实验背书，再动代码。先对照，省一次误修（麦克风独占休眠经对照证明是 Windows 省电行为，非引擎 bug；8.16/quiet2 异常经查是测量口径问题，非漏杀）。对照做法：同一输入跑两条路（裸设备直采 vs 过引擎），差异归谁一目了然。
- 指标必须加窗（V2.017）: 实时指标只看播放窗/动作窗内最佳，EMA 全程平均在启停场景下是错的（live_smoke 初版判据采全程 EMA，播放停后静音段把分拉爆）。窗的定义写进测试注释。
