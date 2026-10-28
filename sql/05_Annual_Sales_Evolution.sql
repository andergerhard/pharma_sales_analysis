-- ====================================================
-- Q2. How have pharmaceutical sales evolved over the years?
-- ====================================================

-- 1. Yearly Sales Overview

SELECT EXTRACT(Year FROM datum) AS year,
	ROUND(SUM(m01ab + m01ae + n02ba + n02be + n05b + n05c + r03 + r06)) AS total_sales
FROM sales_daily
GROUP BY 1
ORDER BY 1;

-- 2. Year-over-Year Growth (excluding 2019, incomplete year)

WITH yearly_sales AS(
SELECT 
	EXTRACT(Year FROM datum) AS year,
	SUM(m01ab + m01ae + n02ba + n02be + n05b + n05c + r03 + r06) AS total_sales
FROM sales_daily
WHERE EXTRACT(Year FROM datum) < 2019
GROUP BY 1
),
yearly_comparison AS(
SELECT
	year, 
	total_sales,
	LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales
FROM yearly_sales
)

SELECT 
	year,
	ROUND(total_sales) AS total_sales, 
	ROUND(previous_year_sales) AS previous_year_sales,
	ROUND(
		(total_sales - previous_year_sales)
		/ NULLIF(previous_year_sales,0) * 100 ,2
	) AS yoy_growth_pct
FROM yearly_comparison
ORDER BY year;

-- 3. Year-over-Year Growth (Jan-Sept comparison to include 2019)

WITH yearly_sales AS(
SELECT 
	EXTRACT(Year FROM datum) AS year,
	SUM(m01ab + m01ae + n02ba + n02be + n05b + n05c + r03 + r06) AS total_sales
FROM sales_daily
WHERE EXTRACT(Month FROM datum) < 10
GROUP BY 1
),
yearly_comparison AS(
SELECT 
	year, 
	total_sales,
	LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales
FROM yearly_sales
)

SELECT 
	year,
	ROUND(total_sales) AS total_sales, 
	ROUND(previous_year_sales) AS previous_year_sales,
	ROUND(
		(total_sales - previous_year_sales)
		/ NULLIF(previous_year_sales,0) * 100 ,2
		) AS yoy_growth_pct
FROM yearly_comparison
ORDER BY year;

-- Conclusion (Q2)
-- Findings:
--   Total sales grew from 2014 to 2016 (+12.42% in 2015, +10.91% in 2016).
--   Followed by a steep decline of -23.12% YoY growth in 2017. Data does not show the cause.
--   2018 rebounded +17.97%, back to the average level of 2014-2016, but still
--   about 9% below the 2016 peak.
--   Jan-Sep comparison including 2019:
--   Sales are flat compared to 2018 (+0.70% YoY growth). This excludes Oct-Dec, 
--   so it should not be extrapolated to the full year.