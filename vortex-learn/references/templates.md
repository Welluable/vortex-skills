# vortex-learn Templates

Canonical file shapes for enqueue and process modes.

## Inbox stub (enqueue)

```markdown
---
added: YYYY-MM-DD
type: url | note | file
source: https://example.com/article or path/to/original
title: Human-readable title
---

Optional short note from user.

URL, pasted body, or placeholder before fetch.
```

**Save and fetch:** append fetched content under:

```markdown
## Fetched content

[readable article text]
```

## Library entry (process)

Filename: `slug-from-title.md` in `context/library/`

```markdown
---
title: Human-readable title
source: inbox/original-stub.md or https://... or "pasted"
type: article | video | pdf | notes | other
tags: [inferred, tags]
created: YYYY-MM-DD
processed: YYYY-MM-DD
track:
  - "[[referent-one]]"
  - "[[referent-two]]"
summary: One-line summary for index.md (under 120 characters)
---

# Title

## Summary

Structured overview of the source.

## Key claims

- Claim 1
- Claim 2

## Quotes / snippets

> Notable quote or paraphrased snippet — attribution if available

## Open questions

- Question the source raises but does not answer

## Related track entries

- [[Referent]] — why this source matters for that topic
```

## Track page (new)

Filename: `slug-from-title.md` in `context/track/`

```markdown
---
kind: person | org | place | concept | project | tool
tags: [inferred, tags]
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources:
  - "[[library-entry-slug]]"
summary: One-line summary for index.md
---

# Display Name

Core definition or who/what this is — synthesized from sources so far.

## From sources

- From [[library-entry-slug]]: bullet capturing what this source adds
```

## Track page (update)

When a track page already exists:

1. Update `updated:` and append the new `[[library-entry]]` to `sources:` (dedupe)
2. Append bullets under `## From sources` — prefix with `From [[library-entry]]:`
3. Refresh `summary:` if the one-liner is stale
4. If sources disagree, add under `## Contradictions` (create section if missing):

```markdown
## Contradictions

- **Topic:** [[older-library]] says X; [[newer-library]] says Y.
```

Do not remove prior content unless it is a direct duplicate.

## Archived inbox (`inbox/read/`)

After processing, the moved stub keeps its content and gains:

```yaml
processed: YYYY-MM-DD
library: "[[library-entry-slug]]"
```

Original `added`, `type`, `source`, `title` are preserved.
