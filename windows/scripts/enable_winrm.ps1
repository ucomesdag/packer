# Enable WinRM Control
winrm quickconfig -q | out-null
winrm quickconfig -transport:http | out-null
winrm set winrm/config '@{MaxTimeoutms="1800000"}' | out-null
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}' | out-null
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="100"}' | out-null
winrm set winrm/config/service '@{AllowUnencrypted="true"}' | out-null
winrm set winrm/config/service/auth '@{Basic="true"}' | out-null
winrm set winrm/config/client/auth '@{Basic="true"}' | out-null
winrm set winrm/config/client '@{TrustedHosts="*"}' | out-null
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}' | out-null
Write-Host "WinRM is configured." -ForegroundColor Green

# Enable WinRM service at boot
Stop-Service -Name "WinRM"
Set-Service -Name "WinRM" -StartupType Automatic
Start-Service -Name "WinRM" -ErrorAction Stop
Write-Host "WinRM service set to start automatically on boot." -ForegroundColor Green

# Open Windows Firewall for Remote Administration
netsh advfirewall firewall set rule  group='remote desktop' new enable=Yes | out-null
netsh advfirewall firewall add rule profile=any name="Allow WinRM HTTP" dir=in localport=5985 protocol=TCP action=allow | out-null
# netsh advfirewall firewall add rule profile=any name="Allow WinRM HTTPS" dir=in localport=5986 protocol=TCP action=allow | out-null
Write-Host "WinRM allowed in Windows Firewall." -ForegroundColor Green

# write-host "Press any key to continue..."
# [void][System.Console]::ReadKey($true)
