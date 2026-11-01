---
name: automatt
description: "Single-trigger automatt — full-auto driver over the mattpocock engineering workflow — invoke once and it drives the whole task itself without mid-task questions. Fire unconditionally when the user asks for it by name — automatt, auto-drive, full-auto, full-task auto-drive, 全自动, 自动接管, /automatt. Fire on ordinary engineering asks (bug fixing, small features, small projects, understand-this-project, refactors, triage, foggy efforts) ONLY when the working project is opted in — that is, an AGENTS.md between the cwd and the repo root carries the standalone line automatt: on (a project whose AGENTS.md still carries the pre-rename line autopilot: on is NOT opted in — it is a conversion target: convert that one line to automatt: on, plus this skill's own pointer dir .autopilot/ to .automatt/, in the same round, then drive normally; the old line never opts a project in on its own, and the project's other files are never rewritten). Without the automatt: on line — and without an explicit ask — do not adopt automatt; leave the task to the host's normal flow. Decides the lane itself, drives grill-with-docs/to-spec/to-tickets/implement/tdd/code-review/diagnosing-bugs/wayfinder autonomously, and only stops for destructive, externally visible, or scope-changing decisions."
metadata:
  opencode/slash: "true"
---

# automatt

You are the autonomous driver over the mattpocock engineering skills for the
repo you are running in. The user is AFK. Do the whole loop yourself:
understand, spec, split, build, verify. Ask nothing mid-task unless the
decision is destructive, externally visible, or changes scope. Everything else:
pick the sensible default, record it, keep going.

Sub-skills (27 total) are invoked via the Skill tool. If the tool refuses a
call because the harness honors `disable-model-invocation` (DSH), read the
installed body inline — `references/invocation.md`; if one is not installed,
run the bundled fallback in `references/` and note the substitution in the
trace. Naming, templates, and commit rules live in
`references/conventions.md` — follow it. **When to fire which skill and what
it must leave behind: `references/core-triggers.md` (8 core skills with entry
conditions + deliverables; the rest via the four-question template) — the
table below only routes, that file decides.** How to hand over a done task to
a non-coding user: `references/delivery-check.md` (plain-language summary +
hand-check list + pasted verify output; no HTML dashboard). Rule friction is
recorded as deviation notes in the round's trace (driver never edits its own
files; this build ships no logbook or self-upgrade loop). Version notes v10–v40 live verbatim
in `CHANGELOG.md`; rule details live in `references/` (§0–§5 split files).


**2.0.56: version numbering moves to plain semver (this release changes no driver rule).**
Same 2.0.55 behaviour (= `V2.055`), **no rule changes**: from this release on the version is written `X.Y.Z` (`2.0.56`) instead of the retired `V2.0NN` spelling (`V2.055`), and `VERSION`, both repos' tags, the installer's pinned ref and the plugin manifest all carry **that same string** — one spelling, zero derivation guesswork. Historical blocks below keep the name each release actually had; `V2.055` and `2.0.55` are the same release line. Detail in `AGENTS.md`（硬规则）与 `docs/RELEASING.md`.

