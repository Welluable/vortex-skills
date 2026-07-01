# Context Schema

Canonical rules for Vortex personal context systems. Agent config templates pull from this document.

## Layout

```
context/
  inbox/              ← not processed yet
    read/             ← processed originals (moved here, never deleted)
  library/            ← learned summaries
  facts/              ← owner truths: decided, done, pending
  track/              ← named referents: people, orgs, places, concepts, projects, tools
  insights/           ← cross-cutting reports and synthesis
  context.md          ← compiled snapshot (overwrite on compile)
  index.md            ← agent-maintained catalog
```

Workspace root may also contain `.obsidian/` (Obsidian vault) and agent config files.

## Folder Roles

| Folder | Holds | Written by |
|--------|-------|------------|
| inbox/ | URLs, clips, PDFs, rough notes | User drop; vortex-learn (enqueue) |
| inbox/read/ | Originals after processing | vortex-learn (never delete) |
| library/ | Clean summaries of processed material | vortex-learn |
| facts/ | Owner assertions, decisions, numbers, events; `(pending)` ok | vortex-fact |
| track/ | Anything look-uppable by name | vortex-learn, vortex-fact |
| insights/ | Dated analysis, comparisons, reports | User or agent on request |
| context.md | Self-contained export, no wikilinks | vortex-compile |

## Learn vs Fact

| | vortex-learn | vortex-fact |
|--|--------------|-------------|
| Source | Outside (article, doc, video) | You |
| Question | What does this say? | What is true for me? |
| Output | library/ + track/ | facts/ |

## Track vs Insights

- **track/** — stable reference ("What is ETA?", "Who is X?")
- **insights/** — dated synthesis ("ETA vs startup for my situation, June 2026")

Optional track frontmatter (agent-inferred):

```yaml
kind: person | org | place | concept | project | tool
```

## Skills

Always use the installed Vortex skills — never improvise structure:

| Skill | When |
|-------|------|
| vortex | Setup only |
| vortex-learn | Enqueue or process inbox → library + track |
| vortex-fact | Log owner truth to facts/ |
| vortex-query | Read-only search across context |
| vortex-compile | Overwrite context.md from reconciled folders |
| vortex-dream | Free associative dreaming (ephemeral; excludes from compile) |

Install globally: `npx skills add welluable/vortex-skills -g --all -y`

## Reconciliation (skill logic, not user-facing)

- Pending facts → do not treat as settled in context.md
- Facts win for owner decisions vs library commentary
- Completed facts → reconcile into track/ and future compiles

## context.md Compile Contract

- Self-contained — no wikilinks, readable without vault access
- Overwrite entire file each compile
- Pending facts labeled `(pending)`
- Inbox: count + titles only
- Unreconciled section when fact and library disagree (facts win for owner decisions)

Suggested sections: Current facts · Pending facts · Tracked topics · Library highlights · Insights · Inbox status · Unreconciled (if any)

## index.md

Agent-maintained. One-line entries under category headers:

```
- article-title — one-line summary
```

Users need not edit index.md manually.
