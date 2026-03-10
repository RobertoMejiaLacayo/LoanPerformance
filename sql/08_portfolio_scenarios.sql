CREATE OR REPLACE TABLE lending_club_raw.portfolio_scenarios AS

-- Scenario 0: Baseline (all loans)
SELECT 
  'Baseline: All Loans' AS scenario_name,
  COUNT(*) AS total_loans,
  SUM(funded_amnt) AS total_funded,
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100 AS default_rate_pct,
  AVG(roi_pct) * 100 AS avg_roi_pct,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))) AS total_losses,
  SUM(IF(gross_profit > 0, gross_profit, 0)) AS total_gains,
  SUM(gross_profit) AS net_profit
FROM lending_club_raw.loan_performance

UNION ALL

-- Scenario 1: Conservative (A-B-C)
SELECT 
  'Conservative: A-B-C Only',
  COUNT(*),
  SUM(funded_amnt),
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100,
  AVG(roi_pct) * 100,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
  SUM(IF(gross_profit > 0, gross_profit, 0)),
  SUM(gross_profit)
FROM lending_club_raw.loan_performance
WHERE grade IN ('A', 'B', 'C')

UNION ALL

-- Scenario 2: Exclude small business
SELECT 
  'Exclude Small Business',
  COUNT(*),
  SUM(funded_amnt),
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100,
  AVG(roi_pct) * 100,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
  SUM(IF(gross_profit > 0, gross_profit, 0)),
  SUM(gross_profit)
FROM lending_club_raw.loan_performance
WHERE purpose != 'small_business'

UNION ALL

-- Scenario 3: Low DTI only
SELECT 
  'Low DTI Only (<30%)',
  COUNT(*),
  SUM(funded_amnt),
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100,
  AVG(roi_pct) * 100,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
  SUM(IF(gross_profit > 0, gross_profit, 0)),
  SUM(gross_profit)
FROM lending_club_raw.loan_performance
WHERE dti < 30

UNION ALL

-- Scenario 4: Homeowners only
SELECT 
  'Homeowners Only',
  COUNT(*),
  SUM(funded_amnt),
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100,
  AVG(roi_pct) * 100,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
  SUM(IF(gross_profit > 0, gross_profit, 0)),
  SUM(gross_profit)
FROM lending_club_raw.loan_performance
WHERE home_ownership IN ('OWN', 'MORTGAGE')

UNION ALL

-- Scenario 5: Optimal (all filters combined)
SELECT 
  'Optimal: A-B-C + No SB + Low DTI + Homeowners',
  COUNT(*),
  SUM(funded_amnt),
  SAFE_DIVIDE(COUNTIF(outcome_category = 'Charged Off'), COUNT(*)) * 100,
  AVG(roi_pct) * 100,
  ABS(SUM(IF(gross_profit < 0, gross_profit, 0))),
  SUM(IF(gross_profit > 0, gross_profit, 0)),
  SUM(gross_profit)
FROM lending_club_raw.loan_performance
WHERE grade IN ('A', 'B', 'C')
  AND purpose != 'small_business'
  AND dti < 30
  AND home_ownership IN ('OWN', 'MORTGAGE')

ORDER BY default_rate_pct ASC;
