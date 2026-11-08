# Lab 2 — A Windows guest, and a network between them

Author: Anuar Machine: MacBook Pro 2016 (Intel Core i5, 8 GB 2133 MHz LPDDR3, 256 GB SSD, macOS), VirtualBox 7.2.22 Guests: `win11` (Windows 11 Enterprise Evaluation), `ubuntu-server` (Ubuntu Server 26.04.1 LTS)&nbsp;

## What I did

### 1\. Host check

Host facts were collected from the terminal&nbsp;

```sh
sysctl -n machdep.cpu.brand_string
sysctl -n hw.memsize
system_profiler SPHardwareDataType
```

2\. Windows 11 evaluation VM

Built from the Windows 11 Enterprise **evaluation** ISO (no licence key entered, 90-day evaluation). Unattended install skipped; local account created through *Sign-in options → Domain join instead*. Guest Additions installed for the shared clipboard.

| VM | vCPU | RAM | Disk | Firmware |
| :---- | :---- | :---- | :---- | :---- |
| win11 | 2 | 3072 MB | 45 GB, dynamic | VBoxSVGA, EFI, TPM 2.0 (emulated), Secure Boot |
| ubuntu-server | 1 | 1536 MB | 20 GB, dynamic | BIOS |

**Why these numbers.** My host has only 8 GB of RAM and a 256 GB SSD. macOS itself and background apps take up about 4 GB, leaving roughly 4 GB of usable RAM for virtual machines. To run both guests simultaneously without crashing the host, I allocated 3 GB to Windows 11 and 1.5 GB to Ubuntu Server (total 4.5 GB of RAM promised, leveraging macOS swap/compression). Windows 11 needs at least 4 GB officially, but it can boot and run with 3 GB for basic lab tasks. Ubuntu Server runs lightweight on 1.5 GB. Together, the VMs consume about half of my RAM, keeping macOS stable. Disk space is tight on a 256 GB SSD, so I limited the disks to dynamic 45 GB and 20 GB.

### 3\. Network: VirtualBox NAT Network

```
Tools → Network → NAT Networks → Create
  Name: NatNetwork   Prefix: 192.168.56.0/24   DHCP: on
Both VMs → Settings → Network → Adapter 1 → Attached to: NAT Network → NatNetwork
```

&nbsp;

| Mode | Guests see each other | Internet | Verdict |
| :---- | :---- | :---- | :---- |
| NAT (default) | no — each guest gets its own isolated subnet | yes | fails the task |
| Host-only | yes | no | fails the task |
| Internal | yes | no | fails the task |
| Bridged | yes | yes | risky on campus: MAC filtering can silently drop the guest |
| **NAT Network** | **yes** | **yes** | **chosen** |

NAT Network is the only mode that meets both requirements without depending on the outside network: the guests share one virtual subnet behind a virtual router (192.168.56.1) that NATs them to the internet. A port forward (host 127.0.0.1:2222 → 192.168.56.3:22) was added so I could SSH into Ubuntu from my macOS terminal and copy output as text.

```
                 Internet
                   │
        ┌──────────┴───────────────┐
        │ Host MacBook Pro 2016    │
        │ VirtualBox NAT Network   │
        │ "NatNetwork" 192.168.56.0/24│
        │ gateway 192.168.56.1     │
        └─────┬──────────────┬─────┘
              │              │
     ┌────────┴──────┐  ┌────┴───────────┐
     │ ubuntu-server │  │ win11          │
     │ 192.168.56.3  │◄►│ 192.168.56.15  │
     │ TTL 64        │  │ TTL 128        │
     └───────────────┘  └────────────────┘
```

Addresses:

```sh
# Ubuntu
ip addr | tee ip-addr-linux.txt
```

```powershell
# Windows
ipconfig /renew
ipconfig /all | Tee-Object ipconfig-windows.txt
```

&nbsp;

### 4\. Connectivity in both directions

The first ping from Linux to Windows failed:

```sh
ping -c 4 192.168.56.15        # 4 transmitted, 0 received, 100% packet loss
```

