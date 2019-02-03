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

# Install SP1
$version = (Get-WMIObject win32_operatingsystem).ServicePackMajorVersion
if ($version -lt 1) {
  $architecture = $env:PROCESSOR_ARCHITECTURE
  if ($architecture -eq "AMD64") {
      $architecture = "X64"
  } else {
      $architecture = "X86"
  }
  $url = "https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-$($architecture).exe"
  $filename = $url.Split("/")[-1]
  $file = "$env:temp\$filename"
  Write-Host "Downloading SP1.." -ForegroundColor Yellow
  (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
  Write-Host "Installing SP1.." -ForegroundColor Yellow
  &"$file" /quiet /nodialog /norestart | out-null
  Write-Host "Installed SP1." -ForegroundColor Green
  # Restart-Computer -Force 
  exit 0 
}
