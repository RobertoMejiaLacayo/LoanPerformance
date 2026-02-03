# Initial Data Exploration — Week 1 Findings

## What I Did
- Downloaded the Lending Club loan dataset from Kaggle
- Explored the data in Python/pandas (sanity checks + basic distributions)
- Uploaded the dataset to BigQuery for SQL-based analysis
- Identified the core fields needed for the project’s main questions

## Basic Statistics
- **Rows:** 2,260,669 loans  
- **Rows with any NULL values:** 1,716  
- **Columns:** 15 fields  
- **Time Period:** 2007–2015  
- **Source:** Kaggle — Lending Club Loan Data  
- **Last Updated:** Jan 31, 2026  

## Loan Status Breakdown (Top 3)
- **Fully Paid:** 1,041,952 (46.09%)  
- **Charged Off:** 261,655 (11.57%)  
- **Current:** 919,695 (40.68%)  

## Preliminary Observations

### 1) Grade Distribution
Most loans are **B** and **C** grade (middle risk). There are fewer **A** grade (safest) and fewer **F/G** grade (riskiest).

### 2) Loan Purposes
Top 3 purposes:
- Debt consolidation  
- Credit card  
- Home improvement  

### 3) Default Patterns (Early Observation)
Higher-risk grades (**F**, **G**) appear to have much higher charge-off rates. Next step is to test whether higher interest rates actually compensate for higher default risk.

## Next Steps
- Clean the data (handle missing values, parse dates)
- Calculate ROI for each loan
- Analyze default rates by grade
- Build summary tables for the dashboard
