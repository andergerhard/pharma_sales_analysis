-- 02. Data Quality Check

-- Objective: Check for anomalies in raw data before cleaning

-- Input: sales_daily_raw, sales_hourly_raw, sales_weekly_raw, sales_monthly_raw

-- Summary of findings:
--   - No duplicates, nulls or negative values.
--   - Starts on Jan 2 2014 and ends on Oct 8 2019 (incomplete year).
--   - Hourly, daily and weekly totals match, the monthly table does not. Monthly and YoY analysis will be built from the daily table.

-- ------------------------------------------------------
-- 1. Full data check on sales_daily_raw

-- == A.Row count and date range

SELECT COUNT(*) AS n_rows,
	MIN(TO_DATE(datum, 'MM/DD/YYYY')) AS first_date,
	MAX(TO_DATE(datum, 'MM/DD/YYYY')) AS last_date
FROM sales_daily_raw;

-- == B. Duplicated dates

SELECT datum, COUNT(*) FROM sales_daily_raw
GROUP BY datum
HAVING count(*) > 1;

-- == C. Identical rows

SELECT COUNT(*) - COUNT(DISTINCT sales_daily_raw.*) AS n_identical_duplicates
FROM sales_daily_raw;

-- == D. Nulls per column

SELECT
    COUNT(*) FILTER (WHERE datum IS NULL) AS null_datum,
    COUNT(*) FILTER (WHERE m01ab IS NULL) AS null_m01ab,
    COUNT(*) FILTER (WHERE m01ae IS NULL) AS null_m01ae,
    COUNT(*) FILTER (WHERE n02ba IS NULL) AS null_n02ba,
    COUNT(*) FILTER (WHERE n02be IS NULL) AS null_n02be,
    COUNT(*) FILTER (WHERE n05b IS NULL) AS null_n05b,
    COUNT(*) FILTER (WHERE n05c IS NULL) AS null_n05c,
    COUNT(*) FILTER (WHERE r03 IS NULL) AS null_r03,
    COUNT(*) FILTER (WHERE r06 IS NULL) AS null_r06
FROM sales_daily_raw;

-- == E. Negative values (should not exist in number of sales)

SELECT COUNT(*) as n_negatives
FROM sales_daily_raw
WHERE m01ab<0 OR m01ae<0 OR n02ba<0 OR n02be<0 OR n05b<0 OR n05c<0 OR r03<0 OR r06<0

-- == F. Rows per year (show incomplete years)

SELECT year, COUNT(*) AS n_days
FROM sales_daily_raw
GROUP BY year
ORDER BY year;

-- 2. Basic data check on hourly/weekly/monthly tables

-- == A.Row count and date range

SELECT 'hourly' AS table, COUNT(*) AS n_rows,
	MIN(TO_DATE(datum, 'MM/DD/YYYY')) AS first_date,
	MAX(TO_DATE(datum, 'MM/DD/YYYY')) AS last_date
FROM sales_hourly_raw
UNION ALL
SELECT 'weekly', COUNT(*),
	MIN(TO_DATE(datum, 'MM/DD/YYYY')),
	MAX(TO_DATE(datum, 'MM/DD/YYYY'))
FROM sales_weekly_raw
UNION ALL
SELECT 'monthly', COUNT(*),
	MIN(TO_DATE(datum, 'YYYY/MM/DD')),
	MAX(TO_DATE(datum, 'YYYY/MM/DD'))
FROM sales_monthly_raw;

-- == B. Duplicated dates

SELECT 'hourly' AS table, datum, COUNT(*) FROM sales_hourly_raw
GROUP BY datum
HAVING count(*) > 1
UNION ALL
SELECT 'weekly', datum, COUNT(*) FROM sales_weekly_raw
GROUP BY datum
HAVING count(*) > 1
UNION ALL
SELECT 'monthly', datum, COUNT(*) FROM sales_monthly_raw
GROUP BY datum
HAVING count(*) > 1;

-- == C. Nulls in table
SELECT *
FROM sales_daily_raw
WHERE datum IS NULL
   OR m01ab IS NULL
   OR m01ae IS NULL
   OR n02ba IS NULL
   OR n02be IS NULL
   OR n05b IS NULL
   OR n05c IS NULL
   OR r03 IS NULL
   OR r06 IS NULL
   OR year IS NULL
   OR month is NULL
   OR hour is NULL
   OR weekday_name is NULL;

SELECT *
FROM sales_weekly_raw
WHERE datum IS NULL
   OR m01ab IS NULL
   OR m01ae IS NULL
   OR n02ba IS NULL
   OR n02be IS NULL
   OR n05b IS NULL
   OR n05c IS NULL
   OR r03 IS NULL
   OR r06 IS NULL;

SELECT *
FROM sales_monthly_raw
WHERE datum IS NULL
   OR m01ab IS NULL
   OR m01ae IS NULL
   OR n02ba IS NULL
   OR n02be IS NULL
   OR n05b IS NULL
   OR n05c IS NULL
   OR r03 IS NULL
   OR r06 IS NULL;

-- 3. Coherence between tables

SELECT 'hourly' AS table, SUM(m01ab) FROM sales_hourly_raw
UNION ALL
SELECT 'daily', SUM(m01ab) FROM sales_daily_raw
UNION ALL
SELECT 'weekly', SUM(m01ab) FROM sales_weekly_raw
UNION ALL
SELECT 'monthly', SUM(m01ab) FROM sales_monthly_raw;

--- Monthly table total doesn't match the other three tables (~101.5 lower).
--- Compare it against the daily table month by month to locate the mismatches.

WITH d AS(
	SELECT
		DATE_TRUNC('month',TO_DATE(datum, 'MM/DD/YYYY'))::date AS months,
		SUM(m01ab) AS total_daily
	FROM sales_daily_raw
	GROUP BY months
),
m AS(
	SELECT
		DATE_TRUNC('month', TO_DATE(datum, 'YYYY/MM/DD'))::date AS months,
		m01ab AS total_monthly
	FROM sales_monthly_raw
)

SELECT
	COALESCE(d.months,m.months),
	ROUND(d.total_daily::numeric, 2) AS total_daily,
	ROUND(m.total_monthly::numeric, 2) AS total_monthly,
	ROUND(d.total_daily - m.total_monthly::numeric,2) AS difference
FROM d
FULL JOIN m ON d.months = m.months
WHERE d.months IS NULL OR m.months IS NULL
	OR ABS(d.total_daily - m.total_monthly) > 0.01
ORDER BY d.months;

--- Result: 8 months differ (Jan 2017 is 0 in the monthly table), monthly table is unreliable.
--- Decision: monthly analysis and YoY analysis will be built from the daily table.