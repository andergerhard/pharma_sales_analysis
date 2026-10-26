-- 03. Create clean tables

CREATE TABLE sales_hourly AS
SELECT
    TO_TIMESTAMP(datum, 'MM/DD/YYYY HH24:MI')::TIMESTAMP AS datum,
    m01ab,
    m01ae,
    n02ba,
    n02be,
    n05b,
    n05c,
    r03,
    r06,
    year,
    month,
    hour,
    weekday_name
FROM sales_hourly_raw;

CREATE TABLE sales_daily AS
SELECT
    TO_DATE(datum, 'MM/DD/YYYY') AS datum,
    m01ab,
    m01ae,
    n02ba,
    n02be,
    n05b,
    n05c,
    r03,
    r06,
    year,
    month,
    weekday_name
FROM sales_daily_raw;

CREATE TABLE sales_weekly AS
SELECT
    TO_DATE(datum, 'MM/DD/YYYY') AS datum,
    m01ab,
    m01ae,
    n02ba,
    n02be,
    n05b,
    n05c,
    r03,
    r06
FROM sales_weekly_raw;

CREATE TABLE sales_monthly AS
SELECT
    TO_DATE(datum, 'YYYY//MM/DD') AS datum,
    m01ab,
    m01ae,
    n02ba,
    n02be,
    n05b,
    n05c,
    r03,
    r06
FROM sales_monthly_raw;