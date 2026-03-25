---
name: 'midjourney-submit'
description: 'Submit Midjourney prompts from a markdown file via Playwright browser automation'
---

# Midjourney Prompt Submitter

Submit prompts from a markdown file to midjourney.com using `playwright-cli`.

**Windows:** Wrap commands: `node -e "const{execSync:e}=require('child_process');console.log(e('playwright-cli <cmd>',{encoding:'utf8'}));"`

## Workflow

1. Read file argument (or ask user). Extract text from fenced code blocks - each block is one prompt.
2. Optional second arg filters to sections whose heading contains that string (case-insensitive).
3. Open browser: `playwright-cli open https://www.midjourney.com --headed` then `snapshot`.
4. Verify logged in (look for "What will you imagine?" input). If not, wait for manual login.
5. For each prompt: `click <ref>`, `fill <ref> "<prompt>"`, `press Enter`. Wait 2s between submissions.
6. Report progress and total when done.

## playwright-cli Commands

`snapshot` (saves to `.playwright-cli/page-*.yml`), `click <ref>`, `fill <ref> <text>`, `press <key>`, `goto <url>`, `eval <func>`

On stale refs, re-run `snapshot`. On navigation, `goto` back and resume.
