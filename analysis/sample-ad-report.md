# Sample ad performance report (demo data)

> **Demo data, randomly generated.** Same structure as the real ad hoc report: monthly performance by portfolio, course and ad, with commentary. Every course, ad name and number is fictional. The full workbook, including the ad-level sheet, is [`sample-ad-report.xlsx`](sample-ad-report.xlsx).

- **Spend, Reach, Clicks, CTR, LDP View** come from the ads mart. **Lead, MQL, Won** come from the CRM mart, matched to ads through UTM.
- CPL = Spend / Lead, CPL MQL = Spend / MQL, CPL Won = Spend / Won (blank when the count is 0).
- 2026-09 is a partial month.

## Commentary by portfolio (demo data, 2026-07 to 2026-09, September is partial)

*Tiers: MQL rate Good >= 70%, Medium 60-70%, Low < 60%. Won/MQL Strong >= 40%, Average 15-40%, Weak < 15%. Fewer than 10 leads = small sample.*

## Section 1: Lead volume and quality (Volume + MQL rate)

### Overview

| Portfolio | Lead | MQL | MQL rate |
|---|---|---|---|
| Advanced | 58 | 49 | 84.5% (Good) |
| Foundation | 48 | 35 | 72.9% (Good) |
| Specialist | 15 | 10 | 66.7% (Medium) |

**Advanced**: 58 leads in total. MQL rate by month: 78.3% (Good) -> 87.1% (Good) -> 100.0% (Good)

- Course D - Advanced: 27 leads, MQL 85.2% (Good)
- Combo: Course A + Course C: 21 leads, MQL 85.7% (Good)
- Course C - Advanced: 10 leads, MQL 80.0% (Good)

**Foundation**: 48 leads in total. MQL rate by month: 77.8% (Good) -> 57.1% (Low) -> 85.7% (Good)

- Course A - Foundation: 23 leads, MQL 69.6% (Medium)
- Course B - Foundation: 17 leads, MQL 64.7% (Medium)
- Course F - Short course: 8 leads, MQL 100.0% (Good) - small sample, read with care

**Specialist**: 15 leads in total. MQL rate by month: 70.0% (Good) -> 50.0% (Low) -> 100.0% (Good)

- Course E - Specialist: 9 leads, MQL 66.7% (Medium) - small sample, read with care
- Program G - Professional: 6 leads, MQL 66.7% (Medium) - small sample, read with care

## Section 2: Closing ability (Won / MQL)

### Overview

| Portfolio | MQL | Won | Won/MQL |
|---|---|---|---|
| Advanced | 49 | 22 | 44.9% (Strong) |
| Foundation | 35 | 5 | 14.3% (Weak) |
| Specialist | 10 | 0 | 0.0% (Weak) |

**Advanced**

- Course D - Advanced: 23 MQL -> 10 won (43.5%, Strong)
- Combo: Course A + Course C: 18 MQL -> 8 won (44.4%, Strong)
- Course C - Advanced: 8 MQL -> 4 won (50.0%, Strong) - small sample

**Foundation**

- Course A - Foundation: 16 MQL -> 1 won (6.2%, Weak)
- Course B - Foundation: 11 MQL -> 2 won (18.2%, Average)
- Course F - Short course: 8 MQL -> 2 won (25.0%, Average) - small sample

**Specialist**

- Course E - Specialist: 6 MQL -> 0 won (0.0%, Weak) - small sample
- Program G - Professional: 4 MQL -> 0 won (0.0%, Weak) - small sample

### Biggest leak in absolute numbers (MQLs that did not close)

- Course A - Foundation (Foundation): 16 MQL, only 1 won (6.2%), 15 MQLs lost
- Course D - Advanced (Advanced): 23 MQL, only 10 won (43.5%), 13 MQLs lost
- Combo: Course A + Course C (Advanced): 18 MQL, only 8 won (44.4%), 10 MQLs lost

## Portfolio by month

