CREATE OR REPLACE TABLE lending_club_raw.loan_performance AS

SELECT
  -- MAIN LOAN FIELDS
  loan_amnt,
  funded_amnt,
  int_rate_pct,
  grade,
  sub_grade,
  purpose,
  issue_date,
  outcome_category,
  
  -- BORROWER CHARACTERISTICS (later segmentation)
  dti,
  emp_length,
  home_ownership,
  
  -- ROI CALCULATION
  SAFE_DIVIDE(
    total_pymnt + COALESCE(recoveries, 0) - funded_amnt,
    funded_amnt
  ) AS roi_pct,
  
  -- PROFIT/LOSS IN DOLLARS
  (total_pymnt + COALESCE(recoveries, 0) - funded_amnt) AS gross_profit,
  
  -- TIME METRICS
  DATE_DIFF(last_payment_date, issue_date, MONTH) AS months_to_outcome,
  
  -- RISK FLAGS
  CASE 
    WHEN dti > 30 THEN 1
    ELSE 0
  END AS high_dti,

  CASE
    WHEN emp_length IN ('< 1 year', '1 year', 'n/a') THEN 1
    ELSE 0
  END AS short_employment

FROM lending_club_raw.loans_cleaned

-- ONLY INCLUDE COMPLETED LOANS
WHERE outcome_category IN ('Fully Paid', 'Charged Off');
