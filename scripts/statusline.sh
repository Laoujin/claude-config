#!/usr/bin/env bash
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
h5=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
d7=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Git branch (skip optional locks)
git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c gc.auto=0 symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c gc.auto=0 rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && git_branch=" ($branch)"
fi

# PS1-style line: yellow cwd + git branch
printf "\033[33m%s%s\033[0m" "$cwd" "$git_branch"

# Metrics line
parts=()
[ -n "$ctx" ] && parts+=("ctx: $(printf '%.0f' "$ctx")%")
[ -n "$h5" ]  && parts+=("5h: $(printf '%.0f' "$h5")%")
[ -n "$d7" ]  && parts+=("7d: $(printf '%.0f' "$d7")%")

if [ ${#parts[@]} -gt 0 ]; then
  printf "  \033[2m%s\033[0m" "$(IFS=' | '; echo "${parts[*]}")"
fi

printf "\n"
