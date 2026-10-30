# pharma_sales_analysis (TBC)
Study Case - Analysis of Pharmaceutical Sales of Individual Pharmarcy

**Project Overview**

This project explores pharmaceutical sales data from 2014 to 2019 to identify sales trends, evaluate product category performance, and uncover seasonal patterns.

**Data Quality check conclusions**

Dataset from kaggle.com "Pharma sales data" (https://www.kaggle.com/datasets/milanzdravkovic/pharma-sales-data)

Data from 2019 is incomplete (ending on the 8th of October), so some analysis will be made accordingly: sometimes excluding 2019, or using a like-for-like comparison (years from January to September).

Raw dataset "sales_monthly" is an unreliable dataset, values do not match the rest of the tables, with 8 months differing in total sales (0 total sales in January 2017 for example) therefore all analysis will be made from "sales_daily". 

Selected group of drugs from the dataset is classified to the following Anatomical Therapeutic Chemical (ATC) Classification System categories:

- M01AB - Anti-inflammatory and antirheumatic products, non-steroids, Acetic acid derivatives and related substances
- M01AE - Anti-inflammatory and antirheumatic products, non-steroids, Propionic acid derivatives
- N02BA - Other analgesics and antipyretics, Salicylic acid and derivatives
- N02BE - Other analgesics and antipyretics, Pyrazolones and Anilides
- N05B - Psycholeptics drugs, Anxiolytic drugs
- N05C - Psycholeptics drugs, Hypnotics and sedatives drugs
- R03 - Drugs for obstructive airway diseases
- R06 - Antihistamines for systemic use

------- A COMPLETAR ---------

**1. Which ATC categories concentrate most of the sales?**

A redactar:
- Conclusion (Q1)
- Findings:

-N02BE is the leading category, accounting for 49.38% of total sales, followed by N05B with 14.61%.

-The top 3 categories (N02BE, N05B, R03) reach 73.09% of total sales, indicating a high concentration of sales in a small number of categories.

-N05C is the smallest category, representing only 0.98% of total sales.

**2. How have pharmaceutical sales evolved over the years?**

A redactar:
- Conclusion (Q2)
- Findings:

-Total sales grew from 2014 to 2016 (+12.42% in 2015, +10.91% in 2016).

-Followed by a steep decline of -23.12% YoY growth in 2017. Data does not show the cause.

-2018 rebounded +17.97%, back to the average level of 2014-2016, but still about 9% below the 2016 peak.

-Jan-Sep comparison including 2019:
Sales are flat compared to 2018 (+0.70% YoY growth). This excludes Oct-Dec, so it should not be extrapolated to the full year.

**3. Is there a seasonal pattern in pharmaceutical sales?**

A redactar mejor:
- Conclusion (Q3)
- Findings:
- Monthly trend by total sales:

-Sales show a clear seasonal pattern within the year: winter months concentrate the highest sales. January (seasonal index 126) and December (120) lead the
monthly average, with sales 26% and 20% above the average month, respectively. Summer months concentrate the lowest sales. June (seasonal index 81), July (79) and August (81) show sales around 20% below the average month.

-Colder months in general have a higher seasonal index, with above average sales from October to March, and below average from April to September.
- Monthly trend by category:

-N02BE and R03 accentuate the overall seasonal trend, with sales far below the average month in June, July and August, and sales far above the average month in January and December.

-For N02BE, January (seasonal index 138) and December (133) show sales 38% and 33% above the average month, respectively. While June (67), July (66) and August (69) show sales around 33% below the average month.

-For R03, January (seasonal index 124) and December (144) show sales 24% and 44% above the average month, respectively. while July (54) and August (57) show sales around 46% and 43% below the average month, respectively.

-R06 shows an opposite pattern, January (57) and December (48) show sales 43% and 52% below the average month, respectively. while April (163), May (179) and June (153) show sales 63%, 79% and 53% above the average month, respectively.

**4. Which categories are growing or declining year over year?**

A redactar:
- Conclusion (Q4)
- Findings:
- Growing: R03 (CAGR 20.6%) and R06 (10.6%) show strong YoY growth, their only decline was in 2017 (-11.39% and -7.16%), and 2018 is the year with the highest sales for both.
- Declining: N02BA is the only category in sustained decline (CAGR -8.7%). It grew only in 2016 (+2.90%) and 2018 is the year with the lowest sales.
- Mixed: N02BE (CAGR 4.9%) is highly volatile, with -30.57% in 2017 and +21.30% in 2018. Same for N05C, with swings between -41.68% (2015) and +30.31% (2018).

-M01AB and M01AE peaked in 2016 and have declined or stagnated since, so their positive CAGR (5.4% and 2.5%) overstates their recent trend.

-All 8 categories fell in 2017 (largest drop: N02BE, -30.57%), which points to a common factor. The data does not show its cause.

-Note: CAGR depends on the starting year. The negative CAGR of N05B and N05C is driven by a high 2014 and should be read together with the YoY table.
