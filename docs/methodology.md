# Methodology - LendingClub Loan Performance Analysis

**Technical Documentation**

---

## Table of Contents

1. [Data Source & Acquisition](#data-source--acquisition)
2. [Data Cleaning & Transformation](#data-cleaning--transformation)
3. [Metric Calculations](#metric-calculations)
4. [Segmentation Approach](#segmentation-approach)
5. [Portfolio Simulation](#portfolio-simulation)
6. [Statistical Methods](#statistical-methods)
7. [Limitations & Assumptions](#limitations--assumptions)

---

## 1. Data Source & Acquisition

### Source
**Dataset:** LendingClub Loan Data  
**Platform:** Kaggle  
**Link:** https://www.kaggle.com/datasets/adarshsng/lending-club-loan-data-csv

### Data Loading
```sql
-- Loaded via BigQuery web UI
-- Schema auto-detection enabled
-- Result: lending_club_raw.loans (raw table)
```

### Fields Selected for Analysis

**Loan Characteristics:**
- `loan_amnt` - Principal amount
- `funded_amnt` - Amount funded by investors
- `int_rate` - Interest rate (%)
- `term` - 36 or 60 months
- `grade` - Risk grade (A-G)
- `sub_grade` - Granular grade (A1-G5)
- `purpose` - Loan purpose

**Borrower Profile:**
- `annual_inc` - Annual income
- `emp_length` - Employment length
- `dti` - Debt-to-income ratio
- `home_ownership` - RENT / OWN / MORTGAGE
- `fico_range_low` - Credit score

**Outcomes:**
- `loan_status` - Current status
- `total_pymnt` - Total paid by borrower
- `recoveries` - Amount recovered from defaults
- `issue_d` - Loan issue date
- `last_pymnt_d` - Last payment date

---

## 2. Data Cleaning & Transformation

### Step 1: Date Parsing

**Problem:** Dates stored as text ("Dec-2015")

**Solution:**
```sql
PARSE_DATE('%b-%Y', issue_d) AS issue_date
```

**Result:** Converted to proper DATE type for time calculations

---

### Step 2: Loan Status Categorization

**Problem:** 10+ distinct loan status values

**Solution:** Grouped into 4 categories
```sql
CASE 
  WHEN loan_status = 'Fully Paid' THEN 'Paid'
  WHEN loan_status IN ('Charged Off', 'Default') THEN 'Default'
  WHEN loan_status LIKE '%Charged Off%' THEN 'Default'  -- Catches variants
  WHEN loan_status = 'Current' THEN 'Active'
  WHEN loan_status LIKE '%Late%' THEN 'Active'
  ELSE 'Other'
END AS outcome_category
```

**Categories:**
- `Paid` - Loan completed successfully
- `Default` - Loan failed (Charged Off / Default)
- `Active` - Still being paid (Current / Late)
- `Other` - Edge cases

---

### Step 3: NULL Handling

**Fields with missing values:**

**emp_length:**
- Strategy: Replace NULL with 'Unknown'
- Rationale: Unknown employment ≈ short/unstable employment

**annual_inc:**
- Strategy: Replace NULL with median ($65,000)
- Rationale: Prevents skewing of income-based calculations

**dti:**
- Strategy: Replace NULL with median (17.5%)
- Rationale: Maintains distribution for bucketing

**recoveries:**
- Strategy: Replace NULL with 0
- Rationale: NULL means no recovery needed (loan didn't default)

---

### Step 4: Filter to Completed Loans

**Exclusion criteria:**
```sql
WHERE outcome_category IN ('Paid', 'Default')
```

**Why:** Cannot calculate final ROI on Current/Late loans (outcome unknown)

**Result:** 650,000+ completed loans (50% of dataset)

---

## 3. Metric Calculations

### ROI (Return on Investment)

**Formula:**
```
ROI = (Total Payments + Recoveries - Funded Amount) / Funded Amount
```

**SQL Implementation:**
```sql
SAFE_DIVIDE(
  total_pymnt + COALESCE(recoveries, 0) - funded_amnt,
  funded_amnt
) AS roi_pct
```

**Interpretation:**
- Positive ROI = investor made money
- Negative ROI = investor lost money
- 0.15 = 15% return

**Edge cases:**
- Used `SAFE_DIVIDE` to handle funded_amnt = 0
- Used `COALESCE` to treat NULL recoveries as 0

---

### Gross Profit/Loss

**Formula:**
```
Gross Profit = Total Payments + Recoveries - Funded Amount
```

**SQL Implementation:**
```sql
(total_pymnt + COALESCE(recoveries, 0) - funded_amnt) AS gross_profit
```

**Use case:** Dollar-based aggregation (total losses per grade)

---

### Default Rate

**Formula:**
```
Default Rate = (Defaulted Loans / Total Completed Loans) × 100
```

**SQL Implementation:**
```sql
SAFE_DIVIDE(
  COUNTIF(outcome_category = 'Default'),
  COUNT(*)
) * 100 AS default_rate_pct
```

**Why COUNTIF:** Conditional counting within GROUP BY

---

### Breakeven Interest Rate

**Formula:**
```
Breakeven Rate = Default Rate / (1 - Default Rate)
```

**Mathematical Basis:**

If **d** = default rate (as decimal), investors need to earn enough from non-defaulters to cover losses from defaulters.

**Derivation:**
- (1 - d) loans succeed and pay (1 + r)
- d loans default and pay 0
- Breakeven: (1 - d)(1 + r) = 1
- Solving for r: r = d / (1 - d)

**Example:**
- 40% default rate → 0.40 / 0.60 = 0.67 = 67% required interest

**SQL Implementation:**
```sql
SAFE_DIVIDE(
  default_rate_pct / 100,
  1 - (default_rate_pct / 100)
) * 100 AS breakeven_int_rate
```

---

### Profitability Gap

**Formula:**
```
Gap = Actual Interest Rate - Breakeven Interest Rate
```

**Interpretation:**
- Positive gap: overpriced (good for investors)
- Negative gap: underpriced (losing money)
- Zero gap: perfectly priced (break-even)

---

## 4. Segmentation Approach

### Multi-Dimensional Segmentation

Created borrower segments across 5 dimensions:

**1. Loan Purpose**
- Values: debt_consolidation, credit_card, home_improvement, small_business, etc.
- No transformation needed

**2. DTI Buckets**
```sql
CASE
  WHEN dti < 10 THEN '0-10%'
  WHEN dti < 20 THEN '10-20%'
  WHEN dti < 30 THEN '20-30%'
  ELSE '30%+'
END AS dti_bucket
```

**3. Income Quintiles**
```sql
NTILE(5) OVER (ORDER BY annual_inc) AS income_quintile
```
- Divides borrowers into 5 equal groups by income
- Quintile 1 = bottom 20% (lowest income)
- Quintile 5 = top 20% (highest income)

**4. Employment Groups**
```sql
CASE
  WHEN emp_length IN ('< 1 year', '0 years', 'Unknown') THEN 'Short/Unknown'
  WHEN emp_length IN ('1 year', '2 years', '3 years', '4 years') THEN 'Medium (1-4 yrs)'
  WHEN emp_length IN ('5 years', '6 years', '7 years', '8 years', '9 years') THEN 'Long (5-9 yrs)'
  ELSE 'Very Long (10+ yrs)'
END AS emp_group
```

**5. Home Ownership**
- Values: RENT, OWN, MORTGAGE
- No transformation needed

### Segment Filtering

**Minimum segment size:** 50 loans
```sql
HAVING COUNT(*) >= 50
```

**Rationale:** Statistical significance threshold

**Result:** ~1,500 segments (out of 2,400 theoretical combinations)

---

## 5. Portfolio Simulation

### Scenario Definitions

**Baseline:**
- Include: All loans
- Purpose: Establish reference point

**Conservative:**
- Filter: `grade IN ('A', 'B', 'C')`
- Hypothesis: Lower risk = better risk-adjusted returns

**Exclude Small Business:**
- Filter: `purpose != 'small_business'`
- Hypothesis: Small business loans are disproportionately risky

**Low DTI Only:**
- Filter: `dti < 30`
- Hypothesis: High debt burden predicts default

**Homeowners Only:**
- Filter: `home_ownership IN ('OWN', 'MORTGAGE')`
- Hypothesis: Homeownership = financial stability

**Optimal:**
- Combined filters: A-B-C + No SB + DTI<30 + Homeowners
- Hypothesis: Multiple filters compound benefits

### Metrics Calculated Per Scenario
```sql
SELECT 
  COUNT(*) AS total_loans,
  SUM(funded_amnt) AS total_funded,
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Default'), COUNT(*)) * 100 AS default_rate_pct,
  AVG(roi_pct) * 100 AS avg_roi_pct,
  SUM(gross_profit) AS net_profit
```

### Risk-Adjusted Return

**Formula:**
```
Return Per Unit Risk = ROI / Default Rate
```

**Interpretation:** Higher = better risk-adjusted performance

---

## 6. Statistical Methods

### Aggregation Functions Used

**COUNT / COUNTIF:**
```sql
COUNT(*) -- Total rows
COUNTIF(condition) -- Conditional count
```

**SUM / AVG:**
```sql
SUM(amount) -- Total
AVG(amount) -- Mean
```

**Window Functions:**
```sql
NTILE(n) OVER (ORDER BY field) -- Quintiles
ROW_NUMBER() OVER (ORDER BY field) -- Ranking
```

### Conditional Aggregation

**Pattern:**
```sql
SUM(IF(condition, value, 0))
SUM(CASE WHEN condition THEN value ELSE 0 END)
```

**Use case:** Calculate totals for subsets (e.g., total losses only)

---

## 7. Limitations & Assumptions

### Data Limitations

**1. Temporal Coverage**
- Dataset ends 2018
- Current platform performance may differ
- Macroeconomic conditions have changed

**2. Incomplete Loan Cycles**
- Excluded 50% of loans (Current/Late status)
- Creates survivorship bias toward older vintages

**3. Missing Fields**
- Some borrower characteristics unavailable
- Cannot assess credit utilization, payment history

### Analytical Assumptions

**1. Default = 100% Loss**
- Assumption: Defaulted loans lose all principal
- Reality: Some recovery occurs (captured in `recoveries` field)
- Impact: Breakeven rates slightly overstated

**2. Static Default Rates**
- Assumption: Default rates constant across time
- Reality: Recession periods (2008-2009) had higher defaults
- Impact: Portfolio simulations assume stable conditions

**3. No Investor Fees**
- Assumption: ROI calculated pre-fees
- Reality: Platforms charge servicing fees
- Impact: Actual investor returns ~1-2% lower

**4. No Time Value of Money**
- Assumption: ROI calculation ignores time preferences
- Reality: $100 today > $100 in 3 years
- Impact: Slightly overstates returns on longer-term loans

### Methodological Choices

**1. Completed Loans Only**
- Choice: Excluded Current/Late loans
- Rationale: Cannot calculate final ROI
- Trade-off: Smaller sample size, but accurate outcomes

**2. Segment Size Threshold (50 loans)**
- Choice: Required 50+ loans per segment
- Rationale: Statistical significance
- Trade-off: Excludes rare combinations

**3. Equal-Weighted Averages**
- Choice: AVG() treats all loans equally
- Alternative: Dollar-weighted (weight by funded_amnt)
- Rationale: Focus on per-loan performance

---

## Validation Checks Performed

### Data Quality
- Row count validation (before/after transformations)  
- NULL checks on key fields  
- Date range verification (2007-2018)  
- Outlier detection (loan amounts, interest rates)  

### Calculation Accuracy
- Manual ROI spot-checks (10 random loans)  
- Breakeven formula verification (mathematical proof)  
- Segment totals reconcile to portfolio totals  

### Business Logic
- Default rates increase by grade (A→G)  
- ROI correlates with default rates  
- Breakeven rates mathematically sound  

---

## Tools & Technologies

**Data Warehouse:** Google BigQuery  
**Query Language:** SQL (Standard SQL dialect)  
**ETL:** Python 3.9 (pandas, BigQuery client)  
**Visualization:** Looker Studio  
**Version Control:** Git / GitHub  
**Documentation:** Markdown  

---

## Reproducibility

All SQL queries are version-controlled in `/sql` folder.

To reproduce:
1. Load `loan.csv` to BigQuery
2. Run SQL scripts in order (01 → 02 → 03 → 05 → 07)
3. Connect Looker Studio to resulting tables
4. Verify metrics match reported values

---
