CREATE OR REPLACE TABLE lending_club_raw.portfolio_scenarios_comparison AS

WITH scenarios AS (
  SELECT * FROM lending_club_raw.portfolio_scenarios
),

baseline AS (
  SELECT 
    default_rate_pct AS baseline_default_rate,
    avg_roi_pct AS baseline_roi,
    total_loans AS baseline_loan_count
  FROM scenarios
  WHERE scenario_name = 'Baseline: All Loans'
)

SELECT 
  s.*,
  -- ROI Comparison to baseline
  s.default_rate_pct - b.baseline_default_rate AS default_rate_change,
  s.avg_roi_pct - b.baseline_roi AS roi_change,
  
  -- Volume change
  SAFE_DIVIDE(s.total_loans, b.baseline_loan_count) * 100 AS pct_of_baseline_volume,
  
  -- Risk-adjusted return
  SAFE_DIVIDE(s.avg_roi_pct, s.default_rate_pct) AS return_per_unit_risk

FROM scenarios s
CROSS JOIN baseline b
ORDER BY return_per_unit_risk DESC;
