# PowerShell Cleanup Scripts

A collection of PowerShell scripts for cleaning unnecessary files, caches, logs, temporary data, and detecting duplicate files on Windows drives.

The repository contains separate cleanup scripts for the **C: drive** and **D: drive**, with different levels of cleanup and duplicate-file handling.

---

## Scripts

### C Drive Cleanup Script

The C Drive script is designed for cleaning common unnecessary files from the Windows system drive.

It performs several cleanup operations, including:

* Temporary file cleanup
* Windows temporary files
* Browser cache cleanup
* Browser code-cache cleanup
* NVIDIA shader-cache cleanup
* DirectX shader-cache cleanup
* Microsoft Store cache cleanup
* `.tmp` files in relevant system locations
* Windows component cleanup using DISM
* Duplicate-file detection
* Large-file reporting
* Free-space reporting

### Duplicate Detection

The script searches the C: drive for potential duplicate files.

To reduce unnecessary hashing, files are first grouped by:

1. File size
2. SHA-256 hash

Files with the same size and SHA-256 hash are considered exact duplicates.

The script reports duplicate groups and identifies copies that can potentially be removed.

Duplicate deletion requires explicit confirmation before files are removed.

### C Drive Exclusions

Certain Windows and system locations are excluded from the duplicate scan to reduce the risk of interfering with important system files.

These include:

* `C:\Windows`
* `C:\Program Files`
* `C:\Program Files (x86)`
* `C:\ProgramData\Microsoft`
* `C:\$Recycle.Bin`
* `C:\System Volume Information`

### Final Report

After the cleanup process, the script reports information such as:

* Free space before cleanup
* Free space after cleanup
* Space recovered
* Duplicate files detected
* Largest accessible files
* Total execution time

---

## D Drive Cleanup Script

The D Drive script is designed for cleaning unnecessary files from a data drive while being more conservative about file deletion.

It focuses on:

* Temporary files
* Cache files
* Log files
* Duplicate-file detection
* Recycle Bin cleanup
* Storage reporting

### Temporary, Cache, and Log Files

The script searches the D: drive for files commonly associated with temporary or unnecessary data, including:

* `.tmp`
* `.temp`
* `.cache`
* `.log`

These files are identified during the cleanup process.

### Duplicate Detection

The script recursively scans the D: drive for potential duplicate files.

Files are first grouped by size and then compared using SHA-256 hashing.

This allows the script to identify files that are exact duplicates rather than simply having similar names.

Duplicate files are **reported but are not automatically deleted**.

This allows the user to review the detected duplicates before deciding what should be removed.

### D Drive Exclusions

System-managed locations are excluded from the scan, including:

* `D:\System Volume Information`
* `D:\$RECYCLE.BIN`

### Final Report

The script provides information about:

* Detected duplicate groups
* Number of duplicate copies
* Potential storage space occupied by duplicates
* Cleanup results

---

## C Drive vs D Drive

| Feature                      | C Drive Script    | D Drive Script |
| ---------------------------- | ----------------- | -------------- |
| Temporary files              | Yes               | Yes            |
| Cache files                  | Yes               | Yes            |
| Log files                    | Yes               | Yes            |
| Browser caches               | Yes               | No             |
| NVIDIA shader caches         | Yes               | No             |
| DirectX shader cache         | Yes               | No             |
| Microsoft Store cache        | Yes               | No             |
| Windows component cleanup    | Yes               | No             |
| Duplicate detection          | Yes               | Yes            |
| SHA-256 verification         | Yes               | Yes            |
| Automatic duplicate deletion | With confirmation | No             |
| Large-file reporting         | Yes               | No             |
| Recycle Bin cleanup          | Yes               | Yes            |
| Free-space reporting         | Yes               | Yes            |

---

## Requirements

* Windows
* PowerShell
* Appropriate permissions for locations being cleaned

The scripts are intended to be run locally on Windows.

---

## Running the Scripts

### C Drive

Open PowerShell and run the C Drive script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\C_Drive_Cleanup.ps1
```

### D Drive

Open PowerShell and run the D Drive script:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\D_Drive_Cleanup.ps1
```

If PowerShell reports that script execution is disabled, the `Set-ExecutionPolicy` command above enables script execution only for the current PowerShell session.

---

## Duplicate File Detection

Duplicate detection works by comparing files using their contents rather than relying only on filenames.

The general process is:

```text
Find files
    ↓
Group files by size
    ↓
Identify files with matching sizes
    ↓
Calculate SHA-256 hashes
    ↓
Compare hashes
    ↓
Identify exact duplicates
```

This helps distinguish genuine duplicates from files that merely have the same filename.

---

## Safety

The scripts are designed to avoid blindly deleting arbitrary files.

System locations are excluded from duplicate scanning where appropriate, and duplicate deletion on the C: drive requires explicit confirmation.

The D: drive script does not automatically delete detected duplicate files.

As with any cleanup utility, important files should be reviewed before deletion.

---

## Performance

Cleanup operations involving temporary files and known cache locations are generally faster than full-drive duplicate detection.

Duplicate detection can take considerably longer because the scripts may need to:

* Recursively enumerate large numbers of files
* Compare file sizes
* Calculate SHA-256 hashes
* Access files across the drive

The amount of data and number of files on a drive can therefore significantly affect execution time.

---

## What These Scripts Do Not Do

These scripts are not intended to:

* Uninstall applications
* Remove personal documents automatically
* Modify application installations
* Defragment drives
* Repair corrupted files
* Replace Windows system maintenance tools

Their primary purpose is **cleanup, duplicate detection, and storage analysis**.

---

## License

This project is provided as-is for use and modification according to the repository's chosen license.
