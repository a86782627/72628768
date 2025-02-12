# Download the image
Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"

# Open the downloaded image
Start-Process "$env:TEMP\blue-bird.jpg"

# Open a new Command Prompt window and log "Hello World!"
Start-Process cmd -ArgumentList "/k", "echo Hello World!"