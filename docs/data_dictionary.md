# This project’s version of the Lending Club dataset dictionary

## Dataset Overview
- **Source:** Kaggle - Lending Club Loan Data
- **Rows:** 2,260,669 loans
- **Columns:** 15 fields
- **Time Period:** 2007-2017
- **Last Updated:** Jan 31 2026

## Key Fields

### Loan Characteristics
- **loan_amnt**: Dollar amount of the loan ($500 - $40,000)
- **int_rate_pct**: Interest rate as a percentage (5.31% - 30.99%)
- **grade**: LendingClub assigned loan grade (A = best, G = worst)
- **term_months**: Loan duration, either 36 or 60 months
- **purpose**: Reason for loan (medical, car, small business, etc.)

### Borrower Information
- **annual_inc**: Borrower's annual income in dollars ($0 - $110,000,000.0)
- **emp_length**: Years employed at current job (<1 year - 10+ years)
- **dti**: Debt-to-income ratio, as existing debt / income
- **home_ownership**: RENT, OWN, MORTGAGE

### Loan Outcomes
- **loan_status**: Current status of the loan
  - Fully Paid: Loan was paid off
  - Charged Off: Loan defaulted
  - Current: Still being paid
  - Late: Behind on payments
  - Default: In default
- **total_pymnt**: Total amount borrower has paid to date ($0 - $63,296.88)
- **recoveries**: Amount recovered from defaulted loans ($0 - $39859.55)

## Data Quality Notes
- Some columns have missing values
- Current and Late loans excluded from ROI analysis (only interested in matured loans)
