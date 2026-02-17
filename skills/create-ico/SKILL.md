---
name: create-ico
description: Convert an image (PNG, JPG, etc.) to a multi-size Windows ICO file. Use when the user wants to create an icon file or convert an image to .ico format.
allowed-tools: Bash(python *)
argument-hint: <source-image> [-o output.ico] [-s 16,32,48,64,128,256]
---

# Create ICO File

Convert an image to a multi-size Windows ICO file.

## Usage

```bash
python ~/.claude/skills/create-ico/scripts/create_ico.py $ARGUMENTS
```

Requires `Pillow`: install with `pip install Pillow` if not available.

## Options

- `<source-image>` — input PNG, JPG, or other image file
- `-o <output.ico>` — output path (default: same name with `.ico` extension)
- `-s <sizes>` — comma-separated pixel sizes (default: `16,32,48,64,128,256`)

## Examples

- `/create-ico logo.png` — creates `logo.ico` with default sizes
- `/create-ico logo.png -o app.ico` — custom output name
- `/create-ico logo.png -s 16,32,256` — only specific sizes
