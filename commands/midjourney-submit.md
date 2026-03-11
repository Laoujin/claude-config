---
name: 'midjourney-submit'
description: 'Submit Midjourney prompts from a markdown file via Playwright browser automation'
---

# Midjourney Prompt Submitter

Submit all Midjourney prompts found in a markdown file to midjourney.com via browser automation using `playwright-cli`.

## Important: Windows Workaround

On Windows, the `playwright-cli.cmd` wrapper causes output capture issues due to terminal escape sequences. Wrap commands in a node one-liner to capture stdout properly:

```bash
# Instead of: playwright-cli <command>
# Use this pattern:
node -e "const { execSync } = require('child_process'); console.log(execSync('playwright-cli <command>', { encoding: 'utf8' }));"
```

Examples:
```bash
# Open browser
node -e "const { execSync } = require('child_process'); console.log(execSync('playwright-cli open https://www.midjourney.com --headed', { encoding: 'utf8' }));"

# Take snapshot
node -e "const { execSync } = require('child_process'); console.log(execSync('playwright-cli snapshot', { encoding: 'utf8' }));"

# Click element
node -e "const { execSync } = require('child_process'); console.log(execSync('playwright-cli click e5', { encoding: 'utf8' }));"
```

## Instructions

1. **Accept a file path argument.** If no argument is provided, ask the user which file contains the prompts.

2. **Read the file** and extract all text inside fenced code blocks (``` delimiters). Each code block is one Midjourney prompt.

3. **Optionally filter prompts.** If the user provided a second argument (a filter string), only submit prompts from sections whose heading contains that string (case-insensitive). For example: `/midjourney-submit brainstorming-session-2026-02-16.md "Logo Mark"` would only submit prompts under headings containing "Logo Mark".

4. **Navigate to midjourney.com** using `playwright-cli`:
   ```bash
   playwright-cli open https://www.midjourney.com --headed
   playwright-cli snapshot
   ```
   Verify the user is logged in (look for the prompt input textbox "What will you imagine?"). If not logged in, tell the user to log in manually and wait.

5. **Submit each prompt** sequentially:
   ```bash
   playwright-cli click <ref>           # Click the prompt input textbox
   playwright-cli fill <ref> "<prompt>" # Fill the prompt text
   playwright-cli press Enter           # Submit
   ```
   - Wait briefly (1-2 seconds) between submissions: `playwright-cli eval "() => new Promise(r => setTimeout(r, 2000))"`
   - Report progress: "Submitted X/Y: [first 60 chars of prompt]..."

6. **After all prompts are submitted**, report the total count and tell the user to check the Imagine tab for results.

## playwright-cli Reference

- `playwright-cli snapshot` - Get page snapshot; saves to `.playwright-cli/page-<timestamp>.yml` - read this file to get element refs
- `playwright-cli click <ref>` - Click an element by ref
- `playwright-cli fill <ref> <text>` - Fill text into an input field
- `playwright-cli press <key>` - Press a keyboard key
- `playwright-cli goto <url>` - Navigate to URL
- `playwright-cli eval <func>` - Execute JavaScript on page

## Error Handling

- If the textbox reference becomes stale, run `playwright-cli snapshot` again to get fresh refs
- If a submission fails, report the error and continue with the next prompt
- If the page navigates away, run `playwright-cli goto https://www.midjourney.com` and resume

## Notes

- The user MUST be logged into midjourney.com before running this skill
- Prompts are submitted in the order they appear in the file
- Each prompt generates a batch of 4 images on Midjourney's side
