Test Environment Build Guide
Step 1. Installing the hypervisor
Download and install VirtualBox from virtualbox.org.
![Install VirtualBox](screenshots/step1.png)
Why VirtualBox: It is a Type-2 hypervisor that is free and legal for office or corporate use, unlike VMware Workstation Pro which may require a paid commercial license.
Check: You should see the VirtualBox Manager shortcut on your desktop and it opens without errors.

Step 2. Getting the ISO images
Download the Ubuntu Server 24.04 ISO from ubuntu.com and the Windows 11 Enterprise Evaluation ISO from the Microsoft Evaluation Center.
![Download ISOs](screenshots/step2.png)
Why the Evaluation version: The Windows 11 Enterprise Evaluation is completely free, legal for testing purposes, and works out of the box for 90 days without needing a purchased license key.
Check: You should have two .iso files in your Downloads folder, each sized several gigabytes.

Step 3. Creating the Windows 11 VM
In VirtualBox, click "New", name it "Win11_Test", allocate 4096 MB of RAM, 2 CPUs, a 50 GB dynamically allocated disk, and check the "Enable EFI" box (TPM 2.0 is enabled by default in new versions).
![Windows VM Settings](evidence/01-new-vm-wizard.png)
Why these settings: Windows 11 requires a minimum of 4 GB RAM, 2 CPUs, and a TPM 2.0 chip with EFI firmware to boot. A dynamically allocated disk saves your host computer's space by only using as much physical storage as the VM actually fills.
Check: The "Win11_Test" machine appears in the left panel of VirtualBox.

Step 4. Installing Windows 11
Start the VM, select the Windows 11 ISO when prompted, and follow the standard "Next" prompts until you reach the desktop.
![Windows Install](screenshots/step4.png)
Why this process: We are doing a clean installation rather than using a pre-built image to ensure the system is completely isolated and free from unnecessary pre-installed corporate software.
Check: You can see the Windows 11 desktop and open the Start menu.

Step 5. Creating the Ubuntu Server VM
Click "New", name it "Ubuntu_Test", allocate 2048 MB of RAM, 1 CPU, and a 20 GB dynamically allocated disk.
![Ubuntu VM Settings](evidence/02-disk-settings.png)
Why these settings: Ubuntu Server has no graphical interface, so it needs far fewer resources than Windows. 2 GB of RAM is more than enough for basic developer testing, saving your laptop's memory.
Check: The "Ubuntu_Test" machine is visible in VirtualBox beneath the Windows VM.

Step 6. Installing Ubuntu Server
Start the VM, select the Ubuntu ISO, choose English, and leave all default options during the setup wizard (including creating a default user).
![Ubuntu Install](screenshots/step6.png)
Why default options: The developer just needs a basic Linux environment. Customizing partitions or installing extra packages now might overcomplicate the setup and break standard configurations.
Check: The system reboots and shows a black terminal screen asking for a "login:". Run uname -a and lsb_release -a to verify.

Step 7. Networking
In the VM settings for both machines, under Network Adapter, choose NAT Network (you may need to create one in VirtualBox Tools -> Network first).
![Network Settings](evidence/03-network-adapter.png)
Why NAT Network: Standard NAT allows internet access but isolates the VMs from each other. "NAT Network" acts like a virtual router: it gives both VMs internet access AND puts them on the same local subnet so they can communicate, without exposing them to the company's main network.
Check: Run ip addr inside Linux and ipconfig inside Windows. Both should have similar IP addresses (e.g., 10.0.2.x).

Step 8. Verifying the connection
Open the command line in both operating systems and ping each other, as well as an external website like google.com.
![Ping Check](screenshots/step8.png)
Why ping: Ping sends tiny packets of data to another machine to prove that network traffic can successfully travel back and forth.
Check: You see replies with time in milliseconds, with no "Request timed out" errors.

Step 9. Taking a clean snapshot
Turn off both VMs, right-click each in VirtualBox, go to Snapshots, and click "Take". Name it "Clean Install".
![Snapshot List](evidence/06-snapshot-list.png)
Why a snapshot: The developer asked for a machine where he can "try things without breaking anything." A snapshot freezes the VM exactly as it is right now.
Check: When the developer breaks the system, click on the "Clean Install" snapshot and hit "Restore". The VM will instantly revert to this perfect working state.

Step 10. What to do if something goes wrong
Problem: The VM freezes, turns completely black, or the host laptop becomes extremely slow.
Solution: Do not press the laptop's physical power button. Right-click the frozen VM in VirtualBox, select "Close", and click "Power off the machine".
![Force Power Off](screenshots/step10.png)
Why this happens: This usually means the VM consumed all available resources on the host laptop. Hard-resetting the VM from the menu forces it to stop and frees up your laptop's RAM instantly.
