-- 01. Create tables
-- Raw data tables from csv files

CREATE TABLE sales_hourly_raw(
	datum TEXT,
	m01ab NUMERIC,
    m01ae NUMERIC,
    n02ba NUMERIC,
    n02be NUMERIC,
    n05b NUMERIC,
    n05c NUMERIC,
    r03 NUMERIC,
    r06 NUMERIC,
	year INTEGER,
	month INTEGER,
	hour INTEGER,
	weekday_name TEXT
);

CREATE TABLE sales_daily_raw(
	datum TEXT,
	m01ab NUMERIC,
    m01ae NUMERIC,
    n02ba NUMERIC,
    n02be NUMERIC,
    n05b NUMERIC,
    n05c NUMERIC,
    r03 NUMERIC,
    r06 NUMERIC,
	year INTEGER,
	month INTEGER,
	hour INTEGER,
	weekday_name TEXT
);

CREATE TABLE sales_weekly_raw(
	datum TEXT,
	m01ab NUMERIC,
    m01ae NUMERIC,
    n02ba NUMERIC,
    n02be NUMERIC,
    n05b NUMERIC,
    n05c NUMERIC,
    r03 NUMERIC,
    r06 NUMERIC
);

CREATE TABLE sales_monthly_raw(
	datum TEXT,
	m01ab NUMERIC,
    m01ae NUMERIC,
    n02ba NUMERIC,
    n02be NUMERIC,
    n05b NUMERIC,
    n05c NUMERIC,
    r03 NUMERIC,
    r06 NUMERIC
);