# Lab 2 - A Windows guest, and a network between them

**Pair:** Anuar Maratov / <partner>  
**Driver first half:** Anuar Maratov  
**Machine:** <your laptop model>, <OS>, <RAM>, <cores>; guests Ubuntu Server + Windows 11 Enterprise eval  
**Date:** <dd.mm.2026>

---

## What I did

1. **Downloaded Windows 11 Enterprise evaluation.**  
   * License: [Evaluation Center link](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise)
2. **Created Lab02-windows:**  
   * Specifications: 2 vCPU, 4 GB RAM, 64 GB thin, UEFI + Secure Boot, vTPM.
3. **Network mode:**  
   * NAT (`VMnet8`), applied to both guests.  
   * **Why:** It allows both guest machines to communicate on an isolated private subnet while sharing the host's network adapter for external Internet access.
4. **ICMP / Connectivity Troubleshooting:**  
   * Ping from Ubuntu to Windows initially timed out because Windows Firewall drops incoming ICMPv4 Echo Requests by default.  
   * Fixed with: `netsh advfirewall firewall add rule name="Allow ICMPv4" protocol=icmpv4:8,any dir=in action=allow`
5. **Overcommitment:**  
   * Set `<x>` GB + `<y>` GB on a `<z>` GB host.

---

## Network diagram
<img width="736" height="162" alt="Снимок экрана 2026-11-01 в 20 36 51" src="https://github.com/user-attachments/assets/aaa2a54a-86d3-4765-b0e2-1c75188b89a0" />

## Result

| Metric | Before | After |
| :--- | :---: | :---: |
| **Host RAM in use** | <value> | <value> |
| **Available** | <value> | <value> |
| **Committed / Swap used** | <value> | <value> |

**What I noticed:**  
<Brief observation describing memory pressure, host responsiveness, or swapping behavior during overcommitment.>

---

## What did not work the first time

* **Observation:** <What you saw, e.g., incoming ping requests from Ubuntu to Windows timed out.>  
* **Root cause:** <What it turned out to be, e.g., default Windows Defender Firewall rule blocking inbound ICMPv4 traffic.>  
* **Resolution:** <What you did, e.g., created a new inbound firewall rule in elevated PowerShell to allow ICMP echo requests.>

---

## Evidence

* [`evidence/ipconfig-windows.txt`](evidence/ipconfig-windows.txt) — Windows IP configuration  
* [`evidence/ip-addr-linux.txt`](evidence/ip-addr-linux.txt) — Ubuntu IP address  
* [`evidence/ping-both-ways.txt`](evidence/ping-both-ways.txt) — Bidirectional ping and external Internet verification  
* [`evidence/host-memory-before.png`](evidence/host-memory-before.png) — Host memory status with guests powered off  
* [`evidence/host-memory-after.png`](evidence/host-memory-after.png) — Host memory status with both guests overcommitted
