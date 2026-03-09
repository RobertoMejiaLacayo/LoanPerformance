CREATE OR REPLACE TABLE lending_club_raw.grade_performance AS

SELECT
  grade,
  
  -- VOLUME METRICS
  COUNT(*) AS total_loans,
  SUM(funded_amnt) AS total_funded,
  
  -- DEFAULT METRICS
  COUNTIF(outcome_category = 'Charged Off') AS defaulted_loans,
  SAFE_DIVIDE(
    COUNTIF(outcome_category = 'Charged Off'),
    COUNT(*)
  ) * 100 AS default_rate_pct,
  
  -- INTEREST & RETURN METRICS
  AVG(int_rate_pct) AS avg_interest_rate,
  AVG(roi_pct) * 100 AS avg_roi_pct,
  
  -- LOSS METRICS
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))) AS total_losses,
  SAFE_DIVIDE(
    ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
    SUM(funded_amnt)
  ) * 100 AS loss_rate_pct,
  
  -- BREAKEVEN ANALYSIS
  SAFE_DIVIDE(
    SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100 / 100,
    1 - (SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100 / 100)
  ) * 100 AS breakeven_int_rate

FROM lending_club_raw.loan_performance
GROUP BY grade
ORDER BY grade;
