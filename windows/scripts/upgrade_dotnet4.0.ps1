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

# Upgrade NET Framework
$versions = Get-ChildItem -Path 'HKLM:\Software\Microsoft\NET Framework Setup\NDP' | Where-Object -FilterScript {$_.name -match 'v[0-9]\.[0-9]'} | Get-ItemProperty 
$latest = ($versions | Sort-Object PSChildName | Select-Object -Last 1).PSChildName -Replace "v",""
if ([Version]$latest -lt [Version]"4.0") {
  $url = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"
  $filename = $url.Split("/")[-1]
  $file = "$env:temp\$filename"
  Write-Host "Downloading NET Framework 4.0.." -ForegroundColor Yellow
  (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
  Write-Host "Installing NET Framework 4.0.." -ForegroundColor Yellow
  &"$file" /q | out-null
  Write-Host "NET Framework upgraded to version 4.0." -ForegroundColor Green
  # Restart-Computer -Force 
  exit 0 
}
