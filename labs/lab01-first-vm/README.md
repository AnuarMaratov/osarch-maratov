# Lab 1 - Your first virtual machine

Pair: Maratov / None  Driver first half: Maratov
Machine: MacBook Pro, guest Ubuntu Server 26.04 LTS
Date: 25.10.2026

## What I did
1. Installed Oracle VirtualBox.
2. Created VM lab01-ubuntu: 1 vCPU, 2048 MB RAM, 25 GB dynamic disk, NAT[cite: 9].
3. Installed Ubuntu Server 26.04 LTS, took snapshot clean-install[cite: 7, 8].
4. Broke it: removed the hostname file using sudo rm /etc/hostname[cite: 8].
5. Rolled back to clean-install: restored the snapshot in VirtualBox to recover the system[cite: 7].

## Resource justification
Выделение 2048 МБ оперативной памяти, 1 ядра процессора и 25 ГБ дискового пространства является оптимальной конфигурацией для стабильной работы виртуальной машины[cite: 9], оставляя достаточный запас ресурсов для хоста.

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below[cite: 7, 8].

## What did not work the first time
При запуске виртуальной машины возникла ошибка конфигурации видеоконтроллера (`VERR_SSM_DATA_UNIT_FORMAT_CHANGED`), а также проблемы с подключением через SSH[cite: 3, 7]. Проблемы были решены сбросом сохраненного состояния (Discard Saved State) и выполнением команд через консоль ВМ[cite: 3, 8].

## Evidence
- [evidence/vm-settings.png](evidence/vm-settings.png) - CPU, memory, disk as configured[cite: 9]
- [evidence/guest-release.txt](evidence/guest-release.txt) - output of lsb_release -a inside the guest[cite: 6]
- [evidence/broken.png](evidence/broken.png) - the guest in its broken state[cite: 8]
- [evidence/snapshot-list.png](evidence/snapshot-list.png) - the snapshot, after the rollback[cite: 7]
