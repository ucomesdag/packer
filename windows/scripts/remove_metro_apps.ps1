# # Remove all of the metro apps
Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -Register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode} 2>&1 | out-null
Get-AppXPackage -AllUsers | Remove-AppXPackage -ErrorAction SilentlyContinue | out-null
Get-AppXProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | out-null
Write-Host "Removed all the metro apps." -ForegroundColor Green

# Fix for ghost icons of uninstalled metroapps
# Stop-Service -Name tiledatamodelsvc -Force
# Stop-Service -Name tiledatamodelsvc -Force
# Stop-Service -Name StateRepository -Force
# Remove-Item -Force ${env:LocalAppData}\TileDataLayer\Database\vedatamodel.edb
# # C:\ProgramData\Microsoft\Windows\Start Menu\Programs
# sfc /scannow
# # Restart-Computer -Force
