# Lab 1 - Your first virtual machine

Pair: Maratov / None  Driver first half: Maratov
Machine: MacBook Pro, guest Ubuntu Server 26.04.1 LTS
Date: 25.10.2026

## What I did
1. Installed Oracle VirtualBox.
2. Created VM lab01-ubuntu: 1 vCPU, 2048 MB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server 26.04.1 LTS, took snapshot clean-install.
4. Broke it: removed the hostname file using sudo rm /etc/hostname.
5. Rolled back to clean-install: restored the snapshot in VirtualBox to recover the system.

## Resource justification
Allocating 2048 MB of RAM, 1 CPU core, and 25 GB of disk space is an optimal configuration for the stable operation of the virtual machine while leaving sufficient resource overhead for the host system.

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
When starting the virtual machine, a video controller configuration error occurred, along with issues connecting via SSH. The issues were resolved by discarding the saved state and executing commands directly through the VM console.

## Evidence
- [vm-settings.png](vm-settings.png) - CPU, memory, disk as configured
- [guest-release.txt](guest-release.txt) - output of lsb_release -a inside the guest
- [broken.png](broken.png) - the guest in its broken state
- [snapshot-list.png](snapshot-list.png) - the snapshot, after the rollback