| Portfolio | Month | Spend (VND) | Lead | MQL | Won | CPL (VND) | CPL MQL (VND) | CPL Won (VND) |
|---|---|---|---|---|---|---|---|---|
| Advanced | 2026-07 | 17,279,939 | 23 | 18 | 8 | 751,302 | 959,997 | 2,159,992 |
| Advanced | 2026-08 | 21,274,405 | 31 | 27 | 14 | 686,271 | 787,941 | 1,519,600 |
| Advanced | 2026-09 | 4,807,835 | 4 | 4 | 0 | 1,201,959 | 1,201,959 |  |
| Foundation | 2026-07 | 10,534,670 | 27 | 21 | 3 | 390,173 | 501,651 | 3,511,557 |
| Foundation | 2026-08 | 8,597,950 | 14 | 8 | 1 | 614,139 | 1,074,744 | 8,597,950 |
| Foundation | 2026-09 | 1,963,525 | 7 | 6 | 1 | 280,504 | 327,254 | 1,963,525 |
| Specialist | 2026-07 | 4,738,154 | 10 | 7 | 0 | 473,815 | 676,879 |  |
| Specialist | 2026-08 | 2,917,155 | 4 | 2 | 0 | 729,289 | 1,458,578 |  |
| Specialist | 2026-09 | 648,866 | 1 | 1 | 0 | 648,866 | 648,866 |  |

## Course by month

| Portfolio | Course | Month | Spend (VND) | Lead | MQL | Won | CPL (VND) | CPL MQL (VND) | CPL Won (VND) |
|---|---|---|---|---|---|---|---|---|---|
| Advanced | Combo: Course A + Course C | 2026-07 | 5,099,219 | 10 | 9 | 4 | 509,922 | 566,580 | 1,274,805 |
| Advanced | Combo: Course A + Course C | 2026-08 | 7,331,788 | 9 | 7 | 4 | 814,643 | 1,047,398 | 1,832,947 |
| Advanced | Combo: Course A + Course C | 2026-09 | 1,944,137 | 2 | 2 | 0 | 972,068 | 972,068 |  |
| Advanced | Course C - Advanced | 2026-07 | 7,122,963 | 7 | 5 | 2 | 1,017,566 | 1,424,593 | 3,561,482 |
| Advanced | Course C - Advanced | 2026-08 | 7,911,171 | 3 | 3 | 2 | 2,637,057 | 2,637,057 | 3,955,586 |
| Advanced | Course C - Advanced | 2026-09 | 1,528,525 | 0 | 0 | 0 |  |  |  |
| Advanced | Course D - Advanced | 2026-07 | 5,057,757 | 6 | 4 | 2 | 842,960 | 1,264,439 | 2,528,878 |
| Advanced | Course D - Advanced | 2026-08 | 6,031,446 | 19 | 17 | 8 | 317,445 | 354,791 | 753,931 |
| Advanced | Course D - Advanced | 2026-09 | 1,335,173 | 2 | 2 | 0 | 667,586 | 667,586 |  |
| Foundation | Course A - Foundation | 2026-07 | 3,192,687 | 11 | 7 | 0 | 290,244 | 456,098 |  |
| Foundation | Course A - Foundation | 2026-08 | 3,604,066 | 9 | 6 | 0 | 400,452 | 600,678 |  |
| Foundation | Course A - Foundation | 2026-09 | 742,268 | 3 | 3 | 1 | 247,423 | 247,423 | 742,268 |
| Foundation | Course B - Foundation | 2026-07 | 3,461,279 | 11 | 9 | 2 | 314,662 | 384,587 | 1,730,640 |
| Foundation | Course B - Foundation | 2026-08 | 2,220,361 | 3 | 0 | 0 | 740,120 |  |  |
| Foundation | Course B - Foundation | 2026-09 | 584,457 | 3 | 2 | 0 | 194,819 | 292,228 |  |
| Foundation | Course F - Short course | 2026-07 | 3,880,704 | 5 | 5 | 1 | 776,141 | 776,141 | 3,880,704 |
| Foundation | Course F - Short course | 2026-08 | 2,773,523 | 2 | 2 | 1 | 1,386,762 | 1,386,762 | 2,773,523 |
| Foundation | Course F - Short course | 2026-09 | 636,800 | 1 | 1 | 0 | 636,800 | 636,800 |  |
| Specialist | Course E - Specialist | 2026-07 | 1,664,584 | 5 | 4 | 0 | 332,917 | 416,146 |  |
| Specialist | Course E - Specialist | 2026-08 | 1,754,312 | 3 | 1 | 0 | 584,771 | 1,754,312 |  |
| Specialist | Course E - Specialist | 2026-09 | 256,340 | 1 | 1 | 0 | 256,340 | 256,340 |  |
| Specialist | Program G - Professional | 2026-07 | 3,073,570 | 5 | 3 | 0 | 614,714 | 1,024,523 |  |
| Specialist | Program G - Professional | 2026-08 | 1,162,843 | 1 | 1 | 0 | 1,162,843 | 1,162,843 |  |
| Specialist | Program G - Professional | 2026-09 | 392,526 | 0 | 0 | 0 |  |  |  |

