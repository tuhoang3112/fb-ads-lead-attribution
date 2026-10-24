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
| Finance | 39 | 33 | 84.6% (Good) |
| Sales | 66 | 40 | 60.6% (Medium) |
| Design | 66 | 39 | 59.1% (Low) |
| Operations | 166 | 82 | 49.4% (Low) |

**Operations**: 166 leads in total. MQL rate by month: 59.8% (Low) -> 35.9% (Low) -> 46.7% (Low)

- Inventory Management: 50 leads, MQL 56.0% (Low)
- Project Planning Essentials: 36 leads, MQL 58.3% (Low)
- Lean Process Improvement: 35 leads, MQL 31.4% (Low)
- Supply Chain Fundamentals: 28 leads, MQL 50.0% (Low)
- Quality Control Basics: 17 leads, MQL 47.1% (Low)

**Design**: 66 leads in total. MQL rate by month: 56.7% (Low) -> 64.0% (Medium) -> 54.5% (Low)

- Visual Design Essentials: 45 leads, MQL 60.0% (Medium)
- UX Research Basics: 9 leads, MQL 55.6% (Low) - small sample, read with care
- Prototyping with Figma: 7 leads, MQL 57.1% (Low) - small sample, read with care
- Design Systems Workshop: 5 leads, MQL 60.0% (Medium) - small sample, read with care

**Sales**: 66 leads in total. MQL rate by month: 70.8% (Good) -> 58.8% (Low) -> 37.5% (Low)

- Cold Outreach Workshop: 35 leads, MQL 51.4% (Low)
- CRM for Sales Teams: 10 leads, MQL 80.0% (Good)
- Negotiation Skills: 8 leads, MQL 50.0% (Low) - small sample, read with care
- Sales Forecasting Basics: 7 leads, MQL 57.1% (Low) - small sample, read with care
- Consultative Selling: 5 leads, MQL 100.0% (Good) - small sample, read with care
- Account Management: 1 lead, MQL 100.0% (Good) - small sample, read with care

**Finance**: 39 leads in total. MQL rate by month: 86.7% (Good) -> 83.3% (Good) -> n/a

- Investment Fundamentals: 12 leads, MQL 100.0% (Good)
- Cash Flow Analysis: 12 leads, MQL 83.3% (Good)
- Pricing Strategy Workshop: 8 leads, MQL 75.0% (Good) - small sample, read with care
- Budgeting for Managers: 5 leads, MQL 80.0% (Good) - small sample, read with care
- Financial Modeling Basics: 2 leads, MQL 50.0% (Low) - small sample, read with care

## Section 2: Closing ability (Won / MQL)

### Overview

| Portfolio | MQL | Won | Won/MQL |
|---|---|---|---|
| Finance | 33 | 14 | 42.4% (Strong) |
| Sales | 40 | 12 | 30.0% (Average) |
| Design | 39 | 7 | 17.9% (Average) |
| Operations | 82 | 5 | 6.1% (Weak) |

**Operations**

- Inventory Management: 28 MQL -> 0 won (0.0%, Weak)
- Project Planning Essentials: 21 MQL -> 2 won (9.5%, Weak)
- Supply Chain Fundamentals: 14 MQL -> 0 won (0.0%, Weak)
- Lean Process Improvement: 11 MQL -> 2 won (18.2%, Average)
- Quality Control Basics: 8 MQL -> 1 won (12.5%, Weak) - small sample

**Design**

- Visual Design Essentials: 27 MQL -> 6 won (22.2%, Average)
- UX Research Basics: 5 MQL -> 0 won (0.0%, Weak) - small sample
- Prototyping with Figma: 4 MQL -> 0 won (0.0%, Weak) - small sample
- Design Systems Workshop: 3 MQL -> 1 won (33.3%, Average) - small sample

**Sales**

