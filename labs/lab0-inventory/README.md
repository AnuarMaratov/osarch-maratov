# Lab 00 - Inventory your own machine

| What | Value | Where I got it |
| :--- | :--- | :--- |
| **CPU Model** | Intel(R) Core(TM) i5-6360U CPU @ 2.00GHz | `sysctl -a \| grep machdep.cpu`[cite: 7] |
| **Core Count** | 2 | `sysctl -a \| grep machdep.cpu`[cite: 7] |
| **Thread Count** | 4 | `sysctl -a \| grep machdep.cpu`[cite: 7] |
| **Total Memory & Modules** | 8 GB total (2 x 4 GB modules), LPDDR3 1867 MHz | `system_profiler SPMemoryDataType`[cite: 6] |
| **Disk Model & Type** | APPLE SSD AP0256J (NVMe) | `diskutil info disk0` |
| **Free Disk Space** | Свободное место из вывода `df -h /` | `df -h /` |
| **Firmware Type & Version** | UEFI / EFI (System Firmware Version: 529.120.1.0.0) | `system_profiler SPHardwareDataType` |
| **Hardware Virtualization** | Supported and Enabled (VMX / VT-x) | `sysctl kern.hv_support` |

## Required Sections

### What did not work
Initially, running `diskutil list` provided the layout and structure of the APFS volumes and disk images, but determining exact free space required inspecting the overall container size versus used volume sizes. Everything was successfully retrieved using native macOS CLI tools.

### Additional Notes
All required raw output files (`cpu.txt`, `memory.txt`, `disk.txt`) have been generated from terminal commands and placed inside the `evidence/` folder as evidence.
