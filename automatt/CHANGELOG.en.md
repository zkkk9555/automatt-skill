English | [简体中文](./CHANGELOG.md)

# CHANGELOG — automatt

**2.0.62** — Two hard rules: ① **nobody is coming to commit for you** — the round's own agent must `git add` + `commit` its output (a repo-local logbook goes in with the round; a read-only round commits as `chore`; only a STOP round that must not touch the workspace is exempt), and ending with "leaving it for you/the parent to commit" is not allowed (two acceptance rounds ended exactly that way, which from any other machine means the round never happened); ② **`调用=` is now defined** as the number of names in the chain = tool calls + inline reads (the earlier wording contradicted itself).

**2.0.61** — Fixes a whole class of "never took over" failures: in a legacy project whose `AGENTS.md` still says `autopilot: on`, an agent looked up `autopilot`, failed, and concluded the workflow was unavailable — so it worked bare, left no ledger entry and no commit. The cause was the **skill description** (the only text visible *before* loading): it described the old name as **not opted in**, which reads as a reason not to fire. Now it is the opposite polarity: an old-name credential **counts as opted in, as a conversion target** (take over first, then rewrite that line to `automatt: on` and `.autopilot/` to `.automatt/`), and a failing lookup of the old name is **never** "the workflow is unavailable" — it was merely renamed. This lives in the description rather than the body because the body is unreachable until the skill is loaded.

**2.0.60** — The "which skills did this round use" chain now has to **add up**: the ledger's self-check line carries `调用=<n>` (how many `skill` calls the round really made), and **the chain must contain exactly that many names** — count the calls, count the chain, fill the gap; a name in the chain that was never called is equally wrong. Reason: "list them all" is a memory task and memory slips (the previous release caught `code-review` and `domain-modeling` missing), while a count is self-checkable. Same batch fixes one judge false positive: the closing footer is looked for in the last three messages.

**2.0.59** — The "which skills did this round use" chain is now **transcribed from the actual call log**, not recalled: at closeout you replay every skill the round really invoked (**support skills like `domain-modeling` included**) into the chain and the closing `本轮流程:` line. One-line self-check: **as many names as Skill-tool calls**. If the plan on the card disagrees with reality, reality wins. Same batch fixes five judge false positives (temp-dir drafts, stray drafts outside the workspace, audit paths followed by prose, products pointing at files deleted this round, and a change-list ordering bug).

**2.0.58** — Makes "re-read the rules" something that actually happens: a **re-anchor trigger table** (read the 14-line anchor every round; read the full `SKILL.md` on a new task, after a compaction/clear, when the memory self-check fails, after ≥5 assistant turns or ≥40 tool calls, on a lane switch, before writing the ledger, and on a version mismatch) — and **every re-read leaves a trace** (`自检:` gains a field like `重锚=anchor@每轮` / `重锚=full@新任务`). Why: rules do not vanish, they get squeezed out of a long conversation — that is exactly the "card still written, rules no longer in mind" failure the previous release caught. **A round without a re-anchor trace is treated as unjudgeable.**

**2.0.57** — Guards against "the rituals without the rules": the kickoff card, the ledger entry and the closing `本轮流程:` line are **only legal in a round that actually loaded `automatt`** (a `skill` tool call, or an inline read of the installed body, with that load trace recorded on the card and in the entry). **Emitting those three artifacts without the load is forged takeover and is judged as an error** — it is worse than not taking over, because "did the workflow really run?" becomes unverifiable. Two more rules: the card's `正身:` line lists sub-skills only (**never `automatt` itself**), and `本轮流程:` must not be empty (writing "no sub-skills called" means no flow ran — then there should be no card at all).

**2.0.56** — The version is now written as plain semver (`2.0.56`) instead of `V2.055`. **No behaviour change**: this release only unifies the spelling — `VERSION`, the npm package, the plugin manifest, the installer's pinned ref and both repositories' tags now carry the **same string**, so there is no longer a `V2.055` / `2.0.55` pair to reconcile. Historical entries keep the name each release had.

**V2.055** — Two visible changes: ① the **kickoff card always ships inside a code fence** (it used to be fenced only "when the surface may swallow newlines", so the same window rendered it as a tidy block one round and as one crammed paragraph the next), with a ~120-character line budget and indented continuation lines; ② **every round's reply ends with one `本轮流程:` line** naming the skills it actually used, in call order (same order as the ledger chain, driver name never included) — "did it really use the skill?" is now answerable from the chat. Plus three gate disciplines: after three false hits on lawful content, **fix the gate instead of rewording the content**; run a newly written assertion/verdict script **against a real artifact first**; and when a project has no git history, **use a file-snapshot baseline** rather than skipping the review.

