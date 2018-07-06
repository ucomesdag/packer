# Disable UAC
# New-ItemProperty -Path "HKLM:Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path "HKLM:Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "User Access Control (UAC) has been disabled." -ForegroundColor Green

# Disable the shutdown tracker
# Reference: http://www.askvg.com/how-to-disable-remove-annoying-shutdown-event-tracker-in-windows-server-2003-2008/
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability")) {
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" | out-null
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -PropertyType DWord -Value 0 -Force -ErrorAction continue | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonUI" -PropertyType DWord -Value 0 -Force -ErrorAction continue | out-null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonOn" -Value 0 | out-null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Reliability" -Name "ShutdownReasonUI" -Value 0 | out-null
Write-Host "Shutdown Tracker has been disabled." -ForegroundColor Green

# Disable the system restore feature
Disable-ComputerRestore C:
Write-Host "Disabled the system restore feature." -ForegroundColor Green

# Disable hibernation
powercfg -h off
Write-Host "Disabled hibernation." -ForegroundColor Green

# Disable Complex Passwords
# Reference: http://vlasenko.org/2011/04/27/removing-password-complexity-requirements-from-windows-server-2008-core/
$seccfg = [IO.Path]::GetTempFileName()
secedit /export /cfg $seccfg | out-null
(Get-Content $seccfg) | Foreach-Object {$_ -replace "PasswordComplexity\s*=\s*1", "PasswordComplexity=0"} | Set-Content $seccfg
secedit /configure /db $env:windir\security\new.sdb /cfg $seccfg /areas SECURITYPOLICY | out-null
del $seccfg | out-null
Write-Host "Complex Passwords have been disabled." -ForegroundColor Green

# Create local vagrant user
$userDirectory = [ADSI]"WinNT://$env:ComputerName"
#      Determine if 'vagrant' user already exists. Update if so.
$user = $userDirectory.PSBase.Children | Where-Object { $_.PSBase.SchemaClassName -eq "User" -and $_.Name -eq "vagrant" }
if ($user)
{
    Write-Host "vagrant user already exists, will just update it"
}
else
{
    Write-Host "vagrant user does not exist, creating"
    $user = $userDirectory.Create("User", "vagrant")
}
$user.SetPassword("vagrant")
$user.SetInfo()
$user.UserFlags = 65536 # ADS_UF_DONT_EXPIRE_PASSWD. Would set it not to not allow changing password but it's disabled on Win 8 by default.
$user.SetInfo()
$user.FullName = "vagrant"
$user.SetInfo()
$admin = $userDirectory.PSBase.Children.Find("Administrators")
#$members = $admin.PSBase.Invoke("Members")
#$isAdmin = $members | % { $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) } | Where-Object { $_ -eq "vagrant" }
$members = net localgroup administrators | where {$_ -AND $_ -notmatch "command completed successfully"} | select -skip 4
$isAdmin = $members | Where-Object { $_ -eq "vagrant" }
if (!$isAdmin) { $admin.Add("WinNT://$env:ComputerName/vagrant") }
Write-Host "User: 'vagrant' has been created as a local administrator." -ForegroundColor Green