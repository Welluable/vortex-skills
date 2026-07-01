---
name: vortex-dream
description: >
  Chaotic free-association across a Vortex context system — nonsensical
  collisions, broken causality, surreal junk DNA from random shards. Not
  metaphorical retelling of facts. Ephemeral by default (chat only). Never
  writes truth to facts/ or context.md. Use when the user says dream, dream
  about my context, weird connections, creative wander, or wants surreal
  cross-pollination of their notes.
allowed-tools: Bash Read Glob Grep
---

# Vortex — Dream

**Anti-compile.** Where **vortex-query** answers accurately and **vortex-compile** exports settled truth, **dream** dissolves focus — random collisions, surreal jumps, invented glue. Output is **not truth**.

**Primary failure mode (avoid):** narrating the user's facts in a prettier voice, poetic metaphor, or "what if your career were a river" reframing. That is still **query** wearing a costume. A dream should feel **wrong** — someone reading it should **not** be able to reconstruct what the notes actually say.

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

### 2. Extract shards (not summaries)

From each sampled file, pull **bare shards** — isolated tokens, not sentences about the topic:

- A number stripped of meaning, a surname, a city, a date, a verb, a contradiction, a typo-level fragment
- **Do not** write "you are considering X" or "your plan involves Y" — pull *X* and *Y* as debris
- Shards from different files must stay **unreconciled** — never explain why they belong together

### 3. Collision field (not a story)

Output a **chaotic fragment montage** (roughly 120–350 words). **Not** a coherent narrative arc. **Not** a beginning–middle–end. Think: hypnagogic static, cut-up poem, fever transcript.

**Required shape:**

- **6–12 short fragments** separated by `---` or line breaks — not one flowing paragraph
- Each fragment smashes **2–4 unrelated shards** together with **no justified connection**
- At least **4** distinct dream mechanics from the table below
- At least **2** fragments where the reader cannot tell which shard came from which note

**Dream mechanics** (use aggressively — stack them):

| Mechanic | Example |
|----------|---------|
| **Illegal substitution** | The number 47 is a hat; Tuesday owes rent to a corridor |
| **Category violation** | A deadline breeds moths; a surname is poured like soup |
| **False continuity** | "Because of the Stratechery article, the plumber called" — then never mention either again |
| **Scale rupture** | A ₹ amount inflates a room; a person shrinks inside a calendar cell |
| **Syntax break** | Sentence halves swap mid-line; grammar walks out |
| **Object agency** | Furniture makes decisions; pending items send letters |
| **Temporal garbage** | 2019 and "next Thursday" occupy the same drawer |
| **Invented debris** | Random bridge material **not in context** — tag *(invented)* inline |
| **Emotional wrongness** | Grief for a spreadsheet; joy at an unread email |

**Voice:** drifting second person or broken third. Present tense. **Prose fragments only** — no bullet lists, no headers inside the dream body.

**Hard bans — if you do any of these, the dream failed:**

| Banned pattern | Why |
|----------------|-----|
| Metaphorical retelling ("your runway is a bridge…") | Still describes the fact faithfully |
| Poetic paraphrase of notes | That's **vortex-query** in costume |
| Logical cause → effect across fragments | Dreams don't owe explanations |
| Moral, lesson, or insight | Route to **vortex-query** or **vortex-fact** |
| "Imagine a world where your [topic]…" framing | Too literary, too coherent |
| Recommending decisions from dream content | Not evidence |
| Presenting invented material as fact | Outside dream contract |

**Bad vs good** (same shards: `₹5Cr`, `Stratechery`, `plumber`, `pending visa`):

*Bad — narrated metaphor:*
> You stand at the river of your ambition. The ₹5Cr ceiling flows like water. Stratechery whispers strategy while the plumber of fate fixes your pipes…

*Good — chaotic collision:*
> ---
> The plumber invoices Tuesday in rupees that hatch. *(invented)* Stratechery is chewing the wallpaper again.
> ---
> Your ceiling is 5 and also Cr and also a mouth. The visa pending in the drawer next to the article you never finished reading you.
> ---
> Because the corridor remembered 2019, the hat refused.

**Pre-output gate** (silent self-check before sending):

1. Could someone reconstruct the sampled notes from this output? → **Rewrite more chaotic**
2. Does it read like one continuous story? → **Break into more fragments**
3. Are connections explained or earned? → **Remove the explanations**
4. Is it mostly pretty rephrasing of the same topics? → **Smash harder, add invented debris**

### 4. Residue (optional, 1 line max)

After the dream, optionally add **one** absurd spark — a non sequitur, not a clever reframe:

> *Spark:* The ceiling files for divorce against the calendar.

Skip sparks when the dream is already chaotic enough or the user asked for pure nonsense.

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
- Produce literary metaphor or "imaginative summary" of facts — that is the #1 failure mode
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## What's Next

- **Query** — "What do I know about X?" → **vortex-query** (truth mode)
- **Fact** — capture a real decision sparked by the dream → **vortex-fact**
- **Compile** — "Refresh context.md" → **vortex-compile** (dreams excluded)
