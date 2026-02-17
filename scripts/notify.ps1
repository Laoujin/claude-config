$json = [Console]::In.ReadToEnd() | ConvertFrom-Json
$title = if ($json.title) { $json.title } else { "Claude Code" }
$msg   = if ($json.message) { $json.message } else { "Waiting for your input" }

Add-Type -AssemblyName System.Windows.Forms
$n = New-Object System.Windows.Forms.NotifyIcon
$n.Icon    = [System.Drawing.SystemIcons]::Information
$n.Visible = $true
$n.ShowBalloonTip(10000, $title, $msg, [System.Windows.Forms.ToolTipIcon]::Info)
Start-Sleep -Seconds 11
$n.Dispose()