**V2.054** — Rename migration keeps **one mechanism**: convert the opt-in point, no grace window. The only credential is `automatt: on`; in an old project every old name **pointing at this skill** (the credential line, the invocation line) and this skill's own pointer dir `.autopilot/` become the new name in the same round; **files outside AGENTS.md are never touched** (old names in the user's README/docs/scripts/config are the user's text — not ours to rewrite) and they never justify creating a second logbook; a read-only round writes nothing, so it only ends with a one-line migration hint; when the driver writes an opt-in credential itself it writes the **new name only**.

**V2.053** — Three field fixes: judging `setup n/a` in a project with no tracker need (eval fixture, drill repo, script-only repo) is a **lawful verdict**, not friction; a concrete symptom ("the total is one cent short", "the button does nothing") means a **fix round**, not a read-only query; the externality shield stops the **external action**, not in-workspace preparation (packaging lists, a publish wizard that only rehearses, `NEEDS-HUMAN.md`, read-only fact checks are all allowed — acting for the human, editing another repo, touching credentials = stop and hand over); the review fast-track covers delegation exhaustion; `references/conventions.md` joins the must-read set.

**V2.052** — Install-body path and deletion tiering: read an installed body **at its installation path** (`~/.dsh/skills/<name>/SKILL.md`), never re-assembling the path from the junction target; if the read fails, try the other verified path instead of stopping on the error; a **recoverable** deletion (in version control, enumerable scope, restorable) is mid-stakes (≥2 rounds), an **irrecoverable** deletion or data migration is high-stakes (≥4 rounds).

**V2.051** — The grill family gets used for real: `grill-with-docs` = `grilling` + `domain-modeling`, `grill-me` = `grilling` — call `grilling` directly; **"the tool refuses it" is never a reason to skip grilling**; depth follows the stakes (low may skip with a written reason, medium ≥2 rounds, high ≥4 rounds), and high-stakes rounds must ask the real-world five; a request that says "I don't know what I want" gets grilled too, until the success criteria are judgeable.

**V2.050** — Kickoff-card layout: **six lines, one field per line, fixed order**; no `**` bolding inside the card, fields separated with `｜`; when the chat surface may swallow newlines, send the whole card inside a code fence.

**V2.049** — Rename migration + goal rounds + stale-book immunity: after a rename the driver **rewrites the old-name references inside your project** (the opt-in credential line, old names in docs/scripts/config, the old `/autopilot` command, the old `autopilot-USAGE-LOG.md` book name, the old `.autopilot/` pointer dir) and lists every changed path; the legacy credential line `autopilot: on` still counts as opted in during the migration window (a rename must not silently unhook a project); a harness goal continuation is a **round of its own** (re-read the anchor, open with a card refresh, close with its own ledger entry), so "one entry per round + a reflection card every N entries" now holds inside goal loops; a book path quoted in project docs is not authority and never justifies creating a second ledger.

**V2.048** — Run git **inside the project directory**: an empty or "everything ignored" view in the parent repo does not mean the project has no version control — re-check in the project directory before concluding that.

**V2.047** — Installed-copy parity: at bootstrap, compare the version of the body you actually loaded with the source repo `VERSION` (the harness loads an installed copy); a relative logbook pointer resolves against **this round\u2019s workspace**.

**V2.046** — Delete granularity: unrecoverable deletions stop and ask; tracked + named + enumerable + recoverable deletions proceed but list every removed path; the logbook pointer may be a workspace-relative filename, and a stale pointer falls back by the resolution order.


**V2.045** — Renamed: the skill is now `automatt` (previously `autopilot`) — the old name was hard to remember and easy to collide with other skills. **No rule changes**: only identifiers move — package directory and frontmatter `name:`, opt-in credential `autopilot: on|off` → `automatt: on|off`, command `/autopilot` → `/automatt`, central logbook `autopilot-USAGE-LOG.md` → `automatt-USAGE-LOG.md` (and its pointer directory `.autopilot/` → `.automatt/`), install directory and the skills mount name in every harness, plus the public package directory and repo address (`user/automatt-skill`, the old address redirects).

Single version scheme: `V2.00N`. (Early private iterations used internal vNN
numbers — v41=V2.001, v43=V2.002, v44=V2.003, v45=V2.004, v46=V2.005,
v47=V2.006, v48=V2.007, v49=V2.008. Retired as of V2.008.)

