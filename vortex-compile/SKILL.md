---
name: vortex-compile
description: >
  Overwrite context/context.md with a self-contained compiled snapshot from facts/,
  library/, track/, and insights/. No wikilinks or file paths. Runs immediately
  without confirmation. Use when the user says refresh context.md, compile my
  context, update context.md, or wants one file for external AI.
allowed-tools: Bash Read Write Glob Grep
---

# Vortex — Compile

Produce **`context/context.md`**: a self-contained snapshot of your personal context for any AI or reader without vault access. **Always overwrite** the previous file. Read-only synthesis except the compile output.

**Query vs compile:** query answers ad-hoc questions; **compile** exports everything reconciled into one file.

## Pre-flight

Before any action:

1. Confirm `./context/` exists. If not → stop. Tell the user to run **vortex** first ("Set up my context").
2. Scan `context/facts/`, `context/library/`, `context/insights/`, and `context/index.md` to plan the compile.

## Detect Intent

| Signal | Action |
|--------|--------|
| "Refresh context.md", "Compile my context", "Update context.md" | Compile |
| "What do I know about…?" | Route to **vortex-query** |
| "Fact: …", "Learn this…" | Route to **vortex-fact** or **vortex-learn** |

## Output Contract

| Rule | Requirement |
|------|-------------|
| **Path** | `context/context.md` |
| **Mode** | **Overwrite** entire file every run — no confirmation preview |
| **Side effects** | **`context.md` only** — do not edit `index.md`, facts, library, track, insights, or inbox |
| **Audience** | Any reader **without** vault access |
| **Self-contained** | All locked numbers, dates, and decisions **inline** — no wikilinks, no file paths, no "see page X" |
| **Frontmatter** | Minimal: `updated: YYYY-MM-DD` only |

## Body Structure

**Flat and flexible** — minimal topic headings grouped by domain. **No mandatory section order.** Omit empty groups.

Use domain-obvious labels from the user's content (e.g. career, finance, ETA) — not a fixed global template.

## Scope

### Include

| Source | What to include |
|--------|-----------------|
| **facts/** | Decided and done facts with dates; pending facts labeled **`(pending)`** |
| **library/** | **Summarized highlights** — one-line or short bullet per entry; not full article text |
| **track/** | **Mention only** when referenced by included facts or library material — brief definitional bullets |
| **insights/** | Full reports inline |
| **Conflicts** | When facts and library disagree on the same topic, present **both values inline** at that topic |

### Exclude

- `inbox/` and `inbox/read/` — entirely out of scope (use **vortex-query** for inbox questions)
- Wikilinks, file paths, provenance tables, "distilled from" pointers
- Duplicate prose when the same fact appears in multiple source files — state once

## Collection Workflow

Execute in order.

### 1 — Read facts

Read all files in `context/facts/`. Group by topic. Preserve status:

- `decided` / `done` — present tense or past tense with date as appropriate
- `pending` — prefix or tag with **`(pending)`**

### 2 — Read library

Read all files in `context/library/`. Extract **key takeaways** per entry — one-line or short bullet. Do not copy full article bodies.

### 3 — Read insights

Read all files in `context/insights/`. Include full report bodies inline under relevant topic groups.

### 4 — Read track (referenced only)

Identify track slugs referenced by facts and library content being compiled. Read only those `context/track/` pages. Add brief definitional context where a reader needs a name or concept explained.

Do **not** include every track page — only those referenced in steps 1–3.

### 5 — Reconcile conflicts

When a fact and a library entry disagree on the same claim:

- Present **both values inline** at the topic (e.g. "Fact: ₹8Cr ceiling · Library (Stratechery summary): typical ETA deals ₹3–5Cr")
- Do **not** use a separate `## Unreconciled` section
- Do **not** silently pick one value

### 6 — Synthesize and write

Draft flat topic groups. Merge related bullets under minimal headings. Then **overwrite** `context/context.md` completely.

## Voice

- Dense bullets and short paragraphs
- Present tense for current settled state; past tense for completed events with date
- Prefix pending items with **`(pending)`**
- Amounts and numbers: include currency/units and dates where the source provides them

## `context.md` Template

Minimal frontmatter. Flat body. Omit empty groups.

```markdown
---
updated: YYYY-MM-DD
---

# Context

<optional topic label>

- Settled fact or highlight...
- Another bullet...

<topic label>

- Library highlight from processed source...
- (pending) Open decision...

<when facts and library conflict on same topic>

- ETA deal size — Fact: ₹8Cr ceiling (2026-06-22) · Library: typical ETA deals ₹3–5Cr (Stratechery, 2026-06)

<insights report inlined under relevant topic when applicable>
```

## End-of-run Report

After a successful compile, tell the user:

- Path: `context/context.md`
- Approximate line count
- Count of pending facts included
- Count of inline conflicts noted (if any)
- Suggested next step: attach or paste `context.md` for external AI, or **vortex-query** to explore

## Do Not

- Ask for confirmation before overwriting — compile immediately
- Edit `facts/`, `library/`, `track/`, `insights/`, `inbox/`, or `index.md` during compile
- Include inbox material in `context.md`
- Add wikilinks or vault file paths to the body
- Run without `context/` (use **vortex** to set up)
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## What's Next

After compiling:

- **Query** — "What do I know about ETA?" → **vortex-query** (tier 1 reads `context.md`)
- **Fact** — "Fact: I'm targeting deals under ₹5Cr" → **vortex-fact** (then recompile)
- **Learn** — "Learn this article" → **vortex-learn** (then recompile)
