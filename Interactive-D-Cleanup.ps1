# D: Drive Interactive Cleanup Script
# Scans the D: drive for common clutter (Temp files, Recycle Bin) and large folders.

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

# Ensure D: drive exists
if (-not (Test-Path D:\)) {
    Write-Host "D: Drive not found on this system!" -ForegroundColor Red
    Exit
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   D: Drive Interactive Cleanup utility   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Scanning your D: drive. This might take a moment..."

# 1. Recycle Bin on D: drive
$recyclePath = 'D:\$RECYCLE.BIN'
$recycleSize = (Get-FolderSize $recyclePath) / 1MB
Prompt-Cleanup -Name "Recycle Bin (D: Drive)" -SizeMB $recycleSize -Action {
    Remove-Item "$recyclePath\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 2. Common Temp Folders on D:
$tempPaths = @('D:\Temp', 'D:\tmp', 'D:\Windows\Temp')
foreach ($tp in $tempPaths) {
    if (Test-Path $tp) {
        $tsize = (Get-FolderSize $tp) / 1MB
        Prompt-Cleanup -Name "Temp Folder ($tp)" -SizeMB $tsize -Action {
            Remove-Item "$tp\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# 3. Delivery Optimization / WU Download cache (If moved to D:)
$doPath = 'D:\DeliveryOptimization'
if (Test-Path $doPath) {
    $doSize = (Get-FolderSize $doPath) / 1MB
    Prompt-Cleanup -Name "Windows Delivery Optimization Files ($doPath)" -SizeMB $doSize -Action {
        Remove-Item "$doPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 4. Steam / Game Caches (Optional: generic cache scan)
$steamCache = 'D:\SteamLibrary\steamapps\downloading'
if (Test-Path $steamCache) {
    $scSize = (Get-FolderSize $steamCache) / 1MB
    Prompt-Cleanup -Name "Steam Incomplete Downloads ($steamCache)" -SizeMB $scSize -Action {
        Remove-Item "$steamCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "--- Large Folders Scan ---" -ForegroundColor Cyan
Write-Host "Scanning for top 10 largest folders on D:\ root..."
$largeFolders = Get-ChildItem D:\ -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
    $size = Get-FolderSize $_.FullName
    [PSCustomObject]@{
        Name = $_.FullName
        SizeMB = $size / 1MB
    }
} | Sort-Object SizeMB -Descending | Select-Object -First 10

if ($largeFolders) {
    Write-Host ""
    $largeFolders | Format-Table @{Label="Folder Path"; Expression={$_.Name}}, @{Label="Size (MB)"; Expression={"{0:N2}" -f $_.SizeMB}} -AutoSize
    Write-Host "Note: Review these folders manually. They might contain important games, backups, or projects." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Cleanup Complete!" -ForegroundColor Green
$drive = Get-PSDrive D
Write-Host ("D: Drive Free Space: {0:N2} GB" -f ($drive.Free / 1GB)) -ForegroundColor Cyan
