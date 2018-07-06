# Set Execution Policy 64 Bit
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
Write-Host "Set PowerShell Execution Policy 64 Bit." -ForegroundColor Green

# Set Execution Policy 32 Bit
&$env:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"
Write-Host "Set PowerShell Execution Policy 32 Bit." -ForegroundColor Green

# write-host "Press any key to continue..."
# [void][System.Console]::ReadKey($true)