CREATE OR REPLACE TABLE lending_club_raw.borrower_segmentation AS

WITH base_segments AS (
  SELECT 
    -- Fields we need for segmentation
    outcome_category,
    funded_amnt,
    roi_pct,
    int_rate_pct,
    loan_amnt,
    
    -- Original segmentation fields
    purpose,
    dti,
    annual_inc,
    emp_length,
    home_ownership,
    
    -- DTI buckets
    CASE
      WHEN dti < 10 THEN '0-10%'
      WHEN dti < 20 THEN '10-20%'
      WHEN dti < 30 THEN '20-30%'
      ELSE '30%+'
    END AS dti_bucket,
    
    -- Income quintiles
    NTILE(5) OVER (ORDER BY annual_inc) AS income_quintile,
    
    -- Employment groups
    CASE
      WHEN emp_length IN ('< 1 year', '1 year', 'n/a') THEN 'Short/Unknown'
      WHEN emp_length IN ('2 years', '3 years', '4 years') THEN 'Medium (1-4 yrs)'
      WHEN emp_length IN ('5 years', '6 years', '7 years', '8 years', '9 years') THEN 'Long (5-9 yrs)'
      ELSE 'Very Long (10+ yrs)'
    END AS emp_group
    
  FROM lending_club_raw.loan_performance
)

SELECT 
  purpose,
  dti_bucket,
  income_quintile,
  emp_group,
  home_ownership,
  
  COUNT(*) AS total_loans,
  SUM(funded_amnt) AS total_funded,
  
  SAFE_DIVIDE(
    COUNTIF(outcome_category = 'Charged Off'),
    COUNT(*)
  ) * 100 AS default_rate_pct,
  
  AVG(roi_pct) * 100 AS avg_roi_pct,
  AVG(int_rate_pct) AS avg_interest_rate,
  AVG(loan_amnt) AS avg_loan_size

FROM base_segments
GROUP BY purpose, dti_bucket, income_quintile, emp_group, home_ownership
HAVING COUNT(*) >= 50 -- Exclude buckets with less than 50 rows, not significant
ORDER BY default_rate_pct DESC;
