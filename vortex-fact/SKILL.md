---
name: vortex-fact
description: >
  Log owner-originated truths to a Vortex context system. Writes to facts/,
  updates index.md, and creates or updates track/ entries for named referents.
  Confirms before writing. Use when the user says Fact, I decided, log that,
  remember that for me, or records a decision, number, event, or pending item.
allowed-tools: Bash Read Write Glob Grep
---

# Vortex — Fact

Record what is true for **you** — decisions, numbers, events, reminders — into `context/facts/`.

**Learn vs fact:** learn = outside world → you (`library/` + `track/`). fact = what *you* assert or decide.

## Pre-flight

Before any action:

1. Confirm `./context/` exists. If not → stop. Tell the user to run **vortex** first ("Set up my context").
2. Read existing files in `context/facts/` to support duplicate and conflict detection.

## Detect Intent

| Signal | Action |
|--------|--------|
| `"Fact: …"`, `"Fact (pending): …"` | Log fact |
| `"I decided…"`, `"I'm targeting…"`, `"I closed…"` | Log fact |
| `"Log that…"`, `"Remember that for me…"` | Log fact |
| `"Update the fact about…"`, settling a prior pending item | Update existing fact in place |
| Contradicts or supersedes an earlier decided fact | Conflict flow (see below) |

Do **not** treat outside-world ingestion as a fact — route to **vortex-learn**.

## Workflow

**Always confirm before writing.** Never create or update files until the user approves the preview.

### 1. Parse

From the user's message, extract:

- **Title** — short human label for index and `#` heading
- **Body** — the fact in the user's words (clean up lightly; do not invent claims)
- **status** — infer from wording:
  - `pending` — plans, open decisions, reminders ("need to decide", "by Friday", "considering")
  - `decided` — settled assertions ("I decided", "I'm targeting", "we chose")
  - `done` — a pending item explicitly completed ("decided on X loan", "closed that loop")
- **type** — free-form short label inferred from content (e.g. `decision`, `number`, `event`, `reminder`)
- **confidence** — `high` | `medium` | `low`; default `high` when stated plainly; lower when hedged ("I think", "probably", "maybe")
- **date** — event date if mentioned, else today (`YYYY-MM-DD`)
- **due_date** — only when the user mentions a deadline (`pending` facts); parse relative dates from context
- **tags** — infer from fact content only (do not copy domain tags from `index.md`)
- **related** — slugs of track entries this fact touches (people, orgs, concepts, projects, etc.)

Explicit `(pending)` in the message is a strong signal for `status: pending`.

### 2. Match existing facts

Search `context/facts/` for the same topic:

- **Same topic, pending → completing** — user is settling an open item → **update that file in place** (no new file)
- **Same topic, decided → refinement** — user is clarifying or correcting → **update in place**
- **Contradicts an existing decided fact** — different claim on the same topic → **conflict flow** (step 3)
- **No match** — propose a **new** `context/facts/{slug}.md`

**Slug:** kebab-case from title/topic (e.g. `eta-deal-ceiling.md`). On "keep both" after a conflict, append `-2`, `-3`, …

### 3. Conflict flow

When a new fact contradicts an existing **decided** fact, flag it in the confirmation preview. Offer three choices:

1. **Update old** — replace/update the existing fact file
2. **Keep both** — write a new file with suffixed slug (`-2`, `-3`, …)
3. **Cancel** — write nothing

Wait for the user's choice before proceeding.

### 4. Confirmation preview

Show **all** of the following and ask for approval:

1. **Summary** — one sentence: what will be logged and as which status
2. **Target** — `CREATE context/facts/{slug}.md` or `UPDATE context/facts/{slug}.md` (and conflict options if applicable)
3. **Draft** — full proposed frontmatter and body

Example:

```markdown
**Summary:** Log a decided fact about your ETA deal ceiling.

**Target:** UPDATE `context/facts/eta-deal-ceiling.md`

**Draft:**
---
status: decided
date: 2026-06-22
tags: [eta, deals, finance]
related: [eta]
type: number
confidence: high
---
# ETA deal ceiling

Raised target ceiling to ₹8Cr (was ₹5Cr).
```

**On decline:** stop. Write nothing. Offer to revise if the user wants changes.

**On approve:** continue to steps 5–7. Track side effects are **not** previewed separately.

### 5. Write fact file

**Filename:** `context/facts/{slug}.md`

**Frontmatter (required fields):**

```yaml
---
status: pending | decided | done
date: YYYY-MM-DD
tags: [inferred, from, content]
related: [track-slugs]
type: <free-form>
confidence: high | medium | low
due_date: YYYY-MM-DD   # pending only; omit unless user mentioned a deadline
---
```

**Body:** agent's choice — short paragraph for simple facts; `# Title` plus `## Details` bullets when there is more structure.

When **updating** an existing fact, preserve useful history in the body if appropriate (e.g. note what changed and when).

### 6. Update index.md

Under `## Facts` in `context/index.md`, add or update one line:

```markdown
- ETA deal ceiling — Raised target ceiling to ₹8Cr
```

Format: **`title — summary`** (human title, not filename slug). Under 120 characters. Create the header if missing. Keep entries sorted alphabetically.

### 7. Track side effects (after approval)

For each named referent in the fact (person, org, place, concept, project, tool):

- **Exists in `context/track/`** → merge: update body if needed; append fact under `## From facts`; add fact slug to `sources:` in frontmatter; update `updated:`
- **New** → create `context/track/{slug}.md`:

```yaml
---
kind: person | org | place | concept | project | tool
updated: YYYY-MM-DD
sources: [fact-slug]
---
# Name

Short definition or context from this fact.

## From facts

- [[fact-slug]] — one-line summary of what this fact adds
```

Also update `context/index.md` under `## Track` (`[[slug]] — summary`).

Infer `kind` — not user-facing unless asked. Prefer updating an existing track page over creating duplicates for the same referent.

### End-of-run report

After a successful write, summarize:

- Fact file created or updated (path)
- Status and type
- Track pages created vs updated
- Suggested next step: **vortex-compile** to refresh `context.md`, or **vortex-query** to explore

## Conventions

- **Links:** `[[wikilinks]]` inside the vault — never raw paths in prose
- **Naming:** slug from topic; collision on "keep both" → `-2`, `-3`, …
- **Pending → done:** find the pending fact and update `status` + body in the same file
- **Facts win** for owner decisions vs library commentary (relevant to **vortex-compile**)

## Do Not

- Write without user confirmation
- Run without `context/` (use **vortex** to set up)
- Write to `library/`, `inbox/`, `insights/`, or `context.md` — other skills handle those
- Process outside-world sources — use **vortex-learn**
- Delete fact files unless the user explicitly asks
- Overwrite unrelated context files
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## What's Next

After logging facts:

- **Query** — "What do I know about ETA?" → **vortex-query**
- **Compile** — "Refresh context.md" → **vortex-compile**
- **Learn** — "Learn this article" → **vortex-learn**
