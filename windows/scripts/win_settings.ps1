# Disable Network prompt
&reg add "HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f | out-null
Write-Host "Disabled Network prompts." -ForegroundColor Green

# Show file extensions in Windows Explorer
&reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v "HideFileExt" /t REG_DWORD /d 0 /f | out-null
Write-Host "Enabled file extensions in Windows Explorer." -ForegroundColor Green

# Enable QuickEdit mode
&reg add  "HKCU\Console" /v "QuickEdit" /t REG_DWORD /d 1 /f | out-null
Write-Host "Enabled QuickEdit mode." -ForegroundColor Green

# Show Run command in Start Menu
&reg add  "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v "Start_ShowRun" /t REG_DWORD /d 1 /f | out-null
Write-Host "Added the Run command to the Start Menu." -ForegroundColor Green

# Show Administrative Tools in Start Menu
&reg add  "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v "StartMenuAdminTools" /t REG_DWORD /d 1 /f | out-null
Write-Host "Added Administrative Tools in Start Menu." -ForegroundColor Green

# Zero Hibernation File
&reg add  "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v "HibernateFileSizePercent" /t REG_DWORD /d 0 /f | out-null
Write-Host "Zeroed the Hibernation File." -ForegroundColor Green

# Disable Hibernation Mode
&reg add  "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v "HibernateEnabled" /t REG_DWORD /d 0 /f | out-null
Write-Host "Disabled Hibernation mode." -ForegroundColor Green
