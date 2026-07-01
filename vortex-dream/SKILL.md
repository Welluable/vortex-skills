---
name: vortex-dream
description: >
  Free associative dreaming across a Vortex context system — weird collisions,
  surreal connections, invented bridging material. Ephemeral by default (chat
  only). Never writes truth to facts/ or context.md. Use when the user says
  dream, dream about my context, weird connections, creative wander, or wants
  surreal cross-pollination of their notes.
allowed-tools: Bash Read Glob Grep
---

# Vortex — Dream

**Anti-compile.** Where **vortex-query** answers accurately and **vortex-compile** exports settled truth, **dream** dissolves focus — random collisions, surreal jumps, invented glue. Output is **not truth**.

Default: **ephemeral** (chat only). Save only when the user explicitly asks.

## Pre-flight

1. Confirm `./context/` exists. If not → stop. Tell the user to run **vortex** first.
2. Read `context/index.md` as a catalog — do not read every file yet.

## Detect Intent

| Signal | Action |
|--------|--------|
| "dream", "dream about my context", "weird connections", "creative wander" | Free dream |
| "save this dream", "keep that dream" | Save last dream output (see Save) |
| "What do I know about…?" | Route to **vortex-query** |
| "Fact: …", "Learn this…", "Refresh context.md" | Route to other skills |

## Free Dream — Workflow

### 1. Sample (dissolve focus)

Pick **4–8 entries** from `library/`, `facts/`, and `track/`:

- **Maximize distance** — prefer pairs with no shared `[[wikilinks]]`, different tags, different topics
- **Avoid clusters** — if three picks are all ETA/career, swap some for unrelated track pages
- Use `index.md` to find candidates; read only the sampled files
- Include at least one **pending** fact when present — dreams love unfinished business
- Skip `inbox/` and `inbox/read/` unless the user names a specific inbox item

### 2. Extract fragments (not summaries)

From each sampled file, pull **raw shards** — not accurate paraphrase:

- A number, a name, a place, a date, a half-sentence, a contradiction
- Ignore narrative coherence across shards

### 3. Dream weave

Compose a **short surreal narrative** (roughly 150–400 words). Apply several of these dream mechanics:

| Mechanic | Example |
|----------|---------|
| **Substitution** | A person becomes a building; a loan becomes a tide |
| **Compression** | Ten years in one sentence; two cities in one room |
| **False continuity** | "Because of the Stratechery article, the plumber called" |
| **Emotional residue** | Dread or joy with no logical source |
| **Invented scenes** | Bridge material **not in context** — label with *(invented)* |
| **Temporal slip** | Past and pending futures coexist |

**Voice:** second person or drifting third person. Present tense. No bullet lists in the dream body — prose only.

**Do not:**

- Summarize context faithfully (that is **vortex-query**)
- Present invented material as fact
- Recommend decisions as if the dream were evidence

### 4. Residue (optional, 1–2 lines)

After the dream, optionally add **Sparks** — not conclusions, just prompts:

> *Sparks:* What if the ₹5Cr ceiling were a door instead of a limit?

Skip sparks when the dream is already long or the user asked for pure nonsense.

### 5. Label (required)

End every dream with:

> **This was a dream — not truth.** Nothing above updates your context unless you ask to save it.

## Save (explicit only)

Only when the user says "save this dream", "keep that", or similar **after** a dream run.

**Do not** offer to save proactively.

On save:

1. Preview target: `CREATE context/insights/YYYY-MM-DD-dream-{slug}.md`
2. Frontmatter must include:
   ```yaml
   date: YYYY-MM-DD
   kind: dream
   speculative: true
   related: [wikilink-slugs-used]
   ```
3. Body: the dream prose + sparks + the truth disclaimer
4. On approve → write file; update `context/index.md` under `## Insights` with prefix `dream —`
5. Remind: **vortex-compile excludes dreams** from `context.md`

**Never** write to `facts/`, `library/`, `track/`, or `context.md` during a dream run.

## Do Not

- Auto-save dream output
- Write to `facts/`, `library/`, `track/`, or `context.md`
- Present dream content as settled knowledge in later turns without the disclaimer
- Run accurate synthesis — route to **vortex-query**
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## What's Next

- **Query** — "What do I know about X?" → **vortex-query** (truth mode)
- **Fact** — capture a real decision sparked by the dream → **vortex-fact**
- **Compile** — "Refresh context.md" → **vortex-compile** (dreams excluded)