**V2.038** — Chain coverage and audit path: `链`/`Skills called` must list every skill invoked in the round (including verification-only support skills) in call order; the `审计` receipt path must exist on disk.

**V2.037** — Closeout order and scope: the central entry is appended and read back before the final message; “what is worth improving / review this repo” is a read-only survey; setup may ship as a same-round chore commit; a harness-refused skill is inline, not missing.

**V2.036** — Read-only is a task: read-only/query rounds still need T0 (ask-matt tool/inline), the card/refresh, and a central entry; lane=none is not an exemption.

**V2.035** — Order and isolation: code-review closes the chain (tdd/implement before it); a single-round subagent may put the card in NOTES and repeat it in the final message; delegation depth 0 counts as no-subagent harness; Lane B self-answered grill does not require calling grilling/domain-modeling; eval material is moved out of the repo during test windows.

**V2.034** — Log discipline: typo/doc/single config-row work is Lane A, never na; even na rounds write and commit; Audit must not point at LOGBOOK-RECEIPT; PASS-gaps(n) counts the 6-step gate list; an installed-but-refused skill is inline-read, never bundled-fallback; the card carries an invocation-surface line.

**V2.033** — Log consistency: read-only/query rounds no longer write a child receipt; `chain` must equal `Skills called` in order and cover every artifact skill; B–E need ≥2, Lane A/read-only may run one; the ledger gains a `self-check` line; the project-notes pointer must be an existing file; repo-state/central-log queries use the read-only protocol; setup only in the first round before implementation.

**V2.032** — Log instrumentation: a hermetic logbook via `.autopilot/usage-log-path` (evals never touch the production book), a multi-frame transcript decoder, a canary self-check (rubric ⑩; a broken judge invalidates the run), and two-rate log metrics; tightened `PASS-gaps(n)` and reflection quote requirements.

**V2.031** — Log evidence: the task entry becomes a receipt ledger (chain / artifact map / rule-level blockers with file:line / landed receipt / log ownership); friction tickets are written only when something went wrong; reflections become event-triggered observation cards (recovery / declared-vs-executed / conflicting rules / uncovered paths / decidability). Closeout must read the `landed` line back; child sessions write a receipt. The narrative five aspects and the “gap/other” questions are retired.

**V2.030** — Invocation capability: when a harness honors `disable-model-invocation` (DSH), a refused Skill-tool call does not mean the skill is missing — the driver reads the installed body inline, records `调用面:` + `name(inline)` + `file:line`, and never retries the refused call. T0 belongs to `ask-matt` (tool or inline); loading autopilot itself is not T0.

**V2.029** — Log boundary: the central logbook records **skill-side friction
only** (which skill should have fired, which rule was vague, which gate was
bypassed, what broke in the logging/reflection machinery); project-domain
material (root causes, decisions, thresholds, ops details, next-round state)
lives in the project's own `NOTES.md` / spec / `docs/`, with a single
`Project notes:` pointer left in the logbook. Every task entry carries a
`Log ownership: skill` line; reflection entries are headed skill-side and must
point back at a skill file.

**V2.028** — Packaging fix: the SKILL.md description is now a YAML-legal scalar
(an unquoted `: ` made strict parsers drop the whole skill — DSH did); a
frontmatter packaging gate was added.

**V2.027** — Opt-in per project: autopilot takes over only when an `AGENTS.md`
between the cwd and the repo root carries the standalone line `autopilot: on`
(`autopilot: off` vetoes); the global instruction becomes a default-off gate;
the skill description splits explicit asks (unconditional) from implicit task
shapes (credential required).

**V2.026** — Pre-trust: red-team the conclusion itself before adoption; gate-landing
checklist (satisfiability example, never-red argument, worst-case constants,
coverage statement); readings cite their writer; parallel write-boundary rules.

