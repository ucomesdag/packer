# Remove log files
$path = 'c:\Windows\Logs\dosvc'
if (Test-Path $path) {
  Get-Childitem  $path | Remove-Item -ErrorAction SilentlyContinue | out-null
  Write-Host "Removed log files." -ForegroundColor Green
}

# Remove recents
Remove-Item -Force -Recurse "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Recent\*" | out-null
Write-Host "Removed recents." -ForegroundColor Green

# Clean up disk space
Write-Host "Start cleaning up disk space." -ForegroundColor Green
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files' -Name StateFlags0001 -Value 2 -PropertyType DWORD 2>&1 | out-null
Start-Process -FilePath CleanMgr.exe -ArgumentList '/verylowdisk /d c: /sagerun:1' -WindowStyle Hidden -Wait
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\*' -Name StateFlags0001 -ErrorAction SilentlyContinue | Remove-ItemProperty -Name StateFlags0001 -ErrorAction SilentlyContinue
Write-Host "Cleaned up disk space." -ForegroundColor Green

# Defrag C
Write-Host "Start defragmentation of disk." -ForegroundColor Green
&defrag.exe c: -x -h | out-null
Write-Host "Defraged disk." -ForegroundColor Green

# Zero out free space with SDelete
# Wait for Network
$tries = 30
while (1) {
  &ping -n 1 '8.8.8.8' | out-null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Network available." -ForegroundColor Green
    break
  }
  if ( $tries -gt 0 -and $try++ -ge $tries ) {
    throw "Network unavailable after $try tries."
  }
  start-sleep -s 1
}
Write-Host "Downloading SDelete.." -ForegroundColor Green
(New-Object Net.WebClient).DownloadFile('https://download.sysinternals.com/files/SDelete.zip','c:\sdelete.zip')
New-Item -ItemType Directory -Force -Path 'c:\sdelete' | out-null
(new-object -com shell.application).namespace('c:\sdelete').CopyHere((new-object -com shell.application).namespace('c:\sdelete.zip').Items(),16) | out-null
Remove-Item -Force 'c:\sdelete.zip' | out-null
New-Item "HKCU:Software\Sysinternals\SDelete" -Force | New-ItemProperty -Name "EulaAccepted" -PropertyType DWord -Value 1 -Force | out-null
Write-Host "Running SDelete.." -ForegroundColor Green
&c:\sdelete\sdelete64.exe -nobanner -p 1 -z c: 2>&1 | out-null
Remove-Item -Path "HKCU:Software\Sysinternals" -Recurse  | out-null
Remove-Item -Force -Recurse 'c:\sdelete\'  | out-null
Write-Host "Zeroed out free space with SDelete." -ForegroundColor Green