- Cold Outreach Workshop: 18 MQL -> 7 won (38.9%, Average)
- CRM for Sales Teams: 8 MQL -> 2 won (25.0%, Average) - small sample
- Consultative Selling: 5 MQL -> 2 won (40.0%, Strong) - small sample
- Negotiation Skills: 4 MQL -> 0 won (0.0%, Weak) - small sample
- Sales Forecasting Basics: 4 MQL -> 0 won (0.0%, Weak) - small sample
- Account Management: 1 MQL -> 1 won (100.0%, Strong) - small sample

**Finance**

- Investment Fundamentals: 12 MQL -> 3 won (25.0%, Average)
- Cash Flow Analysis: 10 MQL -> 6 won (60.0%, Strong)
- Pricing Strategy Workshop: 6 MQL -> 3 won (50.0%, Strong) - small sample
- Budgeting for Managers: 4 MQL -> 2 won (50.0%, Strong) - small sample
- Financial Modeling Basics: 1 MQL -> 0 won (0.0%, Weak) - small sample

### Biggest leak in absolute numbers (MQLs that did not close)

- Inventory Management (Operations): 28 MQL, only 0 won (0.0%), 28 MQLs lost
- Visual Design Essentials (Design): 27 MQL, only 6 won (22.2%), 21 MQLs lost
- Project Planning Essentials (Operations): 21 MQL, only 2 won (9.5%), 19 MQLs lost

## Portfolio by month

| Portfolio | Month | Spend (VND) | Lead | MQL | Won | CPL (VND) | CPL MQL (VND) | CPL Won (VND) |
|---|---|---|---|---|---|---|---|---|
| Design | 2026-07 | 17,167,559 | 30 | 17 | 1 | 572,252 | 1,009,856 | 17,167,559 |
| Design | 2026-08 | 15,943,670 | 25 | 16 | 5 | 637,747 | 996,479 | 3,188,734 |
| Design | 2026-09 | 3,719,054 | 11 | 6 | 1 | 338,096 | 619,842 | 3,719,054 |
| Finance | 2026-07 | 15,220,205 | 15 | 13 | 5 | 1,014,680 | 1,170,785 | 3,044,041 |
| Finance | 2026-08 | 15,824,913 | 24 | 20 | 9 | 659,371 | 791,246 | 1,758,324 |
| Finance | 2026-09 | 2,150,074 | 0 | 0 | 0 |  |  |  |
| Operations | 2026-07 | 27,364,665 | 87 | 52 | 4 | 314,536 | 526,244 | 6,841,166 |
| Operations | 2026-08 | 26,150,508 | 64 | 23 | 1 | 408,602 | 1,136,979 | 26,150,508 |
| Operations | 2026-09 | 6,024,366 | 15 | 7 | 0 | 401,624 | 860,624 |  |
| Sales | 2026-07 | 15,767,221 | 24 | 17 | 5 | 656,968 | 927,484 | 3,153,444 |
| Sales | 2026-08 | 17,928,270 | 34 | 20 | 6 | 527,302 | 896,414 | 2,988,045 |
| Sales | 2026-09 | 4,056,602 | 8 | 3 | 1 | 507,075 | 1,352,201 | 4,056,602 |

## Course by month

