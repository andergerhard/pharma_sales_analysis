-- Q1. Which ATC categories concentrate most of the sales?
-- Data: sales_daily, full period (2014 - Oct 2019)

WITH per_category AS(
SELECT 'M01AB' AS category, SUM(m01ab) AS total FROM sales_daily
UNION ALL
SELECT 'M01AE', SUM(m01ae) FROM sales_daily
UNION ALL
SELECT 'N02BA', SUM(n02ba) FROM sales_daily
UNION ALL
SELECT 'N02BE', SUM(n02be) FROM sales_daily
UNION ALL
SELECT 'N05B', SUM(n05b) FROM sales_daily
UNION ALL
SELECT 'N05C', SUM(n05c) FROM sales_daily
UNION ALL
SELECT 'R03', SUM(r03) FROM sales_daily
UNION ALL
SELECT 'R06', SUM(r06) FROM sales_daily
),
with_pct AS(
SELECT category,
	total,
	total / SUM(total) OVER() * 100 AS percentage
FROM per_category
)

SELECT category,
	ROUND(total,2) AS total,
	ROUND(percentage,2) AS percentage,
	ROUND(SUM(percentage) OVER(ORDER BY total DESC),2) AS cumulative_pct
FROM with_pct
ORDER BY total DESC;

-- Conclusion (Q1)
-- Findings:
--   N02BE is the leading category, accounting for 49.38% of total sales,
--   followed by N05B with 14.61%.
--   The top 3 categories (N02BE, N05B, R03) reach 73.09% of total sales,
--   indicating a high concentration of sales in a small number of categories.
--   N05C is the smallest category, representing only 0.98% of total sales.