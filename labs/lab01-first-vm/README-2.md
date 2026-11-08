# Lab 1 — Your first virtual machine

Pair: Anuar Maratov — individual work, as instructed in class for this lab    Driver: Anuar Maratov (whole session) Machine: MacBook Pro 2016, macOS; guest: Ubuntu Server 26.04.1 LTS in VirtualBox Date: 25.10.2026

## What I did

1. Created VM `maratov` in VirtualBox: 2 vCPU, 2048 MB RAM, 25 GB dynamically allocated VDI, NAT network with port forwarding host 2222 → guest 22\. Unattended install switched off.  
2. Installed Ubuntu Server 26.04.1 LTS from the ISO, with OpenSSH server.  
3. Saved the guest release from the host over SSH, so the evidence is text, not a picture:

```sh
ssh -p 2222 maratov@127.0.0.1 "echo '$ lsb_release -a'; lsb_release -a" > guest-release.txt
```

Powered the guest off and took the snapshot before changing anything:

```sh
VBoxManage snapshot "maratov" take clean-install --description "fresh install, nothing changed"
```

Broke the system on purpose and confirmed it was broken after a reboot:

```sh
cat /etc/hostname
sudo rm /etc/hostname
cat /etc/hostname
sudo reboot
# after reboot
cat /etc/hostname
hostnamectl
```

4. Powered off and restored `clean-install`. Before restoring, the broken state was kept as a snapshot named `broken`.  
5. Booted again and checked:

```sh
cat /etc/hostname
hostnamectl
```

## Resource allocation

Host: MacBook Pro 2016 (13-inch, Two Thunderbolt 3 ports), macOS, Intel Core i5-6360U (2 cores / 4 threads, 2.0 GHz base, 3.1 GHz turbo), 8 GB RAM 1867 MHz LPDDR3, 256 GB NVMe SSD with 20 GB free on Macintosh HD, where the VMs are stored.

```sh
sysctl -n hw.memsize # 8589934592 bytes (8 GB)
sysctl -n hw.ncpu    # 4 cores (2 physical cores with Hyper-Threading / 4 threads)
df -h /              # Macintosh HD free space check (~20 GB)
```

Note: my first Lab 0 was measured on a different computer. I redid it on this laptop, see [Lab 0](../lab00-inventory/README.md); the numbers here match it.

I gave the guest 2 vCPU of 4 threads, 2 GB of 8 GB RAM and a 25 GB dynamically allocated disk.

- **Memory is the tightest resource.** macOS on the host already uses about 5.2 GB, which leaves less than 3 GB. 2 GB for the guest leaves the host under 1 GB of headroom, so 2 GB is the most I can give, not a default. Ubuntu Server has no graphical shell and used 19% of its 2 GB right after login, so it does not need more.  
- **CPU:** 2 vCPU leave two of four threads for the host and, in Lab 2, the second guest.  
- **Disk:** the 25 GB disk is dynamic, so it only takes the space actually written. But 25 GB is close to the 20 GB free on Macintosh HD. If the guest ever filled its disk, the host would run out of space first. That is a deliberate overcommitment I have to watch.

Consequence for Lab 2: a Windows 11 guest with 4 GB RAM and a 64 GB disk does not fit this host as it stands. Before Lab 2 I need to clean up storage and lower the Linux guest's memory.

## Result

|  | Broken | After rollback |
| :---- | :---- | :---- |
| `cat /etc/hostname` | No such file or directory | `maratov` |
| Static hostname | (unset) | `maratov` |
| Transient hostname | `maratov` | not shown, same as static |

The prompt stayed  even in the broken state: a transient hostname was set at boot, so the damage was invisible in the prompt and only `hostnamectl` showed that the static hostname was gone. After the rollback the file and the static hostname are back.

## What did not work the first time

- **Restore failed with `VBOX_E_INVALID_VM_STATE`.** I tried to restore the snapshot while the VM was still running ("Cannot delete the current state of the running machine"). A snapshot can only be restored on a powered-off machine. I powered the VM off and the restore worked.  
- **Two snapshots named `clean-install`.** I took one in the GUI and then another with VBoxManage. Two snapshots with the same name make "restore by name" ambiguous, so I deleted the duplicate by its UUID: `VBoxManage snapshot "maratov" delete <uuid>`.  
- **Installer waiting on "Please remove the installation medium, then press ENTER".** The optical drive was already empty (VirtualBox had ejected the ISO, so "Eject" was greyed out); the installer was only waiting for Enter.  
- **The root filesystem is 11.2 GB, not 25 GB.** The guided LVM install gives `/` only about half of the disk and leaves the rest free in the volume group. Disk size and free space on the volume are different numbers.

&nbsp;