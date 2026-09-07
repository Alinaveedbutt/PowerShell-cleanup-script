# PowerShell Cleanup Scripts

A collection of Windows PowerShell scripts for cleaning unnecessary files, recovering disk space, detecting exact duplicate files, and identifying large files that may be consuming storage.

The scripts are designed to clean **common temporary and cache locations** while avoiding Windows system directories and installed applications wherever possible.

> **Important:** These scripts can permanently delete files. Always read the script and review the paths it targets before running it on your system.

---

## Features

### C: Drive Cleanup

The C: Drive script performs a deeper cleanup intended for the Windows system drive.

It can clean:

* User temporary files
* Local temporary files
* Windows temporary files
* Windows Error Reporting files
* Old crash dumps
* Windows Update download cache
* Delivery Optimization cache
* Thumbnail and icon caches
* Recycle Bin
* Browser caches
* NVIDIA shader caches
* DirectX shader cache
* Microsoft Store cache
* Temporary installation files
* Windows component-store leftovers using DISM

It also provides:

* Exact duplicate-file detection
* SHA-256 based duplicate verification
* Duplicate-file deletion with explicit confirmation
* Large-file reporting
* Before/after free-space measurements
* Total recovered-space reporting
* Total execution-time reporting

The duplicate scanner first groups files by size and then uses SHA-256 hashing to verify that files are actually identical before considering them duplicates.

### D: Drive Cleanup

The D: Drive script is intentionally more conservative because D: drives commonly contain personal files, games, projects, documents, and other important data.

It focuses on:

* Temporary files
* Cache files
* Log files
* Recycle Bin contents
* Exact duplicate detection
* Duplicate-size reporting

The D: script **does not automatically delete detected duplicate files**. It displays the duplicate paths and the potential amount of recoverable space so that you can review them manually first.

---

## Repository Structure

```text
PowerShell-cleanup-script/
│
├── C_Drive CleanUp Script
│   └── Deep cleanup for the Windows C: drive
│
├── D_Drive CleanUp Script
│   └── Conservative cleanup and duplicate detection for D:
│
└── README.md
```

---

# Requirements

* Windows 10 or Windows 11
* Windows PowerShell 5.1 or PowerShell 7+
* Administrator privileges
* Sufficient free space for temporary operations

No third-party software or PowerShell modules are required by the scripts.

---

# Getting Started

## 1. Clone the repository

```powershell
git clone https://github.com/Alinaveedbutt/PowerShell-cleanup-script.git
```

Then enter the repository:

```powershell
cd PowerShell-cleanup-script
```

You can also download the repository as a ZIP from GitHub if you do not have Git installed.

---

# Running the C: Drive Cleanup

Open **PowerShell as Administrator**.

Because Windows PowerShell may restrict locally downloaded scripts, you can temporarily allow script execution for the current PowerShell session:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Then run the script:

```powershell
& ".\C_Drive CleanUp Script"
```

If the script has been renamed with a `.ps1` extension:

```powershell
& ".\C_Drive CleanUp Script.ps1"
```

### What happens?

The script processes the cleanup stages sequentially.

You will see messages similar to:

```text
[CLEAN] Temporary files
[CLEAN] Windows Update cache
[CLEAN] Browser caches
[CLEAN] NVIDIA shader cache
[CLEAN] Windows component store
```

The script then performs its duplicate scan.

Depending on how much data exists on the C: drive, **duplicate scanning can take considerably longer than the normal cleanup operations** because files must first be discovered and then hashed for exact comparison.

---

# Duplicate Detection

The duplicate scanner does **not** assume that two files with the same name are duplicates.

Instead, it uses:

```text
File size → SHA-256 hash → Exact duplicate
```

Two files are considered duplicates only when their contents produce the same SHA-256 hash.

The C: script also excludes important system locations such as:

```text
C:\Windows
C:\Program Files
C:\Program Files (x86)
C:\ProgramData\Microsoft
C:\$Recycle.Bin
C:\System Volume Information
```

This significantly reduces the risk of treating system/application files as ordinary user duplicates.

---

# Duplicate Deletion

The C: script does **not silently delete detected duplicates**.

After displaying the duplicate groups, it asks for explicit confirmation:

```text
Delete these duplicate copies? Type YES to continue
```

Only entering:

```text
YES
```

continues with duplicate deletion.

Anything else cancels the deletion step.

The script keeps one copy and proposes the remaining byte-for-byte identical copies for deletion.

> **Always review the displayed paths before confirming deletion.**

A duplicate file can be identical in content but still be located somewhere important to a particular application or workflow.

---

# Running the D: Drive Cleanup

The D: drive script is intended for drives containing personal data.

Run PowerShell as Administrator and temporarily allow the script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Then run:

```powershell
& ".\D_Drive CleanUp Script"
```

Or, if the file has a `.ps1` extension:

```powershell
& ".\D_Drive CleanUp Script.ps1"
```

The script scans the drive for temporary/cache/log files and exact duplicates.

