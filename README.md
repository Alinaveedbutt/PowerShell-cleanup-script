# Interactive PowerShell Cleanup Scripts 🧹

Welcome to the **Interactive PowerShell Cleanup utility**! This repository provides powerful, completely transparent scripts to reclaim gigabytes of storage space on your Windows system without blindly deleting things you might need.

## Why this approach?
Many cleanup scripts run automatically and delete files silently, which can sometimes break applications or remove configurations you wanted to keep. 

These scripts use an **Interactive Scheme**: 
1. **Scan:** They find exactly where space is being wasted (Windows Update cache, old browser data, temp files, app caches).
2. **Report:** They calculate the exact size of the junk.
3. **Ask:** They prompt you in the console (`Y/N`) so you are in full control of every single megabyte deleted.

## Scripts Included

### 1. `Interactive-C-Cleanup.ps1` (Cache & Temp)
Targets your main system drive (`C:`). It safely hunts down:
*   **Windows Update Download Cache:** Often eats gigabytes of space for updates you've already installed.
*   **Browser Caches:** Cleans Chrome, Edge, and Brave caches while leaving your bookmarks, logins, and settings completely untouched.
*   **Temp Folders:** Clears out `%TEMP%` and `C:\Windows\Temp`.
*   **App Caches:** Surgically removes cached data for heavy apps like VS Code, Discord, and Python (`pip`), without touching your profiles.

### 2. `Interactive-D-Cleanup.ps1` (Secondary Drive)
A specialized script for your secondary drive (`D:`). It scans for:
*   **Recycle Bin:** Hidden recycle bin files on the D: drive.
*   **Temp Folders:** Custom temp folders you might have set up.
*   **Game Libraries:** Scans for stuck/incomplete Steam downloads.
*   **Large Folders Report:** Scans the root of the drive and shows you the Top 10 largest folders so you know exactly where your space went.

### 3. `Interactive-App-Debloater.ps1` (Massive App Wipes)
If you uninstalled a game but it left 5GB of data behind, this script finds it.
*   Scans your `AppData\Local` and `AppData\Roaming` folders.
*   Finds any folder larger than **100 MB**.
*   Prompts you: *"Found App X using Y MB. Wipe this app's data entirely? (Y/N)"*
*   **Warning:** Unlike the Cache cleanup, this script deletes the entire folder (including settings and local saves). Only say `Y` to apps and games you no longer use!

## How to use

1. **Open PowerShell as Administrator** (Right-click Start menu -> Windows PowerShell (Admin)). *Admin privileges are needed for some system folders.*
2. Navigate to where you downloaded these scripts:
   ```powershell
   cd C:\Path\To\PowerShell-cleanup-script
   ```
3. Run the script you need:
   ```powershell
   .\Interactive-C-Cleanup.ps1
   # OR
   .\Interactive-App-Debloater.ps1
   ```
   *(Note: If you get an Execution Policy error, run `Set-ExecutionPolicy Bypass -Scope Process` first).*
4. The script will scan, show you a folder and its size, and wait for your input. Type `Y` and hit Enter to delete, or `N` to skip.