| Portfolio | Course | Month | Spend (VND) | Lead | MQL | Won | CPL (VND) | CPL MQL (VND) | CPL Won (VND) |
|---|---|---|---|---|---|---|---|---|---|
| Design | Design Systems Workshop | 2026-07 | 1,862,990 | 2 | 1 | 0 | 931,495 | 1,862,990 |  |
| Design | Design Systems Workshop | 2026-08 | 1,707,307 | 1 | 1 | 1 | 1,707,307 | 1,707,307 | 1,707,307 |
| Design | Design Systems Workshop | 2026-09 | 347,884 | 2 | 1 | 0 | 173,942 | 347,884 |  |
| Design | Prototyping with Figma | 2026-07 | 1,649,018 | 5 | 4 | 0 | 329,804 | 412,254 |  |
| Design | Prototyping with Figma | 2026-08 | 1,583,626 | 2 | 0 | 0 | 791,813 |  |  |
| Design | Prototyping with Figma | 2026-09 | 175,203 | 0 | 0 | 0 |  |  |  |
| Design | UX Research Basics | 2026-07 | 5,373,250 | 4 | 2 | 0 | 1,343,312 | 2,686,625 |  |
| Design | UX Research Basics | 2026-08 | 4,960,354 | 2 | 1 | 0 | 2,480,177 | 4,960,354 |  |
| Design | UX Research Basics | 2026-09 | 1,247,445 | 3 | 2 | 0 | 415,815 | 623,722 |  |
| Design | Visual Design Essentials | 2026-07 | 8,282,301 | 19 | 10 | 1 | 435,911 | 828,230 | 8,282,301 |
| Design | Visual Design Essentials | 2026-08 | 7,692,383 | 20 | 14 | 4 | 384,619 | 549,456 | 1,923,096 |
| Design | Visual Design Essentials | 2026-09 | 1,948,522 | 6 | 3 | 1 | 324,754 | 649,507 | 1,948,522 |
| Finance | Budgeting for Managers | 2026-07 | 2,206,224 | 3 | 3 | 1 | 735,408 | 735,408 | 2,206,224 |
| Finance | Budgeting for Managers | 2026-08 | 1,366,251 | 2 | 1 | 1 | 683,126 | 1,366,251 | 1,366,251 |
| Finance | Budgeting for Managers | 2026-09 | 243,204 | 0 | 0 | 0 |  |  |  |
| Finance | Cash Flow Analysis | 2026-07 | 1,937,019 | 6 | 4 | 3 | 322,836 | 484,255 | 645,673 |
| Finance | Cash Flow Analysis | 2026-08 | 3,472,692 | 6 | 6 | 3 | 578,782 | 578,782 | 1,157,564 |
| Finance | Cash Flow Analysis | 2026-09 | 759,336 | 0 | 0 | 0 |  |  |  |
| Finance | Financial Modeling Basics | 2026-07 | 685,817 | 0 | 0 | 0 |  |  |  |
| Finance | Financial Modeling Basics | 2026-08 | 603,124 | 2 | 1 | 0 | 301,562 | 603,124 |  |
| Finance | Financial Modeling Basics | 2026-09 | 126,475 | 0 | 0 | 0 |  |  |  |
| Finance | Investment Fundamentals | 2026-07 | 8,821,693 | 6 | 6 | 1 | 1,470,282 | 1,470,282 | 8,821,693 |
| Finance | Investment Fundamentals | 2026-08 | 6,468,936 | 6 | 6 | 2 | 1,078,156 | 1,078,156 | 3,234,468 |
| Finance | Investment Fundamentals | 2026-09 | 222,318 | 0 | 0 | 0 |  |  |  |
| Finance | Pricing Strategy Workshop | 2026-07 | 1,569,452 | 0 | 0 | 0 |  |  |  |
| Finance | Pricing Strategy Workshop | 2026-08 | 3,913,910 | 8 | 6 | 3 | 489,239 | 652,318 | 1,304,637 |
| Finance | Pricing Strategy Workshop | 2026-09 | 798,741 | 0 | 0 | 0 |  |  |  |
| Operations | Inventory Management | 2026-07 | 4,327,014 | 20 | 13 | 0 | 216,351 | 332,847 |  |
| Operations | Inventory Management | 2026-08 | 6,158,943 | 25 | 13 | 0 | 246,358 | 473,765 |  |
| Operations | Inventory Management | 2026-09 | 1,279,451 | 5 | 2 | 0 | 255,890 | 639,726 |  |
| Operations | Lean Process Improvement | 2026-07 | 7,758,187 | 16 | 7 | 2 | 484,887 | 1,108,312 | 3,879,094 |
| Operations | Lean Process Improvement | 2026-08 | 8,320,396 | 17 | 2 | 0 | 489,435 | 4,160,198 |  |
| Operations | Lean Process Improvement | 2026-09 | 2,442,609 | 2 | 2 | 0 | 1,221,304 | 1,221,304 |  |
| Operations | Project Planning Essentials | 2026-07 | 6,519,374 | 29 | 19 | 1 | 224,806 | 343,125 | 6,519,374 |
| Operations | Project Planning Essentials | 2026-08 | 3,154,254 | 7 | 2 | 1 | 450,608 | 1,577,127 | 3,154,254 |
| Operations | Project Planning Essentials | 2026-09 | 450,535 | 0 | 0 | 0 |  |  |  |
| Operations | Quality Control Basics | 2026-07 | 3,264,539 | 10 | 6 | 1 | 326,454 | 544,090 | 3,264,539 |
| Operations | Quality Control Basics | 2026-08 | 2,798,283 | 6 | 1 | 0 | 466,380 | 2,798,283 |  |
| Operations | Quality Control Basics | 2026-09 | 289,116 | 1 | 1 | 0 | 289,116 | 289,116 |  |
| Operations | Supply Chain Fundamentals | 2026-07 | 5,495,551 | 12 | 7 | 0 | 457,963 | 785,079 |  |
| Operations | Supply Chain Fundamentals | 2026-08 | 5,718,632 | 9 | 5 | 0 | 635,404 | 1,143,726 |  |
| Operations | Supply Chain Fundamentals | 2026-09 | 1,562,655 | 7 | 2 | 0 | 223,236 | 781,328 |  |
| Sales | Account Management | 2026-07 | 1,121,097 | 0 | 0 | 0 |  |  |  |
| Sales | Account Management | 2026-08 | 2,329,413 | 1 | 1 | 1 | 2,329,413 | 2,329,413 | 2,329,413 |
| Sales | Account Management | 2026-09 | 295,437 | 0 | 0 | 0 |  |  |  |
| Sales | CRM for Sales Teams | 2026-07 | 4,127,813 | 6 | 4 | 0 | 687,969 | 1,031,953 |  |
| Sales | CRM for Sales Teams | 2026-08 | 4,971,221 | 3 | 3 | 1 | 1,657,074 | 1,657,074 | 4,971,221 |
| Sales | CRM for Sales Teams | 2026-09 | 1,419,793 | 1 | 1 | 1 | 1,419,793 | 1,419,793 | 1,419,793 |
| Sales | Cold Outreach Workshop | 2026-07 | 2,922,792 | 11 | 7 | 3 | 265,708 | 417,542 | 974,264 |
| Sales | Cold Outreach Workshop | 2026-08 | 5,153,575 | 19 | 9 | 4 | 271,241 | 572,619 | 1,288,394 |
| Sales | Cold Outreach Workshop | 2026-09 | 1,718,376 | 5 | 2 | 0 | 343,675 | 859,188 |  |
| Sales | Consultative Selling | 2026-07 | 3,713,139 | 4 | 4 | 2 | 928,285 | 928,285 | 1,856,570 |
| Sales | Consultative Selling | 2026-08 | 895,954 | 1 | 1 | 0 | 895,954 | 895,954 |  |
| Sales | Consultative Selling | 2026-09 | 125,364 | 0 | 0 | 0 |  |  |  |
| Sales | Negotiation Skills | 2026-07 | 2,941,699 | 1 | 0 | 0 | 2,941,699 |  |  |
| Sales | Negotiation Skills | 2026-08 | 3,303,454 | 7 | 4 | 0 | 471,922 | 825,864 |  |
| Sales | Negotiation Skills | 2026-09 | 240,793 | 0 | 0 | 0 |  |  |  |
| Sales | Sales Forecasting Basics | 2026-07 | 940,681 | 2 | 2 | 0 | 470,340 | 470,340 |  |
| Sales | Sales Forecasting Basics | 2026-08 | 1,274,653 | 3 | 2 | 0 | 424,884 | 637,326 |  |
| Sales | Sales Forecasting Basics | 2026-09 | 256,839 | 2 | 0 | 0 | 128,420 |  |  |

## Ads by month

The ad-level sheet has about 300 rows. Open it in [`sample-ad-report.xlsx`](sample-ad-report.xlsx).
