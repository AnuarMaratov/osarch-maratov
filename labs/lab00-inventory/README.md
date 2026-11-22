# Lab 00 - Inventory your own machine

Machine: MacBook Air (Mac17,3), Apple M5, macOS. All data collected from the command line only.

| What | Value | Where I got it |
| :--- | :--- | :--- |
| **CPU model** | Apple M5 | `sysctl -a \| grep machdep.cpu` (`machdep.cpu.brand_string`) |
| **Core count** | 10 (4 performance + 6 efficiency) | `sysctl hw.physicalcpu hw.perflevel0.physicalcpu hw.perflevel1.physicalcpu` |
| **Thread count** | 10 (one thread per core, no Hyper-Threading) | `sysctl hw.logicalcpu`, `sysctl -a \| grep machdep.cpu` (`thread_count`) |
| **Total memory** | 16 GB (17179869184 bytes) | `sysctl hw.memsize`, `system_profiler SPMemoryDataType` |
| **Memory modules and speed** | No separate modules: unified LPDDR5 memory on the chip package (Micron). Speed is not reported by macOS. | `system_profiler SPMemoryDataType` |
| **Disk model** | APPLE SSD AP0512Z, 500.3 GB, internal | `diskutil info disk0`, `system_profiler SPNVMeDataType` |
| **Disk type** | SSD, listed as NVMe, protocol Apple Fabric, SMART verified | `diskutil info disk0`, `system_profiler SPNVMeDataType` |
| **Free space (VM volume)** | 349 GiB available of 460 GiB on the Data volume | `df -h /System/Volumes/Data` |
| **Firmware type** | Not BIOS or UEFI: Apple Silicon boots with Apple's own firmware (iBoot) | `system_profiler SPHardwareDataType` |
| **Firmware version and date** | System Firmware Version 18000.161.9, OS Loader 18000.161.9. No build date is reported. | `system_profiler SPHardwareDataType` |
| **Hardware virtualization** | Present and enabled (`kern.hv_support: 1`) | `sysctl kern.hv_support` |

Raw outputs are in `evidence/`: `cpu.txt`, `memory.txt`, `disk.txt`, `firmware-virtualization.txt`.

## Required Sections

### What did not work
- `sysctl -a | grep machdep.cpu` on Apple Silicon returns only a handful of lines (no core/thread breakdown by type, no feature flags like on Intel), so I added `sysctl hw.physicalcpu hw.perflevel0.physicalcpu hw.perflevel1.physicalcpu` to get the 4+6 split.
- `system_profiler SPMemoryDataType` shows only size, type and manufacturer. There is no module count or speed because the memory is part of the chip package.
- There is no BIOS/UEFI version or date to read. `system_profiler SPHardwareDataType` gives only the System Firmware Version.
- `df -h /` shows the small read-only system volume, so I used `df -h /System/Volumes/Data` for the real free space.

### Additional Notes
- Virtualization is already enabled, nothing needed fixing. On Apple Silicon, VMs run as ARM guests (VMware Fusion is already installed).
- `system_profiler SPHardwareDataType` also prints the serial number and UUID: remove them from `firmware-virtualization.txt` before publishing the repository.
