CREATE OR REPLACE TABLE `lending_club_raw.loans_clean` AS
SELECT
 SAFE_CAST(`loan_amnt` AS FLOAT64)                 AS loan_amnt,
 SAFE_CAST(`funded_amnt` AS FLOAT64)               AS funded_amnt,
 SAFE_CAST(REPLACE(`int_rate`, '%', '') AS FLOAT64) AS int_rate_pct,
 SAFE_CAST(REGEXP_EXTRACT(`term`, r'(\d+)') AS INT64) AS term_months,
 `grade`                                           AS grade,
 `sub_grade`                                       AS sub_grade,
 `purpose`                                         AS purpose,
 SAFE.PARSE_DATE('%b-%Y', `issue_d`)               AS issue_date,
 SAFE_CAST(`annual_inc` AS FLOAT64)                AS annual_inc,
 `emp_length`                                      AS emp_length,
 `home_ownership`                                  AS home_ownership,
 SAFE_CAST(`dti` AS FLOAT64)                       AS dti,
 `loan_status`                                     AS loan_status,
 SAFE_CAST(`total_pymnt` AS FLOAT64)               AS total_pymnt,
 SAFE_CAST(`recoveries` AS FLOAT64)                AS recoveries,
 SAFE_CAST(`last_pymnt_d` AS FLOAT64)              AS last_payment_date
FROM `lending_club_raw.loans`;
