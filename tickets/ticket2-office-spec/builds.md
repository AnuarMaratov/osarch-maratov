# Builds (prices in KZT, seen 2026-11-22; full line items in budget.csv)

Platform for all four: AMD AM5 + DDR5, MSI PRO B650M-P (mATX), Kingston NV3 1 TB NVMe,
MSI MAG A550BN 550 W, DeepCool CC560 V2, DeepCool AG400 cooler (OEM CPUs ship without a cooler).
All parts are priced at one shop (shop.kz), checked live on 2026-11-22 in the browser (see evidence/vendor-quotes/).

| Role | CPU | RAM | Monitor | OS | Total |
|---|---|---|---|---|---|
| Accountant | Ryzen 5 7600X (6C/12T, iGPU) | 16 GB DDR5 (1x16) | 23.8" Philips 24E1N1100A | Windows 11 Pro | 636,320 |
| Sales manager | Ryzen 5 7600X (6C/12T, iGPU) | 16 GB DDR5 (1x16) | 23.8" Philips 24E1N1100A | Windows 11 Pro | 636,320 |
| Web developer | Ryzen 7 7700 (8C/16T, iGPU) | 32 GB DDR5 (2x16) | 27" QHD Xiaomi A27Qi | Ubuntu LTS | 729,520 |
| Designer | Ryzen 7 7700 (8C/16T, iGPU) | 32 GB DDR5 (2x16) | 27" QHD IPS iiyama XUB2797QSN | Windows 11 Pro | 904,010 |
| **Total** | | | | | **2,906,170** |

Reserve under the 3,000,000 limit: 93,830.

## Why these parts
- **Accountant / sales**: office apps, 1C/CRM, browser. 6 cores and 16 GB are enough; Ryzen 7600 has integrated graphics, so no GPU.
- **Web developer**: Docker, IDE, browsers, VMs -> 8 cores and 32 GB; Ubuntu is free, so money goes to RAM and a QHD screen.
- **Designer**: 32 GB for Photoshop/Illustrator files, larger QHD IPS monitor. No discrete GPU (budget); upgrade path: add a GPU, 550 W PSU leaves room for a small card.
- **Compatibility**: all CPUs are AM5; B650 board takes DDR5; M.2 NVMe slot for the SSD; mATX board fits the ATX case; AG400 supports AM5; the CPUs (105 W / 65 W) need far less than 550 W.
- **Why 7600X, not 7600**: the plain Ryzen 5 7600 is out of stock at shop.kz today; 7600X is in stock for ~6k more.
- **Trade-offs**: single 16 GB stick = single channel (slower iGPU, easy to add a second stick); PSU/case/cooler are budget models; no keyboard/mouse/UPS in the price.

## Pre-built comparison (seen 2026-11-22, alfa.kz listings)
| Option | Price | Notes |
|---|---|---|
| Dell Pro Tower QCT1255, Ryzen 5 8600G / 16 GB / 512 GB / W11 Pro, 3Y service | 529,804 | no monitor; https://alfa.kz/pc/computers/amd/ryzen_5/dell/8595481 |
| Our accountant build without monitor | 593,730 | 1 TB SSD, own warranty per part |
| ONVYX 201867, Ryzen 5 7500F / 16 GB / 512 GB / RTX 5060, 600 W | 597,813 | gaming tower, no monitor; https://alfa.kz/pc/computers/amd/ryzen_5/onvyx/8593294 |

Pre-built is about 64k cheaper at the office tier (RAM prices make self-built expensive today) and has one
warranty/service contact; self-built gives 1 TB storage, upgradeable parts and a free choice per role.
