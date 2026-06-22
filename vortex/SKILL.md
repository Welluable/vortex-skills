---
name: vortex
description: >
  Set up a personal context system in the current workspace. Scaffolds
  context/, creates an Obsidian vault, installs all Vortex skills globally
  via the skills CLI, and generates agent configs. Use when the user says
  set up my context, onboard vortex, initialize context, or start vortex.
allowed-tools: Bash Read Write Glob Grep
---

# Vortex — Context Setup

Set up a **context refiner** in the current workspace: a `context/` folder where you collect material, learn from it, log your own facts, track names and ideas, and compile one self-contained file for any AI.

Five plain verbs after setup: **learn · fact · query · compile**.

## Pre-flight

Before the wizard, check whether `./context/` exists.

- If it exists → **stop**. Tell the user Vortex is already set up here and you will not overwrite it.
- Git is not required. The workspace can be any folder the user has open.

## Wizard Flow

Guide the user through **2 steps**. Ask **ONE question at a time**. Accept sensible defaults.

### Step 1: Domain / Topic

Ask:

> "What is this context about? This helps me describe your system and suggest tags."
>
> Examples: "career and business strategy", "home renovation", "AI research"

Use the answer to:

- Write a one-line domain description
- Generate 5–8 suggested domain-specific tags for `context/index.md` frontmatter

### Step 2: Agents

Auto-detect which agent is running this skill. State it clearly:

> "I'm running in **[Agent Name]**, so I'll install skills and generate config for **[agent-id]**."

Then ask:

> "Do you use any other AI agents? Options: Claude Code, Codex, Cursor, Gemini CLI — or skip."

Include the auto-detected agent plus any the user selects.

**Agent detection:**

- Claude Code conventions or Claude Skill tool → `claude-code`
- Codex environment → `codex`
- Cursor workspace / `.cursor/` → `cursor`
- `GEMINI.md` convention → `gemini-cli`
- If unsure, ask

**Skills CLI agent flags:** `cursor`, `claude-code`, `codex`, `gemini-cli`

## Post-Wizard: Execute in Order

### 1. Scaffold context/

Run from the workspace root:

```bash
bash <skill-directory>/scripts/onboarding.sh . "{{DOMAIN_DESCRIPTION}}" "{{DOMAIN_TAGS_CSV}}"
```

- `{{DOMAIN_TAGS_CSV}}` — comma-separated tags from Step 1 (no spaces), e.g. `career,business,strategy`
- Script aborts if `context/` already exists

Creates `context/` tree, stubs, and `.obsidian/` at workspace root.

### 2. Install Vortex skills globally

For each selected agent, run **one** command with all agent flags:

```bash
npx skills add welluable/vortex-skills -g -a <agent-1> -a <agent-2> --skill '*' -y
```

Example:

```bash
npx skills add welluable/vortex-skills -g -a cursor -a claude-code --skill '*' -y
```

If the command fails (no network, skills CLI missing), report the error and give the user the exact command to run manually. Do not skip silently.

If skills are already installed, `npx skills add` should update or skip duplicates — report what happened.

### 3. Generate agent config file(s)

For each selected agent, read the template from `<skill-directory>/references/agent-configs/`:


| Agent       | Template         | Output       | Location         |
| ----------- | ---------------- | ------------ | ---------------- |
| Claude Code | `claude-code.md` | `CLAUDE.md`  | workspace root   |
| Codex       | `codex.md`       | `AGENTS.md`  | workspace root   |
| Cursor      | `cursor.md`      | `vortex.mdc` | `.cursor/rules/` |
| Gemini CLI  | `gemini.md`      | `GEMINI.md`  | workspace root   |


Replace placeholders:

- `{{DOMAIN_DESCRIPTION}}` — one-line description from Step 1
- `{{DOMAIN_TAGS}}` — bullet list of 5–8 tags
- `{{CONTEXT_SCHEMA}}` — contents of `references/context-schema.md` from `## Layout` onward

Create output directories if missing (e.g. `.cursor/rules/`).

### 4. Print summary and teach the verbs

Show:

1. **What was created** — directory tree, `.obsidian/`, agent configs
2. **Skills installed** — list all five with install location hint (`npx skills ls -g`)
3. **Obsidian** — open this workspace folder as a vault (already configured)
4. **What's next** — the four verbs (below)

## Teach the Verbs (always end with this)


| Verb        | Skill          | Example phrases                                                                 |
| ----------- | -------------- | ------------------------------------------------------------------------------- |
| **learn**   | vortex-learn   | "Learn this article" · "Add to inbox" · "Process my inbox"                      |
| **fact**    | vortex-fact    | "Fact: I'm targeting ETA deals under ₹5Cr" · "Fact (pending): decide by Friday" |
| **query**   | vortex-query   | "What do I know about ETA?" · "What's in my inbox?"                             |
| **compile** | vortex-compile | "Refresh context.md"                                                            |


**Learn vs fact:** learn = outside world → you (library). fact = what is true for you (facts).

Hook: *"I don't re-explain my life to AI every time. I log, save, ask, and compile."*

## Reference Files

Bundled at `<skill-directory>/references/`:

- `context-schema.md` — canonical context rules (single source for agent configs)
- `agent-configs/claude-code.md`
- `agent-configs/codex.md`
- `agent-configs/cursor.md`
- `agent-configs/gemini.md`

## Do Not

- Overwrite or "repair" an existing `context/`
- Improvise folder names or roles — follow `context-schema.md`
- Install optional CLI tools (summarize, qmd, etc.) — out of scope for vortex
- Process inbox, log facts, query, or compile — other skills handle those

