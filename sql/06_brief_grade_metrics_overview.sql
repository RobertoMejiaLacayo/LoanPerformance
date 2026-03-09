SELECT 
  COUNT(*) AS total_loans,
  SUM(funded_amnt) AS total_funded,
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100 AS overall_default_rate,
  AVG(roi_pct) * 100 AS overall_avg_roi
FROM lending_club_raw.loan_performance;

SELECT 
  grade,
  SUM(total_losses) AS total_losses_per_grade
FROM lending_club_raw.grade_performance
GROUP BY grade;

SELECT 
  grade,
  avg_interest_rate,
  default_rate_pct,
  breakeven_int_rate,
  (avg_interest_rate - breakeven_int_rate) AS profitability_gap
FROM lending_club_raw.grade_performance
ORDER BY grade;
