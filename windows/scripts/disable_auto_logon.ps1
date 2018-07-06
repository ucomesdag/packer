# Disable Auto Login
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /d 0 /f
Write-Host "Disabled Auto Login." -ForegroundColor Green