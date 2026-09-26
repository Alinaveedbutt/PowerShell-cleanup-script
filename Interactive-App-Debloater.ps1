# Interactive App Debloater
# Scans AppData (Local and Roaming) for massive folders and asks if you want to wipe them.
# Great for cleaning up left-over data from uninstalled games or apps you don't use anymore.

function Get-FolderSize {
    param([string]$Path)
    if (Test-Path $Path) {
        return (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    }
    return 0
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "     Interactive App Debloater (AppData)  " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Scanning your AppData for massive folders... This takes a minute."

$appDataPaths = @(
    @{ Name = "Local AppData"; Path = $env:LOCALAPPDATA },
    @{ Name = "Roaming AppData"; Path = $env:APPDATA }
)

foreach ($loc in $appDataPaths) {
    Write-Host ""
    Write-Host "Scanning $($loc.Name)..." -ForegroundColor Yellow
    
    $largeFolders = @()
    $folders = Get-ChildItem $loc.Path -Directory -Force -ErrorAction SilentlyContinue
    
    foreach ($f in $folders) {
        $sizeMB = (Get-FolderSize $f.FullName) / 1MB
        if ($sizeMB -gt 100) { # Only flag folders larger than 100 MB
            $largeFolders += [PSCustomObject]@{
                Name = $f.Name
                FullName = $f.FullName
                SizeMB = $sizeMB
            }
        }
    }
    
    $largeFolders = $largeFolders | Sort-Object SizeMB -Descending
    
    if ($largeFolders.Count -eq 0) {
        Write-Host "No massive folders found here." -ForegroundColor Gray
        continue
    }
    
    foreach ($lf in $largeFolders) {
        Write-Host ""
        Write-Host ("Found App: {0}" -f $lf.Name) -ForegroundColor Cyan
        Write-Host ("Size: {0:N2} MB" -f $lf.SizeMB) -ForegroundColor Yellow
        Write-Host "WARNING: Deleting this removes ALL settings, saves, and data for this app." -ForegroundColor Red
        
        $resp = Read-Host "Wipe this app's data entirely? (Y/N/Skip)"
        if ($resp -match '^[Yy]') {
            # Try to kill process if it matches the folder name roughly
            Stop-Process -Name $lf.Name -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 1
            
            Write-Host "Nuking $($lf.Name)..." -ForegroundColor DarkGray
            Remove-Item "$($lf.FullName)\*" -Recurse -Force -ErrorAction SilentlyContinue
            
            # Double check if completely gone
            if (Test-Path $lf.FullName) {
                $rem = (Get-FolderSize $lf.FullName) / 1MB
                if ($rem -lt 10) {
                    Write-Host "✅ Mostly cleared! (Some tiny files were locked)" -ForegroundColor Green
                } else {
                    Write-Host "⚠️ Partially cleared. ($("{0:N2}" -f $rem) MB remaining - files in use)" -ForegroundColor Yellow
                }
            } else {
                Write-Host "✅ Completely wiped!" -ForegroundColor Green
            }
        } else {
            Write-Host "⏭️ Skipped." -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "Debloat Complete!" -ForegroundColor Green
$drive = Get-PSDrive C
Write-Host ("C: Drive Free Space Now: {0:N2} GB" -f ($drive.Free / 1GB)) -ForegroundColor Cyan
