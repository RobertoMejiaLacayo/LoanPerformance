# Interactive Dashboard

## View the Looker Studio Dashboard

**[Click here to view the live dashboard](https://lookerstudio.google.com/reporting/bcdfcab2-e361-4036-accf-7b290b1453da/page/4GnrF)**

*(View-only access; no login required)*

---

## Dashboard Overview

The **LendingClub Loan Performance Dashboard** is a 5-page interactive visualization covering:

### Page 1: Executive Summary
- Key metrics (total loans, volume, default rate, ROI)
- Grade-level performance table
- Headline finding

### Page 2: Risk-Return Paradox
- Scatter plot: Interest Rate vs ROI by grade
- Breakeven gap chart (what they charge vs what they need)
- Profitability gap analysis

### Page 3: Borrower Risk Drivers
- Default rates by loan purpose
- Default rates by DTI, income, home ownership
- Riskiest borrower profiles table

### Page 4: Portfolio Scenarios
- Strategy comparison table
- Risk-return scatter (scenarios)
- Volume vs performance trade-off

### Page 5: Methodology & Data
- Data sources and coverage
- Key metric definitions
- Calculation formulas
- Limitations and assumptions

---

## Key Insights from Dashboard

**The Paradox:**
- Grade G charges 27.5% interest but delivers -4.4% ROI
- Needs 99% interest to break even (impossible in consumer lending)

**The Segmentation:**
- Small business loans default 2.2x more than car loans
- Worst profile: 55% default rate
- Best profile: 2.5% default rate

**The Strategy:**
- Conservative portfolio (A-B-C only): 14% defaults, 5.5% ROI
- Optimal portfolio (all filters): 9% defaults, 6.5% ROI

---

## Technology

- **Data Source:** Google BigQuery
- **Visualization:** Looker Studio
- **Update Frequency:** Static (historical analysis)

---

**For technical details, see [Methodology](../docs/methodology.md)**
