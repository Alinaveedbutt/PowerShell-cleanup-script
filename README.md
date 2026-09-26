# Interactive PowerShell Storage Cleaner 🧹

A safe, transparent, and interactive suite of PowerShell scripts designed to help you reclaim gigabytes of storage space on your Windows system. 

Unlike automated PC cleaning tools that silently delete files in the background (which can sometimes break applications or log you out of accounts), these scripts put **you** in complete control. They scan your drives, calculate exactly how much space is being wasted, and prompt you `(Y/N)` before deleting anything.

---

## 🛠️ The Scripts

### 1. `Interactive-C-Cleanup.ps1` (Safe Cache & Temp Cleaner)
Run this script to safely clear out bloated cache files on your main `C:` drive without losing any important settings, passwords, or configurations.
* **Windows Update Downloads:** Windows often leaves gigabytes of old update installers behind. This script actively stops the Windows Update service, clears the hidden files, and restarts it.
* **Browser Caches:** Safely wipes caches for Chrome, Edge, and Brave while preserving your profiles and bookmarks. (It will temporarily close the browsers to unlock the files).
* **Application Caches:** Surgically removes bloated cache folders for heavy apps (like VS Code, Discord, and Python's `pip`) and cleans up old software versions that accumulate over time.
* **System Temp Files:** Clears standard Windows and User Temp directories.

### 2. `Interactive-App-Debloater.ps1` (Deep AppData Sweeper)
When you uninstall a large application or game via Windows, it frequently leaves massive hidden folders behind in your `AppData` directory. 
* Scans both `AppData\Local` and `AppData\Roaming`.
* Flags any folder larger than **100 MB**.
* Prompts you with the app's name and size.
* **Warning:** If you type `Y`, it will delete the *entire* folder, including local saves and settings. Only use this for software you have uninstalled or no longer use!

### 3. `Interactive-D-Cleanup.ps1` (Secondary Drive Scanner)
A specialized script for keeping your secondary drives clean.
* Clears hidden Recycle Bin files.
* Sweeps custom temporary directories.
* Cleans incomplete or stuck game downloads (e.g., Steam cache).
* Generates a "Top 10 Largest Folders" report so you can manually investigate what is consuming your secondary drive space.

---

## 🚀 How to Use

1. **Open PowerShell as Administrator**
   * Right-click your Windows Start menu and select **Windows PowerShell (Admin)** or **Terminal (Admin)**.
   * *Admin privileges are required because clearing system caches (like Windows Update) requires stopping background services.*

2. **Navigate to the script folder**
   ```powershell
   cd C:\Path\To\PowerShell-cleanup-script
   ```

3. **Allow script execution (if needed)**
   If you have never run PowerShell scripts on your PC before, you may need to temporarily bypass the execution policy:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process
   ```

4. **Run a script**
   ```powershell
   .\Interactive-C-Cleanup.ps1
   ```
   *(Or run any of the other scripts included).*

5. **Follow the prompts**
   The script will pause whenever it finds a large cache or folder. Type `Y` and press `Enter` to delete it, or type `N` to skip it.

---

## 🔒 Safety First
This utility is designed with safety in mind. By relying on explicit cache targeting and manual `Y/N` confirmation, it avoids the pitfalls of "registry cleaners" and "auto-optimizers." You will never lose a file without explicitly approving it first.
