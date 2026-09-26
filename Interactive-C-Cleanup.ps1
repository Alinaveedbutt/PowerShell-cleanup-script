# C: Drive Interactive Cleanup Script
# This script scans common cache and temp locations, calculates their size, and asks you before deleting.
# It uses the exact steps required to safely unlock and delete files (like closing services).

function Get-FolderSize {
    param([string]$Path)
    if (Test-Path $Path) {
        return (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    }
    return 0
}

function Prompt-Cleanup {
    param([string]$Name, [double]$SizeMB, [scriptblock]$Action)
    if ($SizeMB -lt 1) { return } # Skip empty
    
    Write-Host ""
    Write-Host "Found: $Name" -ForegroundColor Cyan
    Write-Host ("Size: {0:N2} MB" -f $SizeMB) -ForegroundColor Yellow
    
    $resp = Read-Host "Do you want to delete this? (Y/N)"
    if ($resp -match '^[Yy]') {
        Write-Host "Deleting..." -ForegroundColor DarkGray
        & $Action
        Write-Host "✅ Cleared!" -ForegroundColor Green
    } else {
        Write-Host "⏭️ Skipped." -ForegroundColor Gray
    }
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   C: Drive Interactive Cleanup utility   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Scanning your drive. This might take a moment..."

# 1. Windows Update Cache
$wuPath = 'C:\Windows\SoftwareDistribution\Download'
$wuSize = (Get-FolderSize $wuPath) / 1MB
Prompt-Cleanup -Name "Windows Update Download Cache" -SizeMB $wuSize -Action {
    Write-Host "Stopping Windows Update service to unlock files..." -ForegroundColor DarkGray
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Remove-Item "$wuPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Restarting Windows Update service..." -ForegroundColor DarkGray
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
}

# 2. Browser Caches (Surgically target only Cache folders)
$localAppData = $env:LOCALAPPDATA
$browsers = @(
    @{ Name = 'Google Chrome Cache'; Path = "$localAppData\Google\Chrome\User Data" },
    @{ Name = 'Microsoft Edge Cache'; Path = "$localAppData\Microsoft\Edge\User Data" },
    @{ Name = 'Brave Browser Cache'; Path = "$localAppData\BraveSoftware\Brave-Browser\User Data" }
)

foreach ($b in $browsers) {
    if (-not (Test-Path $b.Path)) { continue }
    
    $bSize = 0
    $cachePaths = @()
    $profiles = Get-ChildItem $b.Path -Directory -Force -ErrorAction SilentlyContinue
    foreach ($profile in $profiles) {
        $dirs = @('Cache', 'Code Cache', 'GPUCache')
        foreach ($d in $dirs) {
            $p = Join-Path $profile.FullName $d
            if (Test-Path $p) {
                $bSize += (Get-FolderSize $p)
                $cachePaths += $p
            }
        }
    }
    
    Prompt-Cleanup -Name $b.Name -SizeMB ($bSize / 1MB) -Action {
        $procName = if ($b.Name -match 'Chrome') { 'chrome' } elseif ($b.Name -match 'Edge') { 'msedge' } else { 'brave' }
        Write-Host "Closing $procName to unlock files..." -ForegroundColor DarkGray
        Stop-Process -Name $procName -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        
        foreach ($p in $cachePaths) {
            Remove-Item "$p\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 3. Old Roblox Versions Cache (Roblox hoards old versions)
$robloxLocal = Join-Path $localAppData 'Roblox\Versions'
if (Test-Path $robloxLocal) {
    $versions = Get-ChildItem $robloxLocal -Directory -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending
    if ($versions.Count -gt 1) {
        $oldVersions = $versions | Select-Object -Skip 1 # Keep the 1 newest version
        $rSize = ($oldVersions | ForEach-Object { Get-FolderSize $_.FullName } | Measure-Object -Sum).Sum / 1MB
        Prompt-Cleanup -Name "Old Roblox Versions (Keeps the newest one)" -SizeMB $rSize -Action {
            $oldVersions | ForEach-Object { Remove-Item "$($_.FullName)\*" -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }
}

# 4. System Temp Files
$tempPath = $env:TEMP
$tempSize = (Get-FolderSize $tempPath) / 1MB
Prompt-Cleanup -Name "User Temp Folder (%TEMP%)" -SizeMB $tempSize -Action {
    Remove-Item "$tempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
}

$winTemp = 'C:\Windows\Temp'
$winTempSize = (Get-FolderSize $winTemp) / 1MB
Prompt-Cleanup -Name "Windows Temp Folder (C:\Windows\Temp)" -SizeMB $winTempSize -Action {
    Remove-Item "$winTemp\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 5. Developer & App Caches (Surgically target only Cache folders)
$appCaches = @(
    @{ Name = 'pip Cache (Python)'; Path = "$localAppData\pip\cache" },
    @{ Name = 'NVIDIA Shader Cache'; Path = "$localAppData\NVIDIA\DXCache" },
    @{ Name = 'Discord Cache'; Path = "$env:APPDATA\discord\Cache" },
    @{ Name = 'VS Code Cache & Extensions Installers'; Path = "$env:APPDATA\Code\CachedExtensionVSIXs" }
)

foreach ($ac in $appCaches) {
    $acSize = (Get-FolderSize $ac.Path) / 1MB
    Prompt-Cleanup -Name $ac.Name -SizeMB $acSize -Action {
        if ($ac.Name -match 'Discord') { 
            Write-Host "Closing Discord to unlock files..." -ForegroundColor DarkGray
            Stop-Process -Name 'Discord' -Force -ErrorAction SilentlyContinue; Start-Sleep 1 
        }
        Remove-Item "$($ac.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "Cleanup Complete!" -ForegroundColor Green
$drive = Get-PSDrive C
Write-Host ("C: Drive Free Space: {0:N2} GB" -f ($drive.Free / 1GB)) -ForegroundColor Cyan
