-- =============================================================
-- Q4. Which categories are growing or declining year over year?
-- =============================================================

-- 1. Year-over-Year Growth by category (excluding 2019, incomplete year)

WITH yearly_sales AS (
SELECT year,
	SUM(m01ab) AS m01ab,
	SUM(m01ae) AS m01ae,
	SUM(n02ba) AS n02ba,
	SUM(n02be) AS n02be,
	SUM(n05b) AS n05b,
	SUM(n05c) AS n05c,
	SUM(r03) AS r03,
	SUM(r06) AS r06
FROM sales_daily
WHERE year < 2019
GROUP BY year
),
sales_by_category AS(
SELECT 
	y.year,
	c.category,
	c.sales
FROM yearly_sales y
CROSS JOIN LATERAL(
	VALUES
		('M01AB',y.m01ab),
		('M01AE',y.m01ae),
		('N02BA', y.n02ba),
		('N02BE', y.n02be),
		('N05B', y.n05b),
		('N05C', y.n05c),
		('R03', y.r03),
		('R06', y.r06)
) AS c(category,sales)
),yearly_comparison AS(
SELECT
	year,
	category,
	sales,
	LAG(sales) OVER (PARTITION BY category ORDER BY year) AS previous_year_sales
FROM sales_by_category
)

SELECT
	year,
	category,
	ROUND(sales,2) AS sales,
	ROUND(previous_year_sales,2) AS previous_year_sales,
	ROUND(
		(sales-previous_year_sales) 
		/ NULLIF(previous_year_sales,0) * 100, 2) AS yoy_growth_pct
FROM yearly_comparison
ORDER BY category, year;

-- 2. Compound Annual Growth Rate (CAGR) by category (excluding 2019, incomplete year)

WITH yearly_sales AS (
SELECT year,
	SUM(m01ab) AS m01ab,
	SUM(m01ae) AS m01ae,
	SUM(n02ba) AS n02ba,
	SUM(n02be) AS n02be,
	SUM(n05b) AS n05b,
	SUM(n05c) AS n05c,
	SUM(r03) AS r03,
	SUM(r06) AS r06
FROM sales_daily
WHERE year < 2019
GROUP BY year
),
sales_by_category AS(
SELECT 
	y.year,
	c.category,
	c.sales
FROM yearly_sales y
CROSS JOIN LATERAL(
	VALUES
		('M01AB',y.m01ab),
		('M01AE',y.m01ae),
		('N02BA', y.n02ba),
		('N02BE', y.n02be),
		('N05B', y.n05b),
		('N05C', y.n05c),
		('R03', y.r03),
		('R06', y.r06)
) AS c(category,sales)
)

SELECT
	category,
	ROUND(100 * (POWER(
		MAX(sales) FILTER (WHERE year = 2018)
		/ MAX(sales) FILTER (WHERE year = 2014),
		1.0 / 4) - 1), 1) AS cagr_pct
FROM sales_by_category
GROUP BY category
ORDER BY cagr_pct DESC;
	
-- Conclusion (Q4)
-- Findings:
--   Growing: R03 (CAGR 20.6%) and R06 (10.6%) show strong YoY growth,
--   their only decline was in 2017 (-11.39% and -7.16%), and 2018 is the year with the
--   highest sales for both.
--   Declining: N02BA is the only category in sustained decline (CAGR -8.7%).
--   It grew only in 2016 (+2.90%) and 2018 is the year with the lowest sales.
--   Mixed: N02BE (CAGR 4.9%) is highly volatile, with -30.57% in 2017 and +21.30%
--   in 2018. Same for N05C, with swings between -41.68% (2015) and +30.31% (2018).
--   M01AB and M01AE peaked in 2016 and have declined or stagnated since, so their positive
--   CAGR (5.4% and 2.5%) overstates their recent trend.
--   All 8 categories fell in 2017 (largest drop: N02BE, -30.57%), which points to
--   a common factor. The data does not show its cause.
-- Note: CAGR depends on the starting year. The negative CAGR of N05B and N05C is
--   driven by a high 2014 and should be read together with the YoY table.
	
	