## Ads by month

Top 10 rows by spend, out of 150. The full ad-level sheet is in [`sample-ad-report.xlsx`](sample-ad-report.xlsx).

| Portfolio | Course | Ad | Month | Spend (VND) | Reach | Clicks | CTR (%) | LDP View | Lead | MQL | Won | CPL (VND) | CPL MQL (VND) | CPL Won (VND) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Advanced | Course D - Advanced | CD_Why your reports are ignored | 2026-08 | 3,545,327 | 98,450 | 2,791 | 2.42 | 1,604 | 18 | 17 | 8 | 196,963 | 208,549 | 443,166 |
| Advanced | Course C - Advanced | CC_5 mistakes in your first campaign | 2026-08 | 3,379,288 | 121,976 | 1,105 | 0.75 | 648 | 2 | 2 | 2 | 1,689,644 | 1,689,644 | 1,689,644 |
| Advanced | Course C - Advanced | CC_5 mistakes in your first campaign | 2026-07 | 3,241,233 | 116,168 | 1,060 | 0.75 | 620 | 5 | 4 | 2 | 648,247 | 810,308 | 1,620,616 |
| Advanced | Course D - Advanced | CD_Why your reports are ignored | 2026-07 | 2,971,094 | 66,033 | 2,339 | 2.42 | 595 | 3 | 2 | 1 | 990,365 | 1,485,547 | 2,971,094 |
| Advanced | Course C - Advanced | CC_Stop guessing, start measuring | 2026-07 | 2,668,439 | 83,131 | 1,174 | 1 | 652 | 0 | 0 | 0 |  |  |  |
| Foundation | Course F - Short course | CF_Why your reports are ignored | 2026-07 | 2,003,872 | 118,624 | 3,936 | 2.63 | 1,186 | 2 | 2 | 1 | 1,001,936 | 1,001,936 | 2,003,872 |
| Advanced | Course C - Advanced | CC_Demo in 3 minutes | 2026-08 | 1,962,130 | 49,123 | 282 | 0.41 | 107 | 1 | 1 | 0 | 1,962,130 | 1,962,130 |  |
| Foundation | Course A - Foundation | CA_5 mistakes in your first campaign | 2026-08 | 1,693,485 | 48,009 | 1,861 | 2.52 | 550 | 3 | 2 | 0 | 564,495 | 846,742 |  |
| Advanced | Combo: Course A + Course C | AC_Stop guessing, start measuring | 2026-08 | 1,541,650 | 59,539 | 1,633 | 1.85 | 604 | 1 | 0 | 0 | 1,541,650 |  |  |
| Advanced | Course C - Advanced | CC_Stop guessing, start measuring | 2026-08 | 1,529,861 | 43,490 | 673 | 1 | 247 | 0 | 0 | 0 |  |  |  |
