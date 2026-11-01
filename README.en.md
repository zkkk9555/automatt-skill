English | [简体中文](./README.md)

# automatt

> **Rename note**: this skill was previously named `autopilot` and is now named `automatt` (easier to remember, and it no longer collides with other skills). The command, the `automatt: on` opt-in credential and the installer were renamed accordingly.
>
> **Nothing to migrate by hand**: since V2.054 the driver converts **only the opt-in point**, with no grace window — old names **pointing at this skill** inside your project's `AGENTS.md` (the credential line `autopilot: on`, the invocation line) and the driver's own pointer dir `.autopilot/` become the new name in that round, and every changed path is listed in the ledger entry. **Files outside `AGENTS.md` are never touched** (your README/docs/scripts/config are your text — we do not rewrite them), and they never justify creating a second logbook. The legacy credential line does **not** count as opted in: when the driver sees it, it converts it and then drives normally.

**One invocation, full auto-drive.** A driver skill wrapping the
[mattpocock/skills](https://github.com/mattpocock/skills) workflow (27
sub-skills): one plain-language request — in English or Chinese — turns into a
complete, verified, delivered task. Routing, sharpening, spec, tickets,
implementation, red-green testing, two-axis review, verified delivery, all
driven by the skill itself with no mid-task questions.

> **Who this is for**: people who want the workflow but don't know how to use
> it. You don't need to know the 27 sub-skills or when to invoke which — just
> invoke this one skill and it calls the workflow skills automatically when
> needed. Beginner-friendly by design.

## Why

Bare agents skip steps when they feel confident: they jump straight to code,
skip the spec, forget the regression test. This driver turns "quality by
discipline" into "quality by process":

- **T0 routing every round** — `ask-matt` decides the lane before any work.
- **Real-skill-first** — installed sub-skills are always loaded before work;
  the bundled fallbacks exist only for missing skills.
- **Self-scan checkpoints** — after every slice, after every red→green, on
  repeated failures, on design forks.
- **Never-exempt review & verify** — every change ships with pasted,
  real-exit-code verification evidence. Tokens are spent instead of asking
  the human.
- **Delivery for non-coders** — every task closes with a one-sentence change
  summary, a paste-and-run hand-check, and the raw verify output.

## Install

> **One-line install**: copy this prompt to your agent and it handles everything:
>
> ```
> Install this skill: https://github.com/zkkk9555/automatt-skill
> Requirements: driver (automatt) + 27 upstream workflow skills, 28 required
> items total, none missing; install into the current harness
> user-level skills
> directory; take new upstream skills as they come; verify these 28 exist one
> by one: automatt, ask-matt, code-review, codebase-design, diagnosing-bugs, domain-modeling, grill-me, grill-with-docs, grilling, handoff, implement, implement-spec, improve-codebase-architecture, pr, prototype, research, retro, setup-matt-pocock-skills, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-for-agents; report any missing and where they landed.
> ```
>
> Send the prompt above to your agent to install. Advanced options below —
> skip if the prompt worked.

<details>
<summary>Advanced: one-command + variants</summary>

The driver is the commander; the 27 upstream workflow skills
([mattpocock/skills](https://github.com/mattpocock/skills), MIT) do the work.
**Since V2.054 those 27 ship with this repository** (the `skills/` directory;
see `THIRD-PARTY-NOTICES.md`) — one repository gives you the driver plus the
upstream skills, all 28 items; there is no second repository to fetch.
Driver-only runs on built-in speed notes with weaker discipline.

bash (macOS / Linux / Git Bash):

```bash
curl -fsSL https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.sh | bash
```

Windows PowerShell (if execution policy blocks, run
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` first):

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/zkkk9555/automatt-skill/main/install.ps1)))
```

Default target is `~/.agents/skills/` (DeepSeek Harness reads that
directory); the script also writes to your detected harness dir when
unambiguous (claude / codex / cursor / opencode / zcode / dsh / workbuddy).
**Verify in your tool that the skill list shows automatt.** Variants:
`--harness dsh`, `--ref 2.0.56` (install a pinned version — the default is
already pinned to the current version tag, so "which version did I install"
has an answer), `--dry-run`, `--slim`, `--dir`, `--uninstall`.

</details>

<details>
<summary>Advanced: other methods (npx / marketplace / manual)</summary>

- `npx skills`: `npx skills@latest add zkkk9555/automatt-skill -g -a zcode -y`
  (`-a`: claude-code|codex|cursor). The 27 upstream skills live in this repo's
  `skills/` directory now — take them from there. It installs per-harness
  directories.
- Claude Code marketplace: `/plugin marketplace add zkkk9555/automatt-skill`,
  then `/plugin install automatt` (**driver only** — add the 27 upstream skills
  with the installer above).
- Manual (unknown harness): find your skills dir → clone this repo → copy
  `automatt/` over and every directory under `skills/` (one directory = one
  skill) → verify 28 → restart and say "The sidebar toggle stopped working —
  check and fix it."
- Directory map: `~/.agents/skills/` (ZCode/Cursor/OpenCode/DeepSeek Harness…)
  | `~/.dsh/skills/` (DeepSeek Harness) | `~/.zcode/skills/` (ZCode)
  | `~/.claude/skills/` (Claude Code) | `~/.codex/skills/` (Codex)
  | `<project>/.agents/skills/` (project only).
  Nothing is universal — always verify.

</details>
## Use

**Opt in per project first** (off by default): add the standalone line `automatt: on` to the project's `AGENTS.md` (delete it, or use `automatt: off`, to turn it off). Any time, saying "use automatt for X" or `/automatt` forces takeover — no credential needed.

Say it like a human, once:

- The sidebar toggle stopped working — check and fix it.
- Add a small button that does XX when clicked — make it solid and reliable.
- I want to build a small XX project.

The driver routes itself: symptoms/errors → feedback-loop-first bug flow;
small features → sharpen → spec → red-green → two-axis review; foggy projects
→ interview → map → staged stops. It only stops for destructive,
externally-visible, or scope-changing decisions.

## Status & contributing

> This skill is in **early development** — trigger timing may be off and
> sub-skill handoffs may be rough. You are welcome to:
>
> - File an [issue](https://github.com/zkkk9555/automatt-skill/issues) with your scenario and what the driver actually did.
> - Open a [pull request](https://github.com/zkkk9555/automatt-skill/pulls) against `main`.
>
> Every report helps — real-world feedback is exactly what carried it from
> V2.001 to where it is now.

## Versioning

Single scheme: `V2.00N` (see
[`automatt/CHANGELOG.md`](./automatt/CHANGELOG.md),
English version at
[`CHANGELOG.en.md`](./automatt/CHANGELOG.en.md)).

## License

MIT — see [LICENSE](./LICENSE).
