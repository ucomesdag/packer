# Enable Remote Desktop
# Reference: http://social.technet.microsoft.com/Forums/windowsserver/en-US/323d6bab-e3a9-4d9d-8fa8-dc4277be1729/enable-remote-desktop-connections-with-powershell
(Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices).SetAllowTsConnections(1,1) | out-null
(Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0) | out-null
Write-Host "Enabled Remote Desktop." -ForegroundColor Green

# Open Windows Firewall for Remote Desktop
netsh advfirewall firewall set rule  group='remote desktop' new enable=Yes | out-null
Write-Host "Remote Desktop allowed in the Windows Firewall." -ForegroundColor Green