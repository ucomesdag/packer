# # Remove all of the metro apps
# Get-AppXPackage -AllUsers | Remove-AppXPackage -ErrorAction SilentlyContinue | out-null
# Get-AppXProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue  | out-null
# Write-Host "Removed all the metro apps." -ForegroundColor Green

# Remove log files
Get-Childitem 'C:\Windows\Logs\dosvc' | Remove-Item -ErrorAction SilentlyContinue | out-null
Write-Host "Removed log files." -ForegroundColor Green

# Remove recents
Remove-Item -Force -Recurse "${env:USERPROFILE}\AppData\Roaming\Microsoft\Windows\Recent\*" | out-null
Write-Host "Removed recents." -ForegroundColor Green

# Clean up disk space
&cleanmgr.exe /verylowdisk /d c:
Write-Host "Cleaned up disk space." -ForegroundColor Green

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

(New-Object Net.WebClient).DownloadFile('https://download.sysinternals.com/files/SDelete.zip','c:\sdelete.zip')
Write-Host "Downloaded SDelete." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path 'c:\sdelete' | out-null
(new-object -com shell.application).namespace('c:\sdelete').CopyHere((new-object -com shell.application).namespace('c:\sdelete.zip').Items(),16) | out-null
Remove-Item -Force 'c:\sdelete.zip' | out-null
New-Item "HKCU:Software\Sysinternals\SDelete" -Force | New-ItemProperty -Name "EulaAccepted" -PropertyType DWord -Value 1 -Force | out-null
&c:\sdelete\sdelete64.exe -nobanner -p 1 -z c: 2>&1 | out-null
Remove-Item -Path "HKCU:Software\Sysinternals" -Recurse  | out-null
Remove-Item -Force -Recurse 'c:\sdelete\'  | out-null
Write-Host "Zeroed out free space with SDelete." -ForegroundColor Green
