---
name: vortex-learn
description: >
  Enqueue or process outside-world material into a Vortex context system.
  Saves to inbox/, or processes inbox items into library/ and track/ with
  originals archived to inbox/read/. Use when the user says learn this,
  process my inbox, add to inbox, save for later, save and fetch, or wants
  to ingest articles, URLs, files, or pasted text.
allowed-tools: Bash Read Write Glob Grep
---

# Vortex — Learn

Turn outside-world material into your context: **inbox → library + track**.

Two modes, one skill:

| Mode | User says | Action |
|------|-----------|--------|
| **Enqueue** | "Save for later" · "Add to inbox" | Write stub to `context/inbox/` |
| **Enqueue + fetch** | "Save and fetch" | Stub + fetch URL content into file |
| **Process** | "Learn this" · "Process my inbox" | `library/` + `track/` → archive to `inbox/read/` |

**Learn vs fact:** learn = outside world → you (`library/` + `track/`). Use **vortex-fact** for what is true for *you*.

## Pre-flight

Before any action:

1. Confirm `./context/` exists. If not → stop. Tell the user to run **vortex** first ("Set up my context").
2. Read `context/index.md` for domain `tags:` — use when inferring tags on new entries.

## Detect Intent

| Signal | Mode |
|--------|------|
| "save for later", "add to inbox", "enqueue" (no "fetch") | Enqueue |
| "save and fetch" | Enqueue + fetch |
| "learn this", "process", "ingest" + URL/file/paste/inbox item | Process (single) |
| "process my inbox", "process inbox" | Process (batch, cap 3) |

**Tag override:** if the user says "tag this #career" (or similar), apply those tags in addition to inferred tags.

**Fetch override:** default enqueue is stub-only; only fetch when user says "save and fetch" or when processing requires readable content.

## Enqueue

Write one `.md` file to `context/inbox/`. See [templates.md](references/templates.md) for stub format.

**Sources:**

- **File** already in `inbox/` — nothing to enqueue; offer to process instead
- **URL** — stub with URL in frontmatter `source:` and body
- **Pasted text** — stub with `type: note`, body = pasted content
- **Chat reference** to workspace file — copy or point `source:` at path; if outside `inbox/`, still create stub in `inbox/`

**Naming:** slug from title (or domain for URLs); on collision append `-2`, `-3`, …

**Save and fetch:** for URLs, fetch readable content and append below the stub header (or into a clearly marked `## Fetched content` section). If fetch fails → report and offer: paste content now, save stub without content, or retry.

**After enqueue:** update `context/index.md` under `## Inbox` (one line per stub). Report filename and path.

## Process

Read the source completely (file, fetched URL content, or pasted body). **Process immediately** — write outputs, then report. Do not ask for takeaways first.

### Single item

User points at one URL, file, paste, or inbox item → process that item.

**Pasted text in chat:** full lifecycle — create inbox stub → process → move to `inbox/read/`.

**URL or paste not yet in inbox:** create stub in `inbox/` first, then process in the same run.

### Batch inbox

"Process my inbox" → process up to **3** unprocessed files in `context/inbox/` (exclude `inbox/read/`). Oldest first (by `added:` frontmatter, else file mtime). After each item, report; end with count remaining in inbox.

### Per-item workflow

1. **Read** — entire source; for images in files, read separately if they carry important information
2. **Write library entry** — one file per source in `context/library/`; rich template in [templates.md](references/templates.md)
3. **Write or update track pages** — for each named referent (person, org, place, concept, project, tool):
   - **Exists** → merge and append under `## From sources`; link new `[[library-entry]]`; update `updated:` and `sources:` in frontmatter
   - **New** → create in `context/track/` with full frontmatter and initial body
   - **Contradiction** → add entry under `## Contradictions` at bottom of track page (both library sources linked)
4. **Archive** — move original from `inbox/` to `inbox/read/`; add to frontmatter:
   ```yaml
   processed: YYYY-MM-DD
   library: "[[library-entry-slug]]"
   ```
5. **Update index** — `context/index.md` under `## Library`, `## Track`, `## Inbox` (remove processed inbox line; add/update library and track lines)

### Fetch failure during process

Do not silently write thin library entries. Report the failure and offer:

- **Paste content now** — user pastes in chat; update stub and continue processing
- **Skip** — leave item in `inbox/`; move on (batch) or stop (single)
- **Retry** — attempt fetch once more

### End-of-run report

Always summarize:

- Library entries created (with `[[wikilinks]]`)
- Track pages created vs updated
- Items archived to `inbox/read/`
- Contradictions flagged (if any)
- Inbox remaining (batch) or next suggested action

## Conventions

- **Links:** `[[wikilinks]]` everywhere inside the vault — never raw paths in prose
- **Naming:** slug from title; collision → `-2`, `-3`, …
- **Tags:** infer from content + domain tags in `context/index.md`; user overrides in chat win
- **Track kind:** infer `person | org | place | concept | project | tool` — not user-facing unless asked
- **Prefer updating** existing track pages over creating duplicates (same referent → one page)
- A single source often touches many track pages — this is expected

## index.md format

Under each header, one line per entry (under 120 characters):

```markdown
## Library
- [[article-slug]] — one-line summary

## Track
- [[eta-deals]] — one-line summary

## Inbox
- [[pending-stub]] — one-line description
```

Create a header if missing. Keep entries sorted alphabetically within each section.

## Do Not

- Run without `context/` (use **vortex** to set up)
- Write to `facts/`, `insights/`, or `context.md` — other skills handle those
- Delete inbox originals — only move to `inbox/read/`
- Overwrite or "repair" unrelated context files
- Improvise folder layout — follow `context-schema.md` in the **vortex** skill references

## Templates

File formats and section structure: [references/templates.md](references/templates.md)

## What's Next

After learning:

- **Query** — "What do I know about ETA?" → **vortex-query**
- **Fact** — "Fact: I'm targeting deals under ₹5Cr" → **vortex-fact**
- **Compile** — "Refresh context.md" → **vortex-compile**