Unlike the C: script, **detected duplicate files are not automatically deleted**. The script reports the duplicate groups and potential recoverable space so they can be reviewed manually.

---

# Safety Considerations

These scripts are designed to be conservative, but **no automated cleanup script can guarantee that every deletion is appropriate for every computer**.

Before running:

### 1. Back up important files

Keep backups of important:

* Documents
* Photos
* Videos
* Projects
* School/university work
* Game saves
* Development environments
* Other irreplaceable data

### 2. Close applications

For the best results, close applications that may be using cache or temporary files, particularly:

* Web browsers
* Microsoft Store
* Game launchers
* Development tools
* File-management applications

Files currently being used by Windows or another application may simply be skipped.

### 3. Review duplicate files

Exact duplicates are identified by their contents, but deleting one copy can still affect how your files are organized.

Do not blindly approve duplicate deletion if you are unsure why multiple copies exist.

### 4. Recycle Bin cleanup is permanent

When the Recycle Bin is emptied, those files are no longer available through normal Windows recovery.

---

# Performance

The cleanup portion is generally much faster than the duplicate-analysis portion.

Duplicate detection can be expensive because the script has to:

1. Enumerate files.
2. Group files with identical sizes.
3. Calculate SHA-256 hashes for potential matches.
4. Compare the resulting hashes.
5. Display duplicate groups.

Files with different sizes cannot be byte-for-byte identical, so size grouping is used as an optimization before hashing.

For this reason, **do not assume that an apparently idle PowerShell window is frozen while duplicate scanning is running**.

Large drives containing many files can take significantly longer to scan.

---

# What This Project Does NOT Do

These scripts are not intended to:

* Uninstall applications
* Delete installed programs
* Modify personal documents
* Modify the Windows Registry
* Disable Windows security features
* Disable Windows Update
* Remove Windows system directories
* Defragment SSDs
* Automatically determine whether a personal file is "important"
* Recover corrupted files

The goal is storage cleanup, not system modification.

---

# Recommended Usage

For a Windows system drive:

```text
C: Drive
   ↓
Run C: Cleanup
   ↓
Review duplicate report
   ↓
Confirm duplicate deletion only if appropriate
   ↓
Review largest files
   ↓
Check recovered storage
```

For a personal/data drive:

```text
D: Drive
   ↓
Run D: Cleanup
   ↓
Review temporary/cache/log cleanup
   ↓
Review duplicate groups
   ↓
Manually decide what duplicates to remove
```

---

# Understanding the Output

At the end of the C: Drive cleanup, the script reports:

```text
Free space BEFORE
Free space AFTER

SPACE RECOVERED

Total runtime
```

This gives you an actual before/after measurement rather than simply estimating how much data was deleted.

The script also generates a report of the largest accessible files on C:, which can help identify what is actually consuming storage.

---

# Troubleshooting

## "Running scripts is disabled on this system"

Run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

This changes the execution policy only for the current PowerShell session.

---

## "The term ... is not recognized"

Make sure you are using the correct path.

For example:

```powershell
& "C:\Path\To\Script.ps1"
```

If the script is on your Desktop:

```powershell
& "$env:USERPROFILE\OneDrive\Desktop\Script.ps1"
```

Your Desktop may be located inside OneDrive depending on your Windows configuration.

---

## The script appears to be doing nothing

Some operations can take time without producing continuous output.

The most time-consuming stage is normally duplicate detection because of recursive file enumeration and SHA-256 hashing.

Check whether PowerShell is still using CPU/disk resources before terminating the process.

---

## Some files cannot be deleted

This is expected.

Files may be:

* Currently in use
* Protected by Windows
* Owned by another process
* Locked by an application
* Inaccessible due to permissions

The scripts generally suppress errors for inaccessible files and continue with the remaining cleanup.

---

# Contributing

Contributions, improvements, bug reports, and safety suggestions are welcome.

Before submitting a change:

1. Test the script on a non-critical environment.
2. Make sure system directories are not unintentionally targeted.
3. Avoid destructive behavior without explicit confirmation.
4. Document any new cleanup location.
5. Explain why the location is safe to clean.

For PowerShell scripts, maintaining readable and consistent scripting practices is especially important because these tools directly interact with the filesystem.

---

# Disclaimer

**Use these scripts at your own risk.**

The author is not responsible for:

* Data loss
* Deleted files
* Application problems
* Windows configuration issues
* Corrupted files
* Loss of access to personal data
* Any other damage resulting from using or modifying these scripts

Always maintain a backup of important data before performing automated cleanup.

---

# License

This repository does not currently specify a license.

If you intend for other people to freely use, modify, and redistribute the scripts, consider adding an open-source license such as the MIT License.

---

# Author

**Ali Naveed Butt**

GitHub:
https://github.com/Alinaveedbutt

Repository:
https://github.com/Alinaveedbutt/PowerShell-cleanup-script

---

## Project Status

**Active Development**

The scripts are intended to evolve as additional cleanup targets, safety checks, performance improvements, and reporting features are added.

If you find a problem or have a suggestion, open an issue in the repository.