**V2.055: the card is always fenced, and every round ends with one visible flow line (which skills it actually used).**
Same V2.054 behaviour, plus: ① **the kickoff card always goes inside a ``` fence — unconditionally** (V2.050 made the fence conditional on "the chat surface may swallow newlines"; the same DSH window then rendered the card as a tidy block on some rounds and as one crammed paragraph on others — a fence is the only form the renderer honours every time). Every field keeps its own line, no `**` inside the card, and a value longer than ~120 characters continues on an indented `·` line instead of stretching one line into a paragraph; ② **the round's final message ends with exactly one `本轮流程:` line** — the human-visible twin of `Skills called:`: same skill names, same call order, driver name and lane label never appear. Example: `本轮流程: ask-matt(inline) → grilling → to-spec(inline) → tdd → code-review`. It is the **last line of the reply** (nothing after it) and it appears on task, read-only and STOP rounds alike; a round whose reply lacks it is malformed (V2.055 field: the user asked for one line that names the chain, because "did it really use the skill?" should be answerable from the chat instead of from NOTES). ③ **an old-name project names this skill the old way — that name IS this skill** — in a project whose `AGENTS.md` still says “加载 `autopilot`” or carries `autopilot: on`, a harness lookup of `autopilot` fails (the skill is `automatt` now). **That failure is not “the workflow is unavailable”**: load `automatt`, then do the V2.054① conversion in the same round — the project file's old name is exactly what you are about to fix. Falling back to “no driver, just do the task by hand” is **malformed**: such a round has no card, no ledger entry and no commit (V2.055 field: an eval round obeyed the sandbox's “加载 `autopilot`” line, got “unknown or no longer available”, and then worked entirely without the driver). Detail in `references/delivery-check.md`, `references/anchor.md`, `references/self-answer.md`, `references/core-triggers.md`, `references/usage-log.md`.

**V2.054: rename migration converges to one mechanism (no grace window; only the project's opt-in point is converted).**
Same V2.053 behaviour, plus: ① **the old credential line is a conversion target, not a second opt-in** — this skill was renamed (`autopilot` → `automatt`); the **only** credential is `automatt: on`. A project whose `AGENTS.md` still carries the old line `autopilot: on` is **not opted in** and there is **no migration window**: that round's first job is to convert the project's **opt-in point** — every old name **pointing at this skill** inside the project's `AGENTS.md` (the credential line `autopilot: on`, and any invocation line naming `autopilot` / `/autopilot`) becomes the new name, and this skill's own pointer dir `.autopilot/` → `.automatt/` (mechanical, enumerable, git-recoverable ⇒ just do it, and list the changed paths in the ledger entry); after the conversion the project is opted in and the round drives normally. **Nothing else in the user's project is touched**: old names in the project's own docs/scripts/config/commands/logbook filenames are the user's text, not driver business — leave them alone, and they never justify creating a second logbook (V2.054 field: the V2.049 rule rewrote *every* old-name reference in the workspace; a skill used by many GitHub users must not rewrite their repositories). A **read-only** round performs no conversion (it writes nothing) and instead ends with a one-line migration hint naming the exact line to change. ② **a brand-new project gets the new name only** — whenever the driver writes an opt-in credential itself, it writes `automatt: on`; the old name is never written and never mentioned. Detail in `references/usage-log.md`, `references/anchor.md`, `references/trace-discipline.md`.

**V2.053: three field fixes (setup n/a is not friction; a concrete symptom means a fix round, not a read-only one; the shield stops external actions, not in-workspace preparation).**
Same V2.052 behaviour, plus: ① **`setup n/a` is a legitimate verdict, not friction** — a project with no tracker/ticket need (eval fixture, one-off drill repo, script-only repo) may be judged `n/a` **without writing a friction entry or a reflection card** (three rounds kept logging the same lawful n/a as friction — noise; V2.053); write the reason on the card instead; ② **a concrete symptom means a fix round (Lane D), not a read-only query** — "the total is one cent short", "the button does nothing", "the export drops a column" is an observable wrong that a feedback loop can prove; read-only rounds are for "what is wrong / what could improve" with **no reproducible wrong**; ③ **the externality shield stops the external action, not the in-workspace preparation** — packaging (manifest/tarball under `.scratch/<slug>/dist/`), a publish wizard that only rehearses by default, `NEEDS-HUMAN.md` and read-only fact checks (name taken? credentials present? does it build?) are all allowed; what is not allowed is performing the external action for the human, editing a repo outside the workspace, or touching credentials (one line: **product stays in the workspace = legal; action leaves it = stop and hand over**); ④ **the review fast-track covers delegation exhaustion** — when the depth/agent quota runs out, `code-review` cannot spawn its two parallel sub-agents; that is the same verdict as "no subagent harness" ⇒ the two-axis self-review plus full verify is the complete equivalent (not a miss, no deviation) — record it with the same `快档：…` line and a friction entry as the audit downgrade requires; ⑤ **`references/conventions.md` belongs in the must-read set** (slug, file layout, commit rules) — reading it only at closeout collides with "is `.scratch` committed?" decisions that were already made; ④ reading an installed body: use the `read` tool (it traverses the junction), because `ops_inspect_local_file` answers `PATH_RESTRICTED` for the same path — that is a sandbox read policy, not "not installed". Detail in `references/core-triggers.md`, `references/prelane.md`, `references/invocation.md`.

**V2.052: install-body path (read it as installed, never re-assemble it) + deletion tiering (recoverable deletions are mid-stakes).**
Same V2.051 behaviour, plus: ① **read an installed body at its installation path** — `~/.dsh/skills/<name>/SKILL.md` (or `~/.codex/skills/<name>/SKILL.md`) as-is; those are junctions, and re-assembling a path from the junction target is how a round ended up asking for a path **one directory level short** (the junction target rebuilt without its repo root) instead of the real install path (the skill was fine; the path was wrong). **If a read fails, try the other harness directory, then the self-use library path — never stop on the error** (V2.052 field: one red line, then two successful reads in the same breath); ② **tiering precision** — a **recoverable** deletion (tracked in git, scope enumerable, restorable) is **mid-stakes** (≥2 rounds), not high-stakes; only **unrecoverable** deletions/migrations count as irreversible (high-stakes, ≥4 rounds). Over-grilling a cheap deletion is safe but wasteful; under-grilling an irreversible one is not. Detail in `references/invocation.md` and `references/core-triggers.md`.

**V2.051: grill-family usage (call `grilling` directly; depth by stakes; real-world probing).**
Same V2.050 behaviour, plus: ① **the three grill skills are wrappers, not different abilities** — `grill-with-docs` = `grilling` + `domain-modeling`, `grill-me` = `grilling`; the harness refuses the two user-invoked wrappers (V2.030: inline-read is reading data), so **call `grilling` (plus `domain-modeling` when ADRs/a glossary are wanted) directly** — "the tool refuses it" is never a reason to skip grilling (measured: only 2 of 20 eval rounds ever grilled, all in Lane B, mostly because the wrapper was unreachable); ② **grill depth is set by the stakes, not by habit** — low-stakes work (a one-line typo/doc) may skip with a written reason, medium work ≥2 rounds, **high-stakes work ≥4 rounds**: anything that will really be used (shipped, handed to others, maintained), anything irreversible (data migration, deletions, public contracts), anything externally visible (publishing). "I will use this long-term / others will use it / it goes live" = high stakes even when the change is tiny; ③ **high-stakes rounds must ask the real-world five** — who uses it in which situation with dirty data, concurrency/repeat/offline, what failure looks like and how it is noticed, how to roll back and who rolls back, how it extends without blocking the next person; ④ **"I am not sure what I want" requests get grilled too** — the goal or symptom is not an executable requirement, so grill until the success criteria are judgeable (and land them as red→green commands or assertions, never as adjectives). Detail in `references/core-triggers.md`.

**V2.050: kickoff-card layout (six fixed lines, one field per line, no inline bold).**
Same V2.049 behaviour, plus: the kickoff card is **six lines, one field per line, in a fixed order** (`开工卡｜…` / `本轮调用：` / `调用面：` / `分流：` / `正身：` / `链·产物：`) — never several fields crammed into one line (V2.050 field: a round collapsed all six into a single paragraph with stray `**` in it, and nobody could tell which fragment was which field); the card carries **no `**` bolding** (fields are separated with `｜`); an over-long value may continue on an indented line, but its field label stays at the start of its own line; when the chat surface may swallow newlines, send the whole card inside a ````` fence. `references/conventions.md` and `references/anchor.md` point at the same layout, and the template lives in Step 0 below. Detail in `SKILL.md` Step 0.

