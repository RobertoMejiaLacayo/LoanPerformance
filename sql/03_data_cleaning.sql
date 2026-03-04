CREATE OR REPLACE TABLE `lending_club_raw.loans_cleaned` AS

SELECT
annual_inc,
dti,
emp_length,
funded_amnt,
grade,
home_ownership,
issue_date,
int_rate_pct,
last_payment_date,
loan_amnt,
loan_status, -- keeping the original for ease of reference
CASE
  WHEN loan_status LIKE '%Fully Paid%' THEN 'Fully Paid'
  WHEN loan_status LIKE '%Charged Off%' THEN 'Charged Off'
  WHEN loan_status LIKE '%Default%' THEN 'Charged Off'
  WHEN loan_status LIKE '%Current%' THEN 'Active'
  WHEN loan_status LIKE '%Late%' THEN 'Active'
  WHEN loan_status = 'In Grace Period' THEN 'Active'
  ELSE 'Other'
END AS outcome_category,
CASE
 WHEN loan_status LIKE '%Fully Paid%' THEN 1
 ELSE 0
END AS is_paid,
purpose,
recoveries,
sub_grade,
term_months,
total_pymnt
FROM `lending_club_raw.loans_clean`
WHERE issue_date IS NOT NULL;
