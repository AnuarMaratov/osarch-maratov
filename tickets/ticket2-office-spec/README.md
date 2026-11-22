# Ticket 2 - Kitting out the new office

## 1. What was asked
From Daniyar K. (Director), "computers for the new office": "We are opening the second office and need four computers - accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

## 2. What was actually needed
- **Four identical machines are wrong.** The four people load the computer differently: the accountant's limit is memory and disk with big Excel/1C files, the sales manager's is memory (CRM tabs + video calls), the developer's is memory and CPU threads (containers, database), the designer's is the monitor and graphics. Identical machines would waste money where the load is light and starve it where the load is heavy.
- **What the request left out:** the operating system licenses (Windows Pro costs about 124,000 KZT each), keyboards, mice, cables, a UPS, backups, and whether "3,000,000 for everything" includes them. "A few years" also means the platform must be upgradeable: AM5 + DDR5 can take a newer CPU and more memory later.
- **What I would ask Daniyar:** which accounting software (does it need Windows?), how big the accountant's files are, whether the designer works with video, whether keyboards/mice/UPS are inside the 3,000,000, how many years "a few" is, whether there is a company backup.
- **What I assumed instead:** the budget covers the PC, one monitor and the OS only; accounting software needs Windows; 4-5 years of use; backups are handled outside these machines; the designer works with images (not heavy video).

## 3. What I did
Role -> load -> bottleneck -> parts. Parts were chosen on one platform (AM5, DDR5, B650, NVMe 1 TB) for compatibility and future upgrades, then the money was moved to each bottleneck. Prices are live shop.kz prices checked in a browser on 2026-11-22. Details: [builds.md](builds.md), [budget.csv](budget.csv).

| Role | CPU | RAM | OS | Total, KZT |
|---|---|---|---|---|
| Accountant | Ryzen 5 7600X | 16 GB | Windows 11 Pro | 636,320 |
| Sales manager | Ryzen 5 7600X | 16 GB | Windows 11 Pro | 636,320 |
| Web developer | Ryzen 7 7700 | 32 GB | Ubuntu LTS | 729,520 |
| Designer | Ryzen 7 7700 | 32 GB | Windows 11 Pro | 904,010 |

Grand total 2,906,170 KZT, reserve 93,830 KZT. Ryzen 5 7600 was out of stock, so 7600X was used.

**Which machine will I upgrade first, 18 months from now?** The sales manager's memory: add a second 16 GB stick (32 GB, dual channel). A browser with 30-40 tabs plus video calls already needs about 11-12 GB, so 16 GB has the least headroom as web apps grow. The board has 4 DDR5 slots, which makes this a 5-minute upgrade.

**Pre-built instead of building?** I priced the same four as pre-built from shop.kz (table in builds.md, dated 2026-11-22): about 3,347,000 KZT for all four after adding the monitors, Windows and a 1 TB SSD where missing, which is over the budget. The company *gains* a warranty from one seller, support, and no time spent assembling. It *loses* the choice of parts, an easy upgrade path (the pre-built office PC has a 480 GB SSD and an Intel platform; the gaming PCs carry a GPU the web developer does not need) and about 440,000 KZT of budget.

**Who will complain within a month, and about what?** The designer, about performance: there is no discrete GPU, so heavy Photoshop filters, large-file saves and any video export will be slow on integrated graphics. That is the trade-off I accepted to afford the QHD IPS monitor and 32 GB; the PSU and slot leave room to add a GPU.

## 4. Evidence
- [budget.csv](budget.csv): every part with price, shop link and the date the price was taken, totals per role and the grand total.
- [builds.md](builds.md): load, bottleneck, trade-off and total for each build, plus the pre-built comparison.
- [evidence/vendor-quotes/](evidence/vendor-quotes/): prices captured from shop.kz on 2026-11-22.
- [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md): compatibility and power check of each build (PCPartPicker does not price in tenge, so it is used for compatibility only).

## 5. What I would do differently
I would take every price at a second Kazakhstan shop and screenshot both on the same day: memory prices differed by 10-20% between shops (16 GB DDR5 from about 152,000 to 171,000 KZT), and my first estimate from search results was stale. I would also ask Daniyar the open questions in section 2 before choosing.
