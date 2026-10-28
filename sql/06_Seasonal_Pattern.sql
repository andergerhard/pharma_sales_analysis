-- ========================================================
-- Q3. Is there a seasonal pattern in pharmaceutical sales?
-- ========================================================

-- 1. Seasonal pattern in total sales throughout the years 

SELECT
	year,
	month,
	TO_CHAR(datum,'FMMonth') as month_name,
	ROUND(SUM(m01ab + m01ae + n02ba + n02be + n05b + n05c + r03 + r06),2) AS total_sales
FROM sales_daily
WHERE DATE_TRUNC('month',datum)::date != '2019-10-01'
GROUP BY year,month,month_name
ORDER BY year,month;

-- 2. Seasonal pattern by ATC category

SELECT
	year,
	month,
	TO_CHAR(datum,'FMMonth') as month_name,
	SUM(m01ab) AS m01ab,
	SUM(m01ae) AS m01ae,
	SUM(n02ba) AS n02ba,
	SUM(n02be) AS n02be,
	SUM(n05b) AS n05b,
	SUM(n05c) AS n05c,
	SUM(r03) AS r03,
	SUM(r06) AS r06
FROM sales_daily
WHERE DATE_TRUNC('month',datum)::date != '2019-10-01'
GROUP BY year,month,month_name
ORDER BY year,month;

-- 3. Monthly seasonal index for total sales

WITH monthly_sales AS(
SELECT
	year,
	month,
	TO_CHAR(datum,'FMMonth') as month_name,
	SUM(m01ab + m01ae + n02ba + n02be + n05b + n05c + r03 + r06) AS year_month_sales
FROM sales_daily
WHERE DATE_TRUNC('month',datum)::date != '2019-10-01'
GROUP BY year,month,month_name
),
monthly_average AS(
SELECT
	month,
	month_name,
	AVG(year_month_sales) AS average_sales
FROM monthly_sales
GROUP BY month,month_name
)

SELECT
	month,
	month_name,
	ROUND(average_sales,2) AS average_sales,
	ROUND(average_sales / AVG(average_sales) OVER() * 100) AS seasonal_index
FROM monthly_average
ORDER BY month;

-- 4. Monthly seasonal index by ATC category

WITH monthly_sales AS(
SELECT
	year,
	month,
	TO_CHAR(datum,'FMMonth') as month_name,
	SUM(m01ab) AS m01ab,
	SUM(m01ae) AS m01ae,
	SUM(n02ba) AS n02ba,
	SUM(n02be) AS n02be,
	SUM(n05b) AS n05b,
	SUM(n05c) AS n05c,
	SUM(r03) AS r03,
	SUM(r06) AS r06
FROM sales_daily
WHERE DATE_TRUNC('month',datum)::date != '2019-10-01'
GROUP BY year,month,month_name
),
sales_by_category AS(
SELECT 
	m.year,
	m.month,
	m.month_name,
	c.category,
	c.sales 
FROM monthly_sales m
CROSS JOIN LATERAL (
	VALUES
		('M01AB', m.m01ab),
        ('M01AE', m.m01ae),
        ('N02BA', m.n02ba),
		('N02BE', m.n02be),
		('N05B', m.n05b),
		('N05C', m.n05c),
		('R03', m.r03),
		('R06', m.r06)
)AS c(category, sales)
),
monthly_average AS(
SELECT
	month,
	month_name,
	category,
	AVG(sales) AS average_sales
FROM sales_by_category
GROUP BY month,month_name,category
)

SELECT
	month,
	month_name,
	category,
	ROUND(average_sales,2) AS average_sales,
	ROUND(average_sales / 
		AVG(average_sales) OVER(PARTITION BY Category)
		* 100) AS seasonal_index
FROM monthly_average
ORDER BY category,month;

-- Conclusion (Q3)
-- Findings:
--   Total sales show a clear seasonality: above the average month from October
--   to March (peaks in January, index 126, and December, 120) and below it from
--   April to September (lows in June-August, index 79-81).
--   N02BE and R03 follow and amplify this pattern (January/December indices of
--   124-144, summer lows of 54-69). R06 is counter-seasonal: lowest in winter
--   (December 48, January 57) and highest in spring (May 179).
--   Month-by-month indices per category are in the README.