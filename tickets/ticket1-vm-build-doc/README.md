# Ticket 1 - New developer starts Monday, needs a test machine

## 1. What was asked
"Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks"

## 2. What was actually needed
The request from Aigerim was very brief and lacked technical specifics. As an office manager, she cannot judge what a developer actually needs, so I had to make several engineering decisions:
*   **"Nothing special" for a developer:** Usually means they need access to standard environments. I decided to provide both a Windows 11 environment and an Ubuntu Linux server environment, covering 99% of general web/software development needs.
*   **"Without breaking anything":** A developer will inevitably break the OS while testing. To protect the host machine and allow instant recovery, VMs with a hypervisor (VirtualBox) are required, specifically utilizing "Snapshots" to roll back changes.
*   **Hypervisor and Licensing:** Aigerim needs to be able to replicate this without accidentally buying licenses. I chose VirtualBox (a free Type-2 hypervisor), Ubuntu (open-source), and Windows 11 Enterprise Evaluation (free for 90 days).
*   **Network:** The test machines need internet for downloading packages, and they need to see each other to test client-server apps, but they should not expose vulnerabilities to the main corporate network.
*   **What I would have asked:** "What exact tech stack is the new developer going to use? What are the exact hardware specifications (RAM/Disk) of the laptop Aigerim is using to build this?"
*   **What I assumed instead:** I assumed the host laptop is a standard modern corporate machine with 16 GB of RAM and a 512 GB SSD. I also assumed the developer needs standard local networking between the two OS environments.

## 3. What I did
I downloaded VirtualBox and the ISO images for Ubuntu Server 24.04 and Windows 11 Evaluation. I then created two virtual machines. 

**Resource Allocation Calculation:**
*   **Host Machine (Assumed):** 16 GB RAM, 512 GB SSD.
*   **Windows VM:** Allocated 4096 MB (4 GB) RAM and 2 CPUs. (Windows 11 minimum requirement).
*   **Ubuntu VM:** Allocated 2048 MB (2 GB) RAM and 1 CPU.
*   **Headroom:** 16 GB total - 4 GB (Win) - 2 GB (Ubuntu) = 10 GB remaining for the host OS. This is plenty of headroom to prevent the host laptop from freezing.
*   **Storage:** Allocated 50 GB for Windows and 20 GB for Ubuntu. Using "Dynamically allocated" disks means they will only use about 15-20 GB of the host's 512 GB SSD initially.

**Non-default settings:**
| Setting | Default | Mine | Why |
| :--- | :--- | :--- | :--- |
| **Network Adapter** | NAT | NAT Network | Standard NAT isolates VMs from each other. "NAT Network" allows the VMs to ping each other locally while still accessing the internet. |
| **Windows Firmware** | BIOS | EFI + TPM 2.0 | Windows 11 will refuse to install on legacy BIOS; it requires EFI and a virtual TPM chip to boot. |
| **Ubuntu RAM** | 1024 MB | 2048 MB | 1 GB is too restrictive for compiling code. 2 GB ensures smooth basic testing. |

After installation, I configured the network, ran ping tests to verify connectivity, and took a "Clean Install" snapshot for both machines.

## 4. Evidence
*   `evidence/01-new-vm-wizard.png` - Proves the Windows VM was created with EFI enabled to meet OS requirements.
*   `evidence/02-disk-settings.png` - Proves the Ubuntu VM was configured with the calculated 2048 MB RAM and 20 GB disk.
*   `evidence/03-network-adapter.png` - Proves both VMs are attached to the same "NAT Network" for local communication.
*   `evidence/04-windows-ping.png` - Proves the Windows guest reaches the internet (`google.com`) and can see the Ubuntu guest.
*   `evidence/05-ubuntu-ping.png` - Proves the Ubuntu guest reaches the internet and can see the Windows guest.
*   `evidence/06-snapshot-list.png` - Proves that a "Clean Install" snapshot exists so Aigerim/developer can roll back if they break the system.

## 5. What I would do differently
Initially, after setting up both VMs, I left their network adapters on the default "NAT" setting. When I tried to ping the Ubuntu machine from Windows, all requests timed out because standard NAT puts each VM in its own isolated bubble. I realized my mistake, powered down both machines, went to VirtualBox Global Tools, created a unified "NAT Network" (10.0.2.0/24), and reassigned both adapters to it. Next time, I will configure the NAT Network in the global tools *before* I even start creating the virtual machines.
