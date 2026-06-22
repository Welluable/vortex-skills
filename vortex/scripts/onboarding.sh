#!/bin/bash
set -e

# Vortex — Onboarding Script
# Scaffolds context/ and minimal .obsidian/ at workspace root.
#
# Usage: bash onboarding.sh <workspace-root> "<domain-description>" "<tags-csv>"
# Example: bash onboarding.sh . "Career and business strategy" "career,business,strategy"
# Aborts if context/ already exists. Progress to stderr; JSON summary to stdout.

WORKSPACE="${1:-.}"
DOMAIN="${2:-Personal context}"
TAGS_CSV="${3:-personal}"
DATE=$(date +%Y-%m-%d)

CONTEXT="$WORKSPACE/context"

if [ -d "$CONTEXT" ]; then
  echo "ERROR: context/ already exists at $CONTEXT — aborting." >&2
  exit 1
fi

echo "=== Vortex Onboarding ===" >&2
echo "Creating context/ structure..." >&2

mkdir -p "$CONTEXT/inbox/read"
mkdir -p "$CONTEXT/library"
mkdir -p "$CONTEXT/facts"
mkdir -p "$CONTEXT/track"
mkdir -p "$CONTEXT/insights"

# index.md
IFS=',' read -ra TAG_ARRAY <<< "$TAGS_CSV"
TAG_YAML="["
for i in "${!TAG_ARRAY[@]}"; do
  [ "$i" -gt 0 ] && TAG_YAML+=", "
  TAG_YAML+="\"${TAG_ARRAY[$i]}\""
done
TAG_YAML+="]"

cat > "$CONTEXT/index.md" << EOF
---
description: ${DOMAIN}
tags: ${TAG_YAML}
created: ${DATE}
updated: ${DATE}
---

# Index

Agent-maintained catalog of context entries. Users need not edit this file.

## Library

## Facts

## Track

## Insights

## Inbox
EOF

# context.md stub
cat > "$CONTEXT/context.md" << EOF
# Context

> ${DOMAIN}

_Compiled snapshot for external AI. Run **vortex-compile** to refresh._

EOF

# README.md
cat > "$CONTEXT/README.md" << 'EOF'
# Your Context

Five verbs:

| Verb | Say | Goes to |
|------|-----|---------|
| **learn** | "Learn this" / "Process my inbox" | library/ + track/ |
| **fact** | "Fact: …" / "Fact (pending): …" | facts/ |
| **query** | "What do I know about…?" | read-only search |
| **compile** | "Refresh context.md" | context.md |

**Folders**

- **inbox/** — not processed yet
- **inbox/read/** — originals after learning (never deleted)
- **library/** — summaries from sources
- **facts/** — your decisions and truths (incl. pending)
- **track/** — people, orgs, places, concepts, projects, tools
- **insights/** — dated reports and synthesis
- **context.md** — one file for any AI

> Inbox = haven't learned yet. Library = extracted. Facts = you decided. Track = names and ideas. Insights = reports. context.md = export.
EOF

# Minimal .obsidian/
mkdir -p "$WORKSPACE/.obsidian"
if [ ! -f "$WORKSPACE/.obsidian/app.json" ]; then
  cat > "$WORKSPACE/.obsidian/app.json" << 'EOF'
{
  "alwaysUpdateLinks": true,
  "newFileLocation": "folder",
  "newFileFolderPath": "context/inbox"
}
EOF
fi

echo "Onboarding complete." >&2

WORKSPACE_ABS=$(cd "$WORKSPACE" && pwd)
cat << JSONEOF
{
  "status": "complete",
  "workspace": "$WORKSPACE_ABS",
  "context_root": "$WORKSPACE_ABS/context",
  "directories": [
    "context/inbox/",
    "context/inbox/read/",
    "context/library/",
    "context/facts/",
    "context/track/",
    "context/insights/"
  ],
  "files": [
    "context/index.md",
    "context/context.md",
    "context/README.md",
    ".obsidian/app.json"
  ]
}
JSONEOF
