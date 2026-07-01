# Vortex Skills

Personal context system for AI agents — collect, learn, log facts, track names, query, and compile one file for any AI.

## Install (global)

```bash
npx skills add welluable/vortex-skills -g --all -y
```

Installs all six skills to your detected agents (`~/.cursor/skills/`, `~/.claude/skills/`, etc.).

### Install to specific agents

```bash
npx skills add welluable/vortex-skills -g -a cursor -a claude-code --skill '*' -y
```

## Setup a workspace

Open any folder in your editor, then say:

> **Set up my context**

Or invoke `/vortex`.

## Skills

| Skill | Say |
|-------|-----|
| **vortex** | Set up my context |
| **vortex-learn** | Learn this / Process my inbox |
| **vortex-fact** | Fact: … |
| **vortex-query** | What do I know about…? |
| **vortex-compile** | Refresh context.md |
| **vortex-dream** | Dream / weird connections |

## Update

```bash
npx skills update vortex vortex-learn vortex-fact vortex-query vortex-compile vortex-dream -g -y
```

## Layout

```
context/
  inbox/read/    ← save for later / archive after learning
  library/       ← what you extracted from sources
  facts/         ← what you decided (incl. pending)
  track/         ← people, orgs, concepts, projects
  insights/      ← dated synthesis reports
  context.md     ← one-file export for any AI
  index.md       ← agent-maintained catalog
```

> **Inbox** for what I haven't learned yet. **Library** for what I extracted. **Facts** for what *I* decided. **Track** for names and ideas. **Insights** for reports. **context.md** when I need one file for any AI.
