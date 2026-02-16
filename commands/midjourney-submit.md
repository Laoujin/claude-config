---
name: 'midjourney-submit'
description: 'Submit Midjourney prompts from a markdown file via Playwright browser automation'
---

# Midjourney Prompt Submitter

Submit all Midjourney prompts found in a markdown file to midjourney.com via browser automation.

## Instructions

1. **Accept a file path argument.** If no argument is provided, ask the user which file contains the prompts.

2. **Read the file** and extract all text inside fenced code blocks (``` delimiters). Each code block is one Midjourney prompt.

3. **Optionally filter prompts.** If the user provided a second argument (a filter string), only submit prompts from sections whose heading contains that string (case-insensitive). For example: `/midjourney-submit brainstorming-session-2026-02-16.md "Logo Mark"` would only submit prompts under headings containing "Logo Mark".

4. **Navigate to midjourney.com** using the Playwright MCP browser tools. Take a snapshot to verify the user is logged in (look for the prompt input textbox "What will you imagine?"). If not logged in, tell the user to log in manually and wait.

5. **Submit each prompt** sequentially:
   - Click the prompt input textbox
   - Type the prompt text into the field
   - Press Enter to submit
   - Wait briefly (1-2 seconds) between submissions to avoid rate limiting
   - Report progress: "Submitted X/Y: [first 60 chars of prompt]..."

6. **After all prompts are submitted**, report the total count and tell the user to check the Imagine tab for results.

## Error Handling

- If the textbox reference becomes stale, take a fresh snapshot and re-locate the input field
- If a submission fails, report the error and continue with the next prompt
- If the page navigates away, navigate back to midjourney.com and resume

## Notes

- The user MUST be logged into midjourney.com before running this skill
- Prompts are submitted in the order they appear in the file
- Each prompt generates a batch of 4 images on Midjourney's side