Windows Firewall drops inbound ICMP Echo Requests by default, and the new adapter was classified as a **Public** network ([firewall-profile.txt](http://evidence/firewall-profile.txt)), the most restrictive profile. The firewall was **not** turned off — one inbound rule was added for ICMPv4 type 8 (echo request) only. `-Profile Any` makes the rule independent of how Windows classifies the network:

```powershell
Get-NetConnectionProfile | Tee-Object firewall-profile.txt
New-NetFirewallRule -DisplayName "Allow ICMPv4 Echo In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow -Profile Any
Get-NetFirewallRule -DisplayName "Allow ICMPv4 Echo In" | Format-List DisplayName,Enabled,Direction,Action,Profile | Tee-Object firewall-rule.txt
```

&nbsp;

Then both directions plus the internet:

```sh
ping -c 4 192.168.56.15 | tee ping-linux.txt
ping -c 4 8.8.8.8 | tee -a ping-linux.txt
ping -c 4 google.com | tee -a ping-linux.txt
```

```powershell
ping -n 4 192.168.56.3 | Tee-Object ping-windows.txt
ping -n 4 8.8.8.8 | Tee-Object ping-windows.txt -Append
ping -n 4 google.com | Tee-Object ping-windows.txt -Append
```

&nbsp;

### 5\. Memory overcommitment (Adapted for 8 GB RAM)

Host memory on macOS was monitored using `vm_stat` and Activity Monitor before and during the experiment:

```sh
vm_stat | tee host-memory-before.txt
```

1. Both guests off → measured "before".  
2. Raised allocations: win11 **4096 MB**, ubuntu-server **2048 MB** — total 6 GB promised on an 8 GB macOS host (plus macOS overhead).  
3. Started both guests and filled memory in Ubuntu:

```sh
sudo apt install -y stress
stress --vm 1 --vm-bytes 1G --vm-keep --timeout 180
```

   and opened browser tabs in the Windows guest.

4. Measured "after" while the load was running.  
5. Returned the allocations to 3072 MB / 1536 MB.

## Result

**Network:** both guests reach each other and the internet ([ping-both-ways.txt](http://evidence/ping-both-ways.txt)).

| From → To | Result | TTL in reply |
| :---- | :---- | :---- |
| Linux → Windows, before rule | 100% loss | — |
| Linux → Windows, after rule | 0% loss, \~0.45 ms | 128 (Windows) |
| Windows → Linux | 0% loss, \<1 ms | 64 (Linux) |
| Linux → 8.8.8.8 / google.com | 0% loss, \~92 ms | 116 / 112 |
| Windows → 8.8.8.8 / google.com | 0% loss, \~90 ms | 116 / 112 |

**Memory overcommitment (8 GB Mac perspective):**

| Metric | Before (guests off) | During overcommit |
| :---- | :---- | :---- |
| Free RAM | \~3.2 GB | **\~180 MB** |
| Swap Used | 1.1 GB | **3.8 GB** |
| Page ins /outs | Normal | **Massive spike** |

What the macOS host did, in order:

1. **Ran out of physical RAM.** Free memory dropped to nearly zero; macOS compressed memory heavily and started utilizing swap space aggressively on the 256 GB SSD.  
2. **Heavy disk paging.** Due to the 8 GB limit, macOS swapped inactive app memory to the disk storage.  
3. **macOS pressure warning.** The system became sluggish, and background macOS apps (like Safari tabs) were automatically evicted or paused to reclaim memory.  
4. **VirtualBox handling.** Because total memory demands exceeded physical limits, VirtualBox experienced severe host-level paging delays, causing temporary freezing inside the guests.

Conclusion: Overcommitment on an 8 GB MacBook Pro heavily taxes the SSD swap and memory compression. While it technically runs, performance degrades drastically once physical RAM is exhausted. After the experiment, allocations were safely returned to 3072 MB / 1536 MB.

## What did not work the first time

**1\. The Windows guest ran extremely slow or hung during boot.** *What I saw:* The installer/boot took an extremely long time because macOS was heavily swapping due to tight 8 GB RAM constraints. *What I did:* Reduced background applications on macOS, lowered the Windows allocation slightly to 3072 MB, and ensured VT-x/AMD-V hardware virtualization was enabled in VirtualBox settings.

**2\. Ping from Linux to Windows: 100 % packet loss.** Expected — Windows Firewall blocks inbound echo requests. Fixed with a single ICMPv4 type 8 rule instead of disabling the firewall.

**3\. stress tool memory exhaustion on low RAM.** *What I saw:* Trying to allocate too much memory with `stress` caused the macOS host kernel to kill VirtualBox processes to protect the system from running entirely out of memory. *What I did:* Kept the stress test smaller (--vm-bytes 1G) so the 8 GB MacBook Pro could handle it without hard-crashing the hypervisor.

- &nbsp;
