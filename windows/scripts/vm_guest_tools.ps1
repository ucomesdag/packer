$vmware_tools_url = "http://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/2985596/windows/packages/tools-windows.tar"
$7zip_url = "http://www.7-zip.org/a/7z920-x64.msi"
$7zip_installer = "c:\windows\temp\7z920-x64.msi"
$7zip_exe = "c:\program files\7-Zip\7z.exe"

# Wait for Network
$tries = 30
while (1) {
  &ping -n 1 "8.8.8.8" | out-null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "Network available." -ForegroundColor Green
    break
  }
  if ( $tries -gt 0 -and $try++ -ge $tries ) {
    throw "Network unavailable after $try tries."
  }
  start-sleep -s 1
}

# Download 7-zip
if (-not ($7zip_installer | Test-Path)) {
  (New-Object System.Net.WebClient).DownloadFile($7zip_url, $7zip_installer)
  if ($LASTEXITCODE -ne 0) {
    throw "Download failed!"
  }
  Write-Host "Downloaded 7-zip." -ForegroundColor Green
}

# Install 7-zip
Start-Process msiexec -Wait -ArgumentList /qb,/i,$7zip_installer | out-null
Write-Host "Installed 7-zip." -ForegroundColor Green

# Install VMWare Tools
if ($env:PACKER_BUILDER_TYPE -eq "vmware-iso") {
  if ("c:\users\vagrant\windows.iso" | Test-Path) {
    move-item -path c:\users\vagrant\windows.iso -destination c:\windows\temp -force
  } else {
    (New-Object System.Net.WebClient).DownloadFile($vmware_tools_url, "c:\windows\temp\vmware-tools.tar")
    if ($LASTEXITCODE -ne 0) {
      throw "Download failed!"
    }
    &"$7zip_exe" x "c:\windows\temp\vmware-tools.tar" "-oc:\windows\temp" -y | out-null
    move-item -path c:\windows\temp\vmware-tools-windows-*.iso -destination c:\windows\temp\windows.iso -force
    Write-Host "Downloaded VMWare Tools." -ForegroundColor Green
  }
  &"$7zip_exe" x "c:\windows\temp\windows.iso" "-oc:\windows\temp\vmware" -y | out-null
  Write-Host "Extracted VMWare Tools." -ForegroundColor Green
  Start-Process c:\Windows\temp\vmware\setup.exe -Wait -ArgumentList /S,/v,"/qn REBOOT=R\"
  Remove-Item -path c:\Windows\temp\vmware -recurse -force | out-null
  Remove-Item -path c:\windows\temp\vmware-tools.tar -force | out-null
  Remove-Item -path c:\windows\temp\windows.iso -force | out-null
  Write-Host "Installed VMWare Tools." -ForegroundColor Green
}

# Install VBoxGuestAdditions
if ($env:PACKER_BUILDER_TYPE -eq "virtualbox-iso") {
  move-item -path c:\users\vagrant\vboxguestadditions.iso -destination c:\windows\temp -force
  &"$7zip_exe" x "c:\windows\temp\vboxguestadditions.iso" "-oc:\windows\temp\virtualbox" -y | out-null
  Write-Host "Extracted VBoxGuestAdditions." -ForegroundColor Green
  $files = @(Get-ChildItem c:\windows\temp\virtualbox\cert\vbox*.cer)
  foreach ($file in $files) {
    &c:\Windows\temp\virtualbox\cert\vboxcertutil add-trusted-publisher $file --root $file 2>&1 | out-null
  }
  Write-Host "Added Oracle to Trusted Publishers." -ForegroundColor Green
  Start-Process c:\Windows\temp\virtualbox\vboxwindowsadditions.exe -Wait -ArgumentList /S
  Remove-Item -path c:\Windows\temp\virtualbox -recurse -force | out-null
  Remove-Item -path c:\windows\temp\vboxguestadditions.iso -force | out-null
  Write-Host "Installed VBoxGuestAdditions." -ForegroundColor Green
}

# Install Parallels Tools
if ($env:PACKER_BUILDER_TYPE -eq "parallels-iso") {
  if ("c:\users\vagrant\prl-tools-win.iso" | Test-Path) {
    move-item -path c:\users\vagrant\prl-tools-win.iso -destination c:\windows\temp -force
    &"$7zip_exe" x "c:\windows\temp\prl-tools-win.iso" "-oc:\windows\temp\parallels" -y | out-null
    Write-Host "Extracted Parallels Tools." -ForegroundColor Green
    Start-Process c:\Windows\temp\parallels\ptagent.exe -Wait -ArgumentList /install_silent
    Remove-Item -path c:\Windows\temp\parallels -recurse -force | out-null
    Remove-Item -path c:\windows\temp\prl-tools-win.iso -force | out-null
    Write-Host "Installed Parallels Tools." -ForegroundColor Green
  }
}

# Remove 7-zip
Start-Process msiexec -Wait -ArgumentList /qb,/x,$7zip_installer
Remove-Item -path $7zip_installer -force | out-null
Write-Host "Removed 7-zip." -ForegroundColor Green
