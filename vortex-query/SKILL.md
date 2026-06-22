---
name: vortex-query
description: >
  Answer questions by searching a Vortex context system. Reads context.md first,
  falls back to library/, facts/, track/, and insights/ when the user wants more
  detail. Read-only unless saving an insights report with confirmation. Use when
  the user asks what do I know about, what's in my inbox, or wants to explore
  their personal context.
allowed-tools: Bash Read Write Glob Grep
---

# Vortex — Query

Answer questions from your personal context — read-only search and synthesis.

**Learn vs fact vs query:** learn ingests outside material; fact logs what is true for you; **query** reads and answers without changing context (unless you agree to save an insights report).

## Pre-flight

Before any action:

1. Confirm `./context/` exists. If not → stop. Tell the user to run **vortex** first ("Set up my context").
2. Read `context/index.md` when tier 2 search is needed — use as a catalog to find relevant files.

## Detect Intent

| Signal | Action |
|--------|--------|
| "What do I know about…?", "Tell me about…", "Search my context for…" | Query (default tier) |
| "More detail", "dig deeper", "show me the sources", "where did that come from?" | Escalate to tier 2 |
| "What's in my inbox?", "What haven't I learned yet?" | Inbox-only query |
| "Fact: …", "Learn this…", "Refresh context.md" | Route to **vortex-fact**, **vortex-learn**, or **vortex-compile** |

## Search Tiers

Execute in order. **Stop** when the question is answered.

| Tier | When | Scope |
|------|------|--------|
| **1** | Normal questions; `context.md` exists and is non-empty | `context/context.md` only |
| **2** | User asks for more detail **or** `context.md` missing/empty | `library/`, `facts/`, `track/`, `insights/` |
| **Inbox** | User asks about unprocessed material | `inbox/` only (exclude `inbox/read/`) |
| **History** | User explicitly asks for processed originals or history | `inbox/read/` |

### Tier 1 — Compiled context

Read `context/context.md` and answer from it.

- Plain answer — **no citations**, no file paths
- If the answer is incomplete, say so and offer tier 2 ("Want me to dig into the underlying files?")

### Tier 2 — Folder fallback

When tier 2 applies:

1. Read `context/index.md` to locate relevant entries
2. Grep and read files in `library/`, `facts/`, `track/`, `insights/`
3. Synthesize across folders — do not stop at the first hit

**When `context.md` was missing or empty:** answer from tier 2, then suggest **vortex-compile** at the end.

**Citations in tier 2:** summarize without file paths unless the user asks where something came from — then cite paths like `context/facts/eta-deal-ceiling.md`.

**Skip by default:** `inbox/read/` body content unless the user asks for history.

### Inbox-only

"What's in my inbox?" → list unprocessed items in `context/inbox/` (not `inbox/read/`). Include counts and titles from stubs or `index.md` under `## Inbox`.

## Synthesize the Answer

Match format to the question:

| Question type | Format |
|---------------|--------|
| Factual | Direct answer |
| Comparison | Table or structured comparison |
| Exploration | Short narrative connecting related topics |
| List / catalog | Bulleted list with brief descriptions |

### Pending facts

Always label pending items **`(pending)`** in the answer — even when read from `context.md`.

### Conflicts (facts vs library)

When `facts/` and `library/` disagree on the same topic:

- **Present both sides** and note the conflict explicitly
- Do not silently pick one value

### Tier 1 vs tier 2 voice

- **Tier 1:** conversational, self-contained — as if speaking from memory
- **Tier 2:** same voice; add file paths only when the user asks for sources

## Insights Offer (optional save)

After a strong synthesis (especially comparisons or multi-source answers), you may **offer** to save a report to `context/insights/`.

**Do not write without confirmation.** Same preview pattern as **vortex-fact**.

### When to offer

- Multi-file synthesis the user might want to keep
- Comparison or decision framing across facts + library
- **Not** for simple one-line factual lookups

### Confirmation preview

Show:

1. **Summary** — one sentence: what will be saved
2. **Target** — `CREATE context/insights/YYYY-MM-DD-{slug}.md`
3. **Draft** — full proposed frontmatter and body

Example:

```markdown
**Summary:** Save a synthesis comparing ETA vs startup paths from your context.

**Target:** CREATE `context/insights/2026-06-22-eta-vs-startup.md`

**Draft:**
---
date: 2026-06-22
tags: [eta, career, synthesis]
related: [eta, entrepreneurship]
source_query: "What do I know about ETA vs startups?"
---
# ETA vs startup — synthesis

...
```

**On decline:** stop. Write nothing.

**On approve:**

1. Write `context/insights/YYYY-MM-DD-{slug}.md` (slug from topic; collision → append `-2`, `-3`, …)
2. Update `context/index.md` under `## Insights` — one line: `title — summary` (under 120 characters)
3. Report path and suggest **vortex-compile** if `context.md` is stale

## Do Not

- Write files during a normal query (insights save requires explicit offer + confirmation)
- Run without `context/` (use **vortex** to set up)
- Auto-escalate to tier 2 without user request (except when `context.md` is missing/empty)
- Search `inbox/read/` unless the user asks for history
- Route ingestion or fact-logging here — use **vortex-learn** or **vortex-fact**
- Overwrite `context.md` — use **vortex-compile**
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## What's Next

After querying:

- **Compile** — "Refresh context.md" → **vortex-compile** (especially if tier 2 was used because `context.md` was empty)
- **Fact** — "Fact: I'm targeting deals under ₹5Cr" → **vortex-fact**
- **Learn** — "Learn this article" → **vortex-learn**
