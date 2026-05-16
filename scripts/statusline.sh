#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd' | sed 's|/mnt/c/[Uu]sers/woute/Dropbox/Personal/Programming/UnixCode/|code/|')
model=$(echo "$input" | jq -r '.model.display_name // empty' | sed 's/ (1M context)//')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Percentage first
if [ -n "$used" ]; then
  printf "%s%% " "$(printf '%.0f' "$used")"
fi

# Bold blue cwd
printf "\033[01;34m%s\033[00m" "$cwd"

# Append model name if available
if [ -n "$model" ]; then
  printf " [%s]" "$model"
fi