**V2.025** — Execution trust: every round emits a kickoff card (task/lane/tier/
skill-list/chain·product/first action) before any work — no card, not started;
per-round re-anchor plus conditional re-read replaces "later rounds skip the
re-read"; no product = that step did not happen (product/deviation/audit lines);
full|lite|na tier discipline; read-only/query minimal protocol; closing
read-only audit pass; trigger-layer templates (global/project hooks, /autopilot
command, see the repo's deploy/).

**V2.024** — Closeout trust: the central entry belongs to the working lane,
round settlement (b-round replacement / increment accounting / closeout evidence
checklist), reflection counting unit.

**V2.023** — Enforcement hardening: hard traces (call trace + returned-summary
quote), entry hard gate, STOP precheck and per-lane product gate, gate-trust
continuation (swallow ban / anchor mutants).

**V2.022** — Gate trust: no-subagent review endorsement, gates with red
baselines on real data and abstaining shadows, brief-and-audit quota.

**V2.021** — Upstream alignment: 25→27 sub-skills (added
implement-spec/pr/retro, dropped resolving-merge-conflicts), CONTEXT renamed
GLOSSARY.

**V2.020** — Trigger audit: roll-call trace check, file-state counting,
evidence-to-repo / log-to-logbook.

**V2.019** — Load discipline: roll-call invocation, per-lane reading,
single-round marker exemption.

**V2.018** — Continuous grilling: frontier-empty opening, six mid-lane hard
gates, bare grilling only mid-lane.

**V2.017** — Evidence discipline: receipt reconciliation, single benchmark
source, calibrated thresholds, control experiments.

**V2.016** — Round boundaries: understanding without edits, freshness
heartbeat, version self-check.

**V2.015** — Logbook diet + T0 truth: watermark-tail reads, ask-matt is a map
not a judge.

**V2.014** — Rename mattpocock-skills → autopilot (zero rule changes).

**V2.013** — Version handoff packet for cross-harness moves.

**V2.012** — Author alignment: grill→prototype exit, full triage suite, frozen
specs.

**V2.011** — Destructive guard: file-level red-phase backup, negative
evidence, marker counters.

**V2.010** — Official alignment: setup state bit, grill steering, prototype
gate, orchestration iron rule.

**V2.009** — Long-task hardening: frozen spec baseline, four closing audits,
tdd-n/a marking, steady heartbeat.

**V2.008** — Field distillation from 20 task entries + 3 driver reflections.
Self-scan checklist extended (green-lock question after red→green; forced
slowdown after 3 consecutive failures; same-file regression smoke; design-fork
nudge toward codebase-design). No-harness expected values must cite an
independent truth source, with at least one guard assertion differing from the
buggy output. Test-registry discipline (one unified entry, every test
registered, costly tests tiered). External review handling (reproduce → fix →
reply with red/green evidence). Adopted field remedies (shell-append for the
logbook, NOTES as JOURNAL fallback, Edit-tool over scripted replace,
Windows/MSYS notes). B-vs-D routing contradiction pinned: user-reported bugs
always take the diagnosis lane; Gate 0 gains a BROKEN exit; non-git
code-review fast-track made explicit.

**V2.007** — Scheduled reflection. Every 3 engineering rounds, after task
close, the driver appends a reflection entry to the central logbook: fixed
goal preamble + five evidence-based questions (invocation timing / vague
rules / self-invented workarounds / biggest gap to the goal / other). Counting
is tolerant by design; reflections only ever land in the logbook.

**V2.006** — Utilization & continuity, hardened by six real field runs.
Real-skill-first (bundled fallbacks only for uninstalled skills; skipping the
real skill = logged deviation). Task-needed external facts go through the
research form (background agent + cited notes). 15-second mid-execution
self-scan of core triggers. Same-session continuity (full re-read only at
session start / after compact / when unsure). WORKFLOW-ACTIVE marker plus a
standing AGENTS.md hook so a fresh window re-invokes the driver itself. Setup
must precede the first code-touching round. User policy codified: spend
tokens before asking a human — review and verify are never exempted.

**V2.005** — Eval-hardened against three plain-language test prompts (a broken
toggle, a copy-time button, a vague project idea). Chinese short requests
trigger directly; symptom text alone satisfies the bug-lane entry;
pure-understanding tasks enter no lane; doc-only sub-skill replies are
executed inline with a noted substitution; no-verify repos invent a seam
assert + smoke.

**V2.004** — Logging is part of task close, not user-prompted: one entry per
task (delivered/STOP/BLOCKED) in the central logbook; cross-round tasks log
once at close; no-skill rounds note the reason. Task-vs-round semantics
pinned.

**V2.003** — Central logbook: one shared file (location chosen by the
installer), 5-aspect entries (what happened / why each skill fired / friction
/ missed-skill self-check / result), append-only, never inside the skill
package.

**V2.002** — Single-trigger full autopilot: cross-round self-bootstrap, 8 core
skills with entry conditions + deliverable contracts (rest via a
four-question template), delivery gate for non-coders (one-sentence summary +
hand-check list + pasted verify output), HTML dashboard dropped, light trace
files, friction-only logging, self-evolution gate (propose only, never
self-edit).

**V2.001** — Baseline: the slimmed driver (trigger table + resume rules,
history archived, rule details split into `references/`).
