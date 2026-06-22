# Gemini CLI Agent Config Template

This template generates a `GEMINI.md` file at the workspace root.

## Output File

- **Filename:** `GEMINI.md`
- **Location:** Workspace root

## Template

The onboarding skill should generate a file with this structure, replacing all `{{placeholder}}` values with the user's wizard answers:

---

    # Vortex Context

    > {{DOMAIN_DESCRIPTION}}

    ## Tags

    {{DOMAIN_TAGS}}

    ## Context Rules

    You maintain a personal context system in `context/`. You never improvise structure — follow the schema below and use the Vortex skills.

    ## Vortex Skills

    | Skill | Use when |
    |-------|----------|
    | vortex-learn | "Learn this", "Add to inbox", "Process my inbox" |
    | vortex-fact | "Fact: …", "Fact (pending): …" |
    | vortex-query | "What do I know about…?", "What's in my inbox?" |
    | vortex-compile | "Refresh context.md" |

    Installed globally via: `npx skills add welluable/vortex-skills -g --all -y`

    {{CONTEXT_SCHEMA}}

## Placeholder Definitions

- `{{DOMAIN_DESCRIPTION}}` — the domain/topic from wizard step 1, formatted as a one-line description
- `{{DOMAIN_TAGS}}` — a bullet list of 5-8 suggested tags relevant to the domain
- `{{CONTEXT_SCHEMA}}` — the full contents of `references/context-schema.md`, starting from the `## Layout` section
