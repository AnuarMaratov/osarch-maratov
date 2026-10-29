# Test Environment Build Guide

Guide written for Aigerim to build, configure, and restore the isolated testing environment for new developers.

## Step 1. Installing the hypervisor
Download and install VirtualBox from virtualbox.org.
![](screenshots/step1.png)
Why VirtualBox: It is an open-source Type-2 hypervisor that is free and legal for corporate office use without requiring a paid commercial license.
> Check: You can see the VirtualBox Manager shortcut on your desktop and it launches without errors.

## Step 2. Downloading the OS ISO images
Download the Ubuntu Server 24.04 LTS ISO from ubuntu.com and the Windows 11 Enterprise Evaluation ISO from the Microsoft Evaluation Center.
![](screenshots/step2.png)
Why Evaluation and LTS: Ubuntu LTS provides long-term stability at zero cost. Windows 11 Enterprise Evaluation is completely free, legal for testing, and works out of the box for 90 days without purchasing a commercial license key.
> Check: You should have two `.iso` files in your Downloads folder, each sized several gigabytes.

## Step 3. Creating the Windows 11 VM
In VirtualBox, click "New", name it "Win11_Test", allocate 4096 MB RAM, 2 CPUs, a 50 GB dynamically allocated disk, and check "Enable EFI".
![](evidence/01-new-vm-wizard.png)
Why these settings: Windows 11 requires a minimum of 4 GB RAM, 2 CPUs, and EFI firmware with TPM 2.0 to boot. A dynamically allocated disk saves your host computer's storage by only growing as files are created inside the VM.
> Check: The "Win11_Test" machine appears in the left panel of VirtualBox.

## Step 4. Creating the Ubuntu Server VM
Click "New", name it "Ubuntu_Test", allocate 2048 MB RAM, 1 CPU, and a 20 GB dynamically allocated disk.
![](evidence/02-disk-settings.png)
Why these settings: Ubuntu Server has no graphical interface (CLI only), so 2 GB of RAM is more than enough for developer testing while preserving your laptop's host memory.
> Check: The "Ubuntu_Test" machine appears in the left panel beneath Windows.

## Step 5. Installing the operating systems
Start each VM, select the corresponding ISO file when prompted, and complete the installation wizard using standard default settings.
![](screenshots/step5.png)
Why default options: Keeping the default package selection and partitioning avoids misconfigurations and ensures a clean, isolated development environment.
> Check: Windows boots to the desktop, and Ubuntu reboots to a black terminal screen asking for a "login:".

## Step 6. Configuring the network adapter
In the VM settings for both machines, under Network Adapter, choose **NAT Network** (or NAT).
![](evidence/03-network-adapter.png)
Why NAT and not Bridged: The Innotech teaching network filters by MAC address, and a bridged adapter gives the guest its own MAC, which the network will not accept. Behind NAT the guest goes out using the host's address and the problem disappears. NAT Network also places both VMs on the same local subnet so they can communicate with each other.
> Check: Run `ip addr` inside Ubuntu and `ipconfig` inside Windows. Both receive local IP addresses (e.g., 10.0.2.x).

## Step 7. Verifying Windows network connectivity
Open Command Prompt in Windows and run `ping google.com` as well as `ping <Ubuntu-IP>`.
![](evidence/04-windows-ping.png)
Why ping: Ping sends ICMP echo packets to prove that external internet routing and internal guest-to-guest network paths are working correctly.
> Check: You see replies with round-trip times in milliseconds and 0% packet loss.

## Step 8. Verifying Ubuntu network connectivity
Log into Ubuntu Server and run `ping -c 4 google.com` and `ping -c 4 <Windows-IP>`.
![](evidence/05-ubuntu-ping.png)
Why ping: This proves bidirectional communication, confirming the Linux guest can download external packages and reach the Windows test host.
> Check: The terminal shows "4 packets transmitted, 4 received, 0% packet loss".

## Step 9. Taking a clean baseline snapshot
Shut down both VMs, navigate to the Snapshots tab for each VM in VirtualBox, and click "Take" with the name "Clean Install".
![](evidence/06-snapshot-list.png)
Why snapshots: The developer requested an environment to "try things without breaking anything." A snapshot freezes the VM state so you can instantly restore it whenever the developer breaks the system.
> Check: The "Clean Install" snapshot appears in the snapshot list, and the "Restore" button is active.

## Step 10. Troubleshooting frozen VMs
If a VM freezes, turns completely black, or makes your laptop unresponsive, right-click the VM in VirtualBox Manager, choose "Close", and select "Power off the machine".
![](screenshots/step10.png)
Why this solution: Do not press your laptop's physical power button. Forcing the VM to power off terminates only the frozen hypervisor process and immediately frees up your laptop's physical RAM and CPU.
> Check: Your laptop immediately becomes responsive again, and you can restart the VM or restore the "Clean Install" snapshot.
