#!/usr/bin/env bash
# subagentStatusLine: called per refresh tick with the FULL panel state on stdin:
# { session_id, transcript_path, cwd, columns, tasks:[{id,name,type,status,
# description,label,startTime,tokenCount,tokenSamples,cwd}] }.
# Output: ONE JSON line per row -> {"id": "<task_id>", "content": "<text>"}.
# A bare text line renders nothing — Claude Code matches output to a task by id.
in=$(cat)
now=$(date +%s%3N)
printf '%s' "$in" | jq -rc --argjson now "$now" '
  .tasks[]
  | ((($now - .startTime) / 1000) | floor) as $secs
  | { id, content: "🟠 itenium · \(.label // .description) · \(.status) · \(.tokenCount)t · \($secs)s" }
' 2>/dev/null
