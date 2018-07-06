# Stop Update Service
Stop-Service wuauserv 2>&1 | out-null
Write-Host "Stoped Update Service." -ForegroundColor Green

# Enable Featured Software
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v EnableFeaturedSoftware /t REG_DWORD /d 1 /f | out-null
Write-Host "Enabled Featured Software." -ForegroundColor Green

# Include Recommended Updates
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v IncludeRecommendedUpdates /t REG_DWORD /d 1 /f | out-null
Write-Host "Included Recommended Updates." -ForegroundColor Green

# Enable Auto Updates
Write-output 'Set ServiceManager = CreateObject("Microsoft.Update.ServiceManager")' | Out-File A:\temp.vbs | out-null
Write-output 'Set NewUpdateService = ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")' | Out-File A:\temp.vbs -Append | out-null
cscript A:\temp.vbs | out-null

Write-Host "Enabled Auto Updates." -ForegroundColor Green

# Start Update Service
Start-Service wuauserv | out-null
Write-Host "Started Update Service." -ForegroundColor Green

# write-host "Press any key to continue..."
# [void][System.Console]::ReadKey($true)