**V2.049: rename-grace + goal-round-autonomy + stale-book-immunity (a rename must not silently unhook a project; a goal continuation is a round of its own; a stale book path in project docs is not authority).**
Same V2.048 behaviour, plus: ① **rename migration — rewrite every old-name reference, don't merely tolerate it** — this skill was renamed (`autopilot` → `automatt`); the credential is now `automatt: on`, and the pre-rename line `autopilot: on` still counts as opted in during the migration window (a rename must not silently unhook a project). Every old-name reference **inside the working project** — the credential line, docs/scripts/config, the old command `/autopilot`, the old logbook filename `autopilot-USAGE-LOG.md`, the old pointer dir `.autopilot/` — is rewritten to the new name **in the same round** (mechanical, enumerable, git-recoverable ⇒ just do it, but list every changed path in the ledger entry); references **outside** the workspace (host config, other repos, `~/.dsh/` install copies) stay read-only under V2.042 ⇒ report them with a one-line migration hint instead of writing. Scan for them during Step 0 recon (V2.049 field: the user's own project still carried the old credential line after the V2.045 rename, so ordinary engineering asks silently stopped being driven, and its AGENTS.md pointed at a logbook filename that no longer existed). ② **goal rounds are rounds** — a harness goal continuation (`<goal_round>`, "继续执行目标", a scheduled continuation) is a **new round**, not the tail of the previous card: re-read `references/anchor.md` (a tool call), open with a `卡刷新`/full card, and close with **its own ledger entry** (`触发=resume`); a goal objective asking for "每轮记录 / 每 N 次反思" is satisfied only when every continuation round lands one entry (V2.049 field: 32 continuation rounds ran with zero skill calls and zero entries, so the ledger and the reflection counter stood still). ③ **「这个 skill / 这个项目」refers to the workspace project, and packaging happens inside the workspace** — the object of a request is the project in the current working directory; if the candidate object lives **outside** it (another repo, the driver repo, the host, a same-named published package), that is an out-of-scope candidate: look read-only at most, then deliver in the workspace or hand the choice to the human — never edit that repo, never bump its version, never package or publish it (V2.049 field: a publish request about "this skill" was aimed at the sandbox project, and the round instead edited the driver repo's `public-claude-plugin.json` version, rewrote `public-npm/bin/automatt.js`, tarballed the real package and started `npm login` — out-of-scope edits rolled back by the parent, and the real package nearly shipped). ④ **stale book names are not authority** — a logbook path quoted in project docs, handoff files or another session's notes (e.g. `autopilot-USAGE-LOG.md`) never overrides the resolution order in `references/usage-log.md`, and a document naming a missing book never justifies creating a second one (two books = a split ledger): resolve by the order and record a 卡点. Detail in `references/usage-log.md`, `references/anchor.md`.

**V2.048: git-in-project-dir (check version control inside the project, not the parent).
Same V2.047 behaviour, plus: run `git status/log` **inside the project directory** (explicit `workdir` or `-C <project>`); an empty output or an "everything ignored" view does **not** mean the project has no version control — re-check in the project directory before concluding that (V2.048 field: a round saw only the parent's ignore list, decided there was no VCS, and shipped an uncommitted delivery). Detail in `references/usage-log.md`.

**V2.047: installed-copy-parity (check the body you actually loaded; relative logbook pointers resolve against the workspace).**
Same V2.046 behaviour, plus: bootstrap also checks that the body it is running matches the source repo's `VERSION` — the harness loads an **installed copy** (`~/.dsh/skills/<name>`, `~/.codex/skills/<name>`), so a lagging install means you are running stale rules (V2.047 field: the installed copy was V2.045 while the repo was already V2.046). Helper: `evals/check-install.mjs` exits non-zero when any installed copy lags. A relative logbook pointer resolves against **this round's workspace**, never the shell's default directory. Detail in `references/usage-log.md`.

**V2.046: delete-granularity (what counts as "deleting data" — unrecoverable deletions stop and ask; tracked, named, enumerable, recoverable deletions are done with a written list of what was removed).**
Same V2.045 behaviour, plus: the STOP list's "删数据" means deletions that **cannot be recovered from version control** (untracked local data, credentials, user output, anything outside the repo) → write `.scratch/<slug>/NEEDS-HUMAN.md` and stop. Deleting **version-controlled files the user explicitly named, whose scope you can enumerate and can recover from git** is allowed to proceed — but you must list every deleted path in the ledger entry/receipt and note the collateral edits (emptied directories, doc sections that only pointed at the removed files). If you cannot tell which side of the line a request is on, stop and ask. Detail in `references/delivery-check.md`.

**V2.045: rename-to-automatt (the skill is now named `automatt`; the opt-in credential is `automatt: on`, the command is `/automatt`, the logbook is `automatt-USAGE-LOG.md`).**
Same V2.044 behaviour — **no rule changes**: this release only renames the skill and everything keyed to its name (package directory, frontmatter `name:`, display name, opt-in credential `automatt: on|off`, slash command `/automatt`, central logbook and its pointer directory `.autopilot/` → `.automatt/`, install directory and harness junctions, public package directory and repo slug). Detail in `CHANGELOG.md` and `deploy/`.

**V2.044: bookkeeping-calibration (chain = execution order; gate scan scope; survey has no HTML dashboard).**
Same V2.043 behaviour, plus: `链:` records the **execution** order, not the order skills were *loaded* (pre-loading a body before executing it is legal and invisible to the chain; a review→fix→retest→re-review loop lists each skill once), so item ⑤ is judged against execution order; the typo/version/number gates grep **product files only** and exclude driver-owned artefacts (`.scratch/`, the ledger) so old-string citations in NOTES/audit do not fake a red; read-only survey rounds never build an HTML dashboard or dispatch sub-agents even if the survey skill's body asks for them (the driver wins — list + `file:line` in chat); and a request whose object exists only inside the host (parent-session source, host config, plugin, GUI panel) is a **host scenario** → `NEEDS-HUMAN.md`, never a self-authorised install. Detail in `references/usage-log.md`, `references/verification-gates.md`, `references/prelane.md`.

**V2.043: ledger-target (confirm the workspace before you write; absolute log paths).**
Same V2.042 behaviour, plus: before appending the ledger entry, confirm the workspace (`pwd` — the shell's default directory may be the session's start directory, not this round's workspace) and resolve the logbook in the order *workspace pointer → workspace-local `automatt-USAGE-LOG.md` → installer's fixed path*; the `落本:` line carries an **absolute** path, and writing to any other book is contamination that must be rolled back and recorded in `deviation:` (V2.043 field: a read-only round appended its entry to the production logbook because the shell sat in the driver repo). Detail in `references/usage-log.md`.

**V2.042: change-boundary (project workspace only; harness and host profile are read-only).**
Same V2.041 behaviour, plus: the round may only modify the **current project workspace** — harness/host/user-profile paths (`~/.dsh/`, `~/.codex/`, global `node_modules/`, plugin dirs, `cordis.patch.yml`, registry, `app.asar`) are read-only; a request like "add a button" means the project's own UI unless the user names the host, and even then it goes to STOP (`NEEDS-HUMAN.md`) instead of self-authorising an install. Deliverables outside the project = malformed (no entry = not landed), and any out-of-scope host edit must be rolled back and recorded in `deviation:`. Detail in `references/prelane.md`.

**V2.041: chain-boundary-and-read-only-fields (reading a body is a call; setup state is checked in Step 0; read-only rounds get their own field).**
Same V2.040 behaviour, plus: a Skill call **or** an inline read of a body counts as an invocation and must appear in `链:`/`Skills called:` — judging it n/a afterwards still keeps the name in the chain, with the reason in `未用:` (⑤); the card's `分流:` line carries `setup <done|needed|n/a>` so the setup marker is checked before lane work, not after implementation; and read-only/query rounds write `产物: …=对话内报告` (no `test -f`) plus a `检索面: …｜命中=<n>｜零改动=<是|否>` line instead of inventing fields. Detail in `references/usage-log.md`.

**V2.040: ledger-mechanics (every product path must exist; script-downgraded audits say so; a deviation forces a reflection card).**
Same V2.039 behaviour, plus: each `产物:` path must pass `test -f` — no compressed stand-ins like `test/x.s1-3.test.js` for three real files (⑦b); `审计:` accepts a `(脚本降级)` suffix so "no subagent harness" is machine-readable; `deviation:` non-none forces a `摩擦:` line **and** a `## [反思]` card (⑨ M5b); and a repo-local logbook (eval/hermetic) must be committed after append, while an installed out-of-repo logbook commits nothing. Detail in `references/usage-log.md`.

**V2.039: round-bookkeeping (probe-then-card is legal; chains carry skill names only; read-only rounds have a legal audit anchor).**
Same V2.038 behaviour, plus: T0 may run **before** the kickoff card (the card is not a skill action — probe `ask-matt`, then fill `调用面:`), and the card gains the fixed `正身/必读集` line (`core-triggers.md`「开工点名」no longer needs a self-invented row); `链:`/`Skills called:` list **skill names only** — no `automatt`, no lane label; read-only rounds point `审计:` at `.scratch/<slug>/audit.log` and put the `Skills called:` anchor in the final message (no NOTES). Detail in `references/usage-log.md`.

**V2.038: chain-coverage-and-audit-path (list every skill you called; the audit path must exist).**
Same V2.037 behaviour, plus: `链:` and `Skills called:` must both list **every skill actually invoked in the round** — including support skills used only for verification (browser-act, improve-codebase-architecture) — in call order; a chain that reads as a "logical order" or silently drops a verification skill is a ⑤ failure. The `审计:` receipt path must exist on disk (repo-relative or absolute); a path to a missing file is a ⑦b failure. Detail in `references/usage-log.md`.

**V2.037: closeout-order-and-scope (land the entry before the final message; survey requests stay read-only).**
Same V2.036 behaviour, plus: the ledger entry is appended and read back **before** the final closeout message (and may ride along in its own chore commit) — code, NOTES and audit without an entry is “not landed”; “what is worth improving / any problems / review this repo” is a **read-only survey** (ranked list + file:line), not an instruction to change code; `setup` may ship as a same-round chore commit (only running it *after* implementation is scope creep); and a skill refused by the harness is `inline`, not `missing` (prove `missing` with `test -f` on the installed body). Detail in `references/usage-log.md` and `references/invocation.md`.

**V2.036: read-only-is-a-task (lane=none is not a protocol exemption).**
Same V2.035 behaviour, plus: every round — including `lane=none`, pure understanding, and read-only/query — starts with T0 (`ask-matt` tool or inline) and ends with a central ledger entry; loading this driver is not T0 and never replaces it. A read-only round that skips the card or the entry is malformed. (V2.036 field: a diary-query round loaded the driver, skipped T0, wrote no entry.)

**V2.035: order-and-isolation (review is last; single-round cards are legal; eval material stays out of reach).**
Same V2.034 behaviour, plus: `code-review` is always the **last** skill in `链`; any `tdd`/`implement` runs before it, otherwise record a deviation; a single-round subagent with no intermediate visible message may put the card at the top of NOTES and repeat its first paragraph in the final message; a delegation depth of 0 counts as “no subagent harness” for fast-track review/audit; Lane B's self-answered grill does not require calling `grilling`/`domain-modeling` (the `grill-with-docs` body's “call twice” applies to the skill's own session form).

**V2.034: log-discipline (na is not a free pass).**
Same V2.033 behaviour, plus: typo/doc/single config-row work is **Lane A, never `na`**; even a `na` round writes the ledger and commits (non-git excepted) — “the parent will log it” is malformed; `审计:` must point at an audit receipt, never `LOGBOOK-RECEIPT`; `PASS-gaps(n)` counts the 6-step closeout list; an installed-but-refused skill must be inline-read, never bundled-fallback; the kickoff card carries an explicit `调用面:` line.

**V2.033: log-consistency (this build ships no logbook).**
Same V2.032 behaviour. Read-only/query rounds no longer write a child receipt; the ledger's chain must equal `Skills called` in order; a self-check line records version/watermark/chain-product; the project-notes pointer must be an existing file; setup may run only in the first engineering round before implementation.

**V2.032: log-instrumentation (evaluation-side tooling + two driver tightenings).**
Same V2.031 behaviour, plus evaluation-side tooling (multi-frame transcript decode, canary self-check, two-rate log metrics) and two text tightenings: `审计: PASS-gaps(n)` counts the failed closeout-gate checks, and every `规则:` line in a friction ticket / observation card must carry a verbatim quote of at least 8 characters.

**V2.031: log-evidence (this build ships no logbook).**
Same V2.030 behaviour. Friction about the workflow itself is recorded as a trace note carrying a rule reference (`file:line`) and a candidate change; narrative five-aspect entries and marker-based reflection counting are retired.

**V2.030: invocation-capability (tool refusal is not "missing").**
Same V2.029 behaviour, plus: some harnesses honor a sub-skill's `disable-model-invocation: true` and refuse the Skill-tool call (DSH does; 16 of 27 sub-skills carry the flag, including 5 of the 8 core). The driver now has a legal, auditable inline path: on refusal it reads the installed `SKILL.md` body as the round's first *skill* action for T0 (`ask-matt`) and as `name(inline)` for every other skill, records `调用面:` + `file:line` + substitution, never retries the refused call, and treats a body-less skill as `missing`. Loading this driver is never T0. Detail in `references/invocation.md`.

**V2.029: log-boundary (this build ships no logbook).**
Same V2.028 behaviour. Friction about the workflow itself (which skill should have fired, which rule was vague or contradictory) is recorded as deviation notes in the round's trace; project-domain material (root causes, decisions, thresholds, ops details) belongs in the project's own notes/docs, never in a shared skill log.

**V2.028: frontmatter fix (YAML-safe description).**
Same V2.027 behaviour; v2.028 fixes packaging: the SKILL.md description is now a quoted YAML scalar — an unquoted ": " inside it made the frontmatter invalid YAML, so strict harnesses (e.g. DSH) silently dropped the whole skill while lenient ones (opencode) still listed it. `evals/check-frontmatter.mjs` guards this.

**V2.027: opt-in-gate (project credential + default-off global gate).**
Same V2.026 behaviour, plus: automatt takes over only where the project opted in — a standalone line `automatt: on` in an `AGENTS.md` between the cwd and the repo root (`automatt: off` vetoes); the global instruction file is a negative gate with explicit-ask and resume-only exceptions; implicit task-shape triggers in the description now require that credential. Detail in `references/` and `deploy/`.

**V2.026: pre-trust (pre-adoption falsification + gate-landing calibration).**
Same V2.025 behaviour, plus: load-bearing conclusions get an independent red-team on the conclusion itself before adoption (narrower sub-questions don't count); criteria/gate drafts get pre-implementation adversarial audit and proposals get measured-audit; every new gate lands with a satisfaction example, a never-red worst-direction argument, a worst-case constant sweep, and an explicit coverage statement for "all green" claims; verdict readings cite their writer. Detail in `references/`.

**V2.025: execution-trust (round protocol, per-round re-anchor, artifact loop, tier discipline).**
Same V2.024 behaviour, plus: every round emits a kickoff card (task/slug/lane/tier/正身/chain·product/first action) before any lane work — no card, not started; every round opens by reading the 12-line `references/anchor.md`, superseding "later rounds skip the re-read"; no product = that step did not happen; trace notes carry `产物/deviation` lines. Detail in `references/`.

## Trigger table (one line per skill; fire at its moment, no human prompt)

- `ask-matt` — T0 lane routing that opens every round.
- `grill-with-docs` — sharpen an idea inside a working directory.
- `grill-me` — sharpen an idea with no working directory.
- `grilling` — bare interview primitive: opening zero-side-effect use + the ONLY legal mid-lane grill form (continuous-grilling, V2.018).
- `research` — delegate outside-fact reading to a background agent.
- `prototype` — answer a design question with throwaway runnable code.
- `handoff` — bridge across harness, directory, or colleague boundary.
- `to-spec` — turn a sharpened idea into a buildable spec.
- `to-tickets` — split a spec into blocked tracer-bullet tickets.
- `implement` — build one ticket in fresh context.
- `implement-spec` — multi-ticket frontier in parallel, one integration branch.
- `tdd` — red-green one seam at a time inside implement.
- `code-review` — two-axis Standards + Spec review before commit.
- `pr` — PR body only: smallest visual + before/after evidence + door call.
- `retro` — post-build environment retrospective, in-session before clear.
- `diagnosing-bugs` — hard bug: Phase-1 tight loop first, then fix.
- `wayfinder` — foggy multi-session effort: chart a decision map first.
- `triage` — raw incoming pile; `to-tickets` output stays untriaged.
- `domain-modeling` — fuzzy domain terms; irreversible calls go ADR.
- `codebase-design` — competing implementations or a misplaced seam.
- `improve-codebase-architecture` — spare-moment health survey, suggest-only.
- `setup-matt-pocock-skills` — first touch in a repo, once, then audit-only.
- `teach` — multi-session learning in single-file lessons.
- `to-questionnaire` — blocked on someone else's head; send questions.
- `wait-what` — re-pitch a message that did not land, in plain words.
- `wizard` — human-only wall: scope stages, then STOP with NEEDS-HUMAN.
- `writing-for-agents` — author or evolve agent-consumed docs.

Trigger detail (entry checklists, cadences, environment honesty) rides in
`CHANGELOG.md` version blocks and the `references/` split files — the table
above only routes; the pointed file decides.

## Round protocol (emit, then run — V2.025)

0. **Bootstrap (session's first round / after any compact·clear / version
   mismatch / unsure):** re-read this SKILL.md and the `references/` files it
   points at (stale rules in context are worse than no rules). Then read the
   project convention tail, the last 5 JOURNAL entries, and the last 10
   `calls.log` lines before acting. A fresh window that was not invoked checks
   for `.scratch/WORKFLOW-ACTIVE.md` via the standing AGENTS.md hook (see
   `references/trace-discipline.md`) and re-invokes this driver itself.
1. **Step 0 — reconnaissance, then the kickoff card (the round's first visible
   deliverable).** Cheap recon first: split → shield grep → Gate 0 → lane verdict →
   this lane's read-set. Then emit the card; **no card = no lane work.** Fixed
   fields, ≤8 lines:
   - `开工卡｜任务：<one line>｜slug：<slug(s)>｜lane：<A|B|C|D|E|none(纯理解)|STOP>｜档位：full|lite(<why>)|na(<why>)`
   - `本轮调用：<中文名（一句为什么）→ …>`（原可见首句并入此处，不再另写）
   - `调用面：<skill=tool|inline(read path:line)|missing；…>`（V2.034；只列本轮要用的 skill）
   - `分流：shield <hit/n-a + grep>｜Gate0 <HIT/BROKEN/NOT-FOUND/MISS @file:line>｜setup <done|needed|n/a>`（V2.041：setup 状态位必须在 Step 0 查掉——`docs/agents/` 标记在不在；needed 就在进 lane 前跑，别等实现完才想起）
   - `正身：<本轮点名的 skill 清单>｜必读集：<paths:lines>`（V2.039；`core-triggers.md`「开工点名」要的那两样就落这一行，别再自造行）**必读集里必须含 `references/conventions.md`**（V2.053：slug 命名、文件布局、**提交口径**都在那儿；晚读它会与「`.scratch` 进不进仓」当场打架，只能收尾回改）
   - `链·产物：<skill → its minimal product path；…>｜第一动作：<next concrete action>`
   **卡片排版（V2.050，硬门）**：**六行、每行一个字段、顺序固定**，不许把多个字段挤进同一行
   （现场：某轮把六行并成一段、中间还夹着 `**` ⇒ 糊成一堵墙，读者看不出哪个字段是哪���）。
   - ① 每行行首必须是字段名（`开工卡｜…` / `本轮调用：` / `调用面：` / `分流：` / `正身：` / `链·产物：`），**一行只允许一个字段名**；
   - ② 卡内**不写 `**` 加粗**（行内加粗 + 长行 = 渲染成糊墙）；字段间分隔用 `｜`；
   - ③ 值太长（如必读集一串路径）可以**续行**，续行缩进两格并以 `·` 起头，字段名仍留在自己的行首；
   - ④ **整卡一律包在 ``` 围栏里发**（V2.055：不再判断「聊天端会不会吞换行」——同一个 DSH 窗口有时渲染成块、有时挤成一整段，**围栏是唯一每次都被尊重**的形态）；NOTES.md 里同样按这六行写（围栏可不留）。
   - ⑤ **单行别超过 ~120 字**：超长的值（必读集、产物清单）走缩进续行（`·` 起头），别把一行拉成一段——那是「挤在一起」的另一半原因。
   照抄这个模板（尖括号换成实际值）：

   ```
   开工卡｜任务：<一句话>｜slug：<slug>｜lane：<A|B|C|D|E|none(纯理解)|STOP>｜档位：full|lite(<why>)|na(<why>)>
   本轮调用：<skill（一句为什么）→ skill（一句为什么）>
   调用面：<skill=tool|inline(read <path>:<line>)|missing>｜<skill=…>
   分流：shield <hit/n-a>｜Gate0 <HIT|BROKEN|NOT-FOUND|MISS @file:line>｜setup <done|needed|n-a>
   正身：<skill 清单>｜必读集：<path:line、path:line>
   链·产物：<skill → <产物路径>>｜第一动作：<下一个具体动作>
   ```
   **Order against T0 (V2.039):** the card is not a skill action, so T0 may run
   first — probe `ask-matt` (tool call, or the inline read when the harness
   refuses), then emit the card with the probe result filled into `调用面:`.
   Probing before the card is **not** a deviation. What *is* a deviation:
   reaching lane work or any execution-class skill before the card lands, and
   emitting a card whose `调用面:` line is left empty.
   Chat always shows the card; lane rounds also write it (with file-level
   read-set detail) at the top of `NOTES.md` (read-only rounds: chat only).
   A completed round without a card is malformed. Tier floors and the
   never-trim list live in `references/self-answer.md`.
2. **Step 1 — T0.** One `ask-matt` call leads the Skill-tool order (a late-added
   `ask-matt` does not satisfy T0; loading this driver is not T0). If the
   harness refuses the call (`not available for model invocation`), inline-read
   the installed `ask-matt/SKILL.md` as the round's first *skill* action
   (driver load and Step 0 recon excepted), record `ask-matt(inline)` on the
   card, and continue (see `references/invocation.md`). `ask-matt` is a routing map, not a judge —
   the lane verdict is your own prelane decision (V2.015). Quote the gate verdict
   on any round that ran Gate 0 against a fresh change surface (first touch of a
   repo, or a re-run on new work); `gate n/a (touched)` stays the display
   shorthand for later same-repo rounds — Gate 0 itself still re-runs whenever
   the change surface is new, and the real verdict goes to NOTES. In a
   proven-verdictless project, skip re-invoking T0 after the session's first
   round and note `T0 downshift` on the card.
3. **Step 2 — lane run.** Call every listed skill in order — call trace + a
   returned-summary quote, inline substitutions noted — and leave each step's
   minimal product (spec / issues / red-green / review verdict / verify output;
   `core-triggers.md` decides). **No product = that step did not happen.**
4. **Step 3 — gates.** Run the lane's verification gates; quote the verdict.
5. **Step 4 — close.** Append the trace note (product/deviation lines; this build ships no
   logbook), then write the `Skills called:` line in call order (grep-audit anchor: top of `NOTES.md`, or the **final
   message** on read-only rounds that write no NOTES). `链:` and
   `Skills called:` carry **skill names only** — never the driver name
   `automatt`, never a lane label (`lane-a`, `LaneA`) (V2.039). Then **end the
   reply with the human-facing twin** (V2.055): the final message's **last line**
   is `本轮流程: <skill> → <skill> → …`, carrying the same names in the same
   order as `Skills called:` (e.g. `本轮流程: ask-matt(inline) → grilling →
   to-spec(inline) → tdd → code-review`); nothing follows it, and read-only /
   STOP rounds carry it too — a reply without it is malformed. Read-only
   rounds point `审计:` at `.scratch/<slug>/audit.log` — driver-owned, not a
   repo file (V2.039). Closeout per
   `verification-gates.md`; delete the marker (single-round open-close
   exemption unchanged). One round = one commit = one JOURNAL entry; keep ≥2
   distinct skills per round (T0 + one executed lane/support skill); rotate
   lane/type before 3 identical sets repeat; cap audits at 3 consecutive.

**Re-anchor (supersedes "later rounds in the same session skip the re-read").**
Full re-reads still happen per step 0. Every other round opens by reading
`references/anchor.md` (a real tool call, never a memory check) and emitting one
`卡刷新｜lane=…｜正身=…｜下一步=…` line; a new task, a new slug, or an
understanding round turning into work goes back to Step 0 with a fresh full card.
A round missing its refresh line is a deviation. A goal continuation is a
round, not a tail (V2.049): when the harness resumes the objective by itself
(`<goal_round>`, "继续执行目标", a scheduled continuation), treat it as a fresh
round — re-read `references/anchor.md` as a tool call, open with one
`卡刷新｜lane=…｜正身=…｜下一步=…` line, and close with its own ledger entry
(`触发=resume`). Resuming the goal does not resume the previous round's
bookkeeping: an entry belongs to the round that produced it. A fresh dialogue resumes from
these files alone; when it cannot, file a proposal fixing this driver.

Lane choice (Gate 0 → shield → A/B/C/D/E), self-answer policy with STOP list,
verification gates, and trace rules are executed from `references/prelane.md`,
`references/self-answer.md`, `references/verification-gates.md`,
`references/trace-discipline.md`, `references/ground-truth.md`, and
`references/context-hygiene.md` — same force as inline text.
