SELECT * FROM walmartsales.`walmartsalesdata.csv`;
-- PRODUCT ANALYSIS
-- Categorize time into Morning, Evening and Afternoon and give table name time_category and Alter and Update table. This will help answer the question on which part of the day most sales are made.
SELECT time,
(CASE 
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
END) AS time_category
FROM walmartsales.`walmartsalesdata.csv`;

ALTER TABLE walmartsales.`walmartsalesdata.csv` ADD COLUMN time_category VARCHAR(20);
UPDATE walmartsales.`walmartsalesdata.csv`
SET time_category = (
CASE 
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
END);
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Add a new column named day_name that contains the extracted days of the week on which the given transaction took place(Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

SELECT 
date,
DAYNAME(date) AS day_name
FROM walmartsales.`walmartsalesdata.csv`;

ALTER TABLE walmartsales.`walmartsalesdata.csv` ADD COLUMN day_name VARCHAR(10);
UPDATE walmartsales.`walmartsalesdata.csv`
SET day_name = DAYNAME(date);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place(Jan, Feb, Mar, Aprl). Help determine which month of the year has the most sales and profit.alter
SELECT 
date,
MONTHNAME(date) AS month_name
FROM walmartsales.`walmartsalesdata.csv`;

ALTER TABLE walmartsales.`walmartsalesdata.csv` ADD COLUMN month_name VARCHAR(10);
UPDATE walmartsales.`walmartsalesdata.csv`
SET month_name = MONTHNAME(date);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Generic Questions
-- How many unique cities does the data have?

SELECT
DISTINCT city 
FROM walmartsales.`walmartsalesdata.csv`;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- In which city is each branch
SELECT
DISTINCT branch
FROM walmartsales.`walmartsalesdata.csv`;

SELECT
DISTINCT city,
branch
FROM walmartsales.`walmartsalesdata.csv`;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT 
COUNT(DISTINCT `Product line`)
FROM walmartsales.`walmartsalesdata.csv`;
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the most common payment method?
SELECT
payment,
COUNT(payment) AS cnt
 FROM walmartsales.`walmartsalesdata.csv`
 GROUP BY payment
 ORDER BY cnt DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the most selling product line?
SELECT
`Product line`,
COUNT('Product line') AS cnt
 FROM walmartsales.`walmartsalesdata.csv`
 GROUP BY `Product line`
 ORDER BY cnt DESC;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the total revenue by month?
SELECT
month_name AS month,
SUM(total) AS total_revenue
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY month_name
ORDER By total_revenue DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What month has the largest COGS(cost of goods sold)?
SELECT
month_name AS month,
SUM(cogs) AS cogs
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY month_name
ORDER BY cogs;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What product line had the largest revenue?
SELECT
`Product line`,
SUM(total) AS total_revenue
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY total_revenue DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the city with the largest revenue?

SELECT
branch,
city,
SUM(total) AS total_revenue
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY city, branch
ORDER BY total_revenue DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What product line had the largest VAT?
SELECT
`Product line`,
AVG(`Tax 5%`) AS avg_tax
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY avg_tax DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which branch sold more products than average product sold?
SELECT
branch,
SUM(quantity) AS qty
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY branch
HAVING SUM(quantity)> (SELECT AVG(quantity) FROM walmartsales.`walmartsalesdata.csv`);
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the most common product line by gender?
SELECT
gender,
`Product line`,
COUNT(gender) AS total_cnt
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY gender, `Product line`
ORDER BY total_cnt DESC;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the average rating of each product line?
SELECT
ROUND(AVG(rating), 2) AS avg_rating,
`Product line`
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Product line`
ORDER BY avg_rating DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- SALES ANALYSIS
-- Number of sales made in each time of the day per weekday?
SELECT 
time_category,
COUNT(*) AS total_sales
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY time_category
ORDER BY total_sales DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which of the customer types brings the most revenue?
SELECT
`Customer type`,
SUM(total) AS total_rev
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY total_rev DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which city has the largest VAT?
SELECT
city,
AVG(`Tax 5%`) AS VAT
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY city
ORDER BY AVG(`Tax 5%`) DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which customer type pays the most in VAT?

SELECT
`Customer type`,
AVG(`Tax 5%`) AS VAT
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY AVG(`Tax 5%`) DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMER ANALYSIS

-- How many unique customer types does the data have?
SELECT
DISTINCT `Customer type`
FROM walmartsales.`walmartsalesdata.csv`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- How many unique payment methods does the data have?
SELECT
DISTINCT payment
FROM walmartsales.`walmartsalesdata.csv`;
--------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Which customer type buys the most?
SELECT
`Customer type`,
COUNT(*) AS customer_cnt
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY `Customer type`;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the gender of most of the customers?
SELECT gender,
       COUNT(*) AS gender_cnt
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY gender
ORDER BY gender_cnt DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- What is the gender distribution per branch?
SELECT gender,
       COUNT(*) AS gender_cnt
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT gender,
       COUNT(*) AS gender_cnt
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

SELECT gender,
       COUNT(*) AS gender_cnt
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_cnt DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which time of the day do customers give most ratings?
SELECT 
time_category,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY time_category
ORDER BY avg_rating DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which time of the day do customers give most ratings per branch?
SELECT 
time_category,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY time_category
ORDER BY avg_rating DESC;


SELECT 
time_category,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY time_category
ORDER BY avg_rating DESC;

SELECT 
time_category,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "B"
GROUP BY time_category
ORDER BY avg_rating DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which day of the week has the best avg ratings?
SELECT
day_name,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
GROUP BY day_name
ORDER BY avg_rating DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Which day of the week has the best avg ratings per branch?
SELECT
day_name,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;

SELECT
day_name,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "B"
GROUP BY day_name
ORDER BY avg_rating DESC;


SELECT
day_name,
AVG(rating) AS avg_rating
FROM walmartsales.`walmartsalesdata.csv`
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------