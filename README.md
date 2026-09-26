# Interactive PowerShell Cleanup Scripts 🧹

Welcome to the **Interactive PowerShell Cleanup utility**! This repository provides powerful, completely transparent scripts to reclaim gigabytes of storage space on your Windows system without blindly deleting things you might need.

## The Problem: Why does your storage get full?
Over time, your PC secretly hoards gigabytes of data:
1. **Windows Updates** download gigabytes of files, install them, and then *forget to delete the installers*.
2. **Browsers** cache every image and script from websites you visit, easily bloating to 2+ GB.
3. **Games & Apps (like Roblox or VS Code)** download new versions but hoard the old, outdated versions.
4. **Uninstalling games** via Windows Settings often leaves their massive `AppData` folders behind permanently.

## The Solution: The "Hella Storage" 3-Step Method
Most cleanup tools delete files silently and break your apps. Our "Interactive Scheme" works differently:
1. **It Scans:** It surgically measures the exact size of the junk.
2. **It Reports:** It tells you exactly what is taking space (e.g., "Discord Cache: 800 MB").
3. **It Asks:** It prompts you in the console (`Y/N`), giving you full control over what is deleted.

---

### Step 1: `Interactive-C-Cleanup.ps1` (The Safe Cache Wipe)
Targets your main system drive (`C:`). It safely hunts down caches without touching your passwords, settings, or bookmarks.
*   **Windows Update Download Cache:** Automatically stops the `wuauserv` service to unlock the massive hidden update files, deletes them, and restarts the service.
*   **Browser Caches:** Closes Chrome, Edge, and Brave to unlock their cache databases, deleting the bloat while preserving your profiles.
*   **Roblox Old Versions:** Roblox is notorious for keeping old versions. This script finds them, keeps the newest one, and deletes the rest (often freeing 1GB+).
*   **App Caches:** Surgically removes cached data for heavy apps like VS Code and Discord.

### Step 2: `Interactive-App-Debloater.ps1` (The Deep Debloat)
Did you uninstall a game (like Fortnite or Minecraft) but you're still missing 5 GB of space? The data is likely hiding in `AppData`.
*   Scans your `AppData\Local` and `AppData\Roaming` folders.
*   Finds any folder larger than **100 MB**.
*   Prompts you: *"Found App X using Y MB. Wipe this app's data entirely? (Y/N)"*
*   **Warning:** Unlike the Cache cleanup, this script deletes the entire folder (including settings and local saves). Only say `Y` to apps and games you *know* you no longer use!

### Step 3: `Interactive-D-Cleanup.ps1` (The Secondary Drive Sweep)
A specialized script for your secondary drive (`D:`).
*   **Recycle Bin:** Hidden recycle bin files on the D: drive.
*   **Game Libraries:** Scans for stuck/incomplete Steam downloads.
*   **Large Folders Report:** Scans the root of the drive and shows you a table of the Top 10 largest folders so you know exactly where your space went.

---

## How to use

1. **Open PowerShell as Administrator** (Right-click Start menu -> Windows PowerShell (Admin)). *Admin privileges are needed to stop the Windows Update service.*
2. Navigate to where you downloaded these scripts:
   ```powershell
   cd C:\Path\To\PowerShell-cleanup-script
   ```
3. Run the script you need:
   ```powershell
   .\Interactive-C-Cleanup.ps1
   # OR
   .\Interactive-App-Debloater.ps1
   # OR
   .\Interactive-D-Cleanup.ps1
   ```
   *(Note: If you get an Execution Policy error, run `Set-ExecutionPolicy Bypass -Scope Process` first).*
4. The script will scan, show you a folder and its size, and wait for your input. Type `Y` and hit Enter to delete, or `N` to skip.
