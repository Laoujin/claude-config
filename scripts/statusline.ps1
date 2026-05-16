$raw = $input | Out-String
$raw | Set-Content "$env:TEMP\claude-statusline.json"
$json = $raw | ConvertFrom-Json
$h5 = if ($json.rate_limits.five_hour.used_percentage) { [math]::Round($json.rate_limits.five_hour.used_percentage) } else { $null }
$d7 = if ($json.rate_limits.seven_day.used_percentage) { [math]::Round($json.rate_limits.seven_day.used_percentage) } else { $null }
$ctx = if ($json.context_window.used_percentage) { [math]::Round($json.context_window.used_percentage) } else { $null }

$cwd = $json.cwd -replace [regex]::Escape('/mnt/c/Users/woute/Dropbox/Personal/Programming/UnixCode/'), 'code/'

$parts = @()
if ($null -ne $ctx) { $parts += "ctx: $ctx%" }
if ($null -ne $h5) { $parts += "h5: $h5%" }
if ($null -ne $d7) { $parts += "d7: $d7%" }
$parts += $cwd
[Console]::Write($parts -join "|")
