# Disable Automatic Updates
# Reference: http://www.benmorris.me/2012/05/1st-test-blog-post.html
$AutoUpdate = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$AutoUpdate.NotificationLevel = 1
$AutoUpdate.Save()
$Updates.Refresh()
Write-Host "Windows Update has been disabled." -ForegroundColor Green

# write-host "Press any key to continue..."
# [void][System.Console]::ReadKey($true)