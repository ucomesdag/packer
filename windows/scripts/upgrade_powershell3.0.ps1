#Fix: The OS handle's position is not what FileStream expected
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
$consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
[void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
$field.SetValue($consoleHost, [Console]::Out)
$field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
$field2.SetValue($consoleHost, [Console]::Out)
#EndFix

# https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html#host-requirements

# Upgrade PowerShell
if ($PSVersionTable.PSVersion.Major -lt 3) {
  $os_version = [Version](Get-Item -Path "$env:SystemRoot\System32\kernel32.dll").VersionInfo.ProductVersion
  $architecture = $env:PROCESSOR_ARCHITECTURE
  if ($architecture -eq "AMD64") {
      $architecture = "x64"
  } else {
      $architecture = "x86"
  }
  if ($os_version.Minor -eq 1) {
    $url = "https://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-$($architecture).msu"
  } else {
    $url = "https://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.0-KB2506146-$($architecture).msu"
  }
  $filename = $url.Split("/")[-1]
  $file = "$env:temp\$filename"
  Write-Host "Downloading PowerShell 3.0.." -ForegroundColor Yellow  
  (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
  Write-Host "Installing PowerShell 3.0.." -ForegroundColor Yellow  
  &wusa $file /quiet /norestart | out-null
  Write-Host "PowerShell upgraded to version 3.0." -ForegroundColor Green
  # Restart-Computer -Force 
  exit 0 
}
