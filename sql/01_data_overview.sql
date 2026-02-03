# check for null rows
SELECT *
FROM `lending_club_raw.loans_clean`
WHERE loan_amnt IS NULL or
funded_amnt IS NULL or
int_rate_pct IS NULL or
term_months IS NULL or
grade IS NULL or
sub_grade IS NULL or
purpose IS NULL or
issue_date IS NULL or
annual_inc IS NULL or
emp_length IS NULL or
home_ownership IS NULL or
dti IS NULL or
loan_status IS NULL or
total_pymnt IS NULL or
recoveries IS NULL;

SELECT COUNT(*)
FROM `lending_club_raw.loans_clean`;

SELECT MIN(loan_amnt), MAX(loan_amnt)
FROM `lending_club_raw.loans_clean`;

SELECT MIN(int_rate_pct), MAX(int_rate_pct)
FROM `lending_club_raw.loans_clean`;

SELECT DISTINCT term_months
FROM `lending_club_raw.loans_clean`
WHERE term_months IS NOT NULL;

SELECT DISTINCT purpose, count(*) AS count
FROM `lending_club_raw.loans_clean`
WHERE purpose IS NOT NULL
GROUP BY purpose
ORDER BY count DESC;

SELECT MIN(annual_inc), MAX(annual_inc)
FROM `lending_club_raw.loans_clean`;

SELECT DISTINCT emp_length
FROM `lending_club_raw.loans_clean`;

SELECT MIN(dti), MAX(dti)
FROM `lending_club_raw.loans_clean`;

SELECT DISTINCT home_ownership
FROM `lending_club_raw.loans_clean`
WHERE home_ownership IS NOT NULL;

SELECT loan_status, COUNT(*) AS occurences
FROM `lending_club_raw.loans_clean`
WHERE loan_status IS NOT NULL
GROUP BY loan_status
ORDER BY occurences DESC; 

SELECT MIN(total_pymnt), MAX(total_pymnt)
FROM `lending_club_raw.loans_clean`;

SELECT MIN(recoveries), MAX(recoveries)
FROM `lending_club_raw.loans_clean`;

SELECT loan_status, COUNT(*), (COUNT(*) / (SELECT COUNT(*) FROM `lending_club_raw.loans_clean`)) * 100 AS `percent_of_total_loans`
FROM `lending_club_raw.loans_clean`
GROUP BY loan_status
ORDER BY percent_of_total_loans;

SELECT grade, COUNT(*) AS occurences
FROM `lending_club_raw.loans_clean`
WHERE grade IS NOT NULL
GROUP BY grade
ORDER BY occurences DESC; 
