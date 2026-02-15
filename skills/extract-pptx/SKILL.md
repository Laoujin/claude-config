---
name: extract-pptx
description: Extract all text from a PowerPoint (.pptx) file and display it slide by slide. Use when the user points to a .pptx file or asks to read/analyze a presentation.
allowed-tools: Bash(python *)
---

# Extract PowerPoint Text

Extract and display all text from a PowerPoint file organized by slide.

## Usage

Run the extraction script on the provided PPTX file:

```bash
python ~/.claude/skills/extract-pptx/scripts/extract_pptx.py "$ARGUMENTS"
```

Requires `python-pptx`: install with `pip install python-pptx` if not available.
