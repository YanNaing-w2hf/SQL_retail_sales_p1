-- DROP TABLE IF EXISTS retail_sales;

-- Creating table
CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(25),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(transactions_id) AS total_sales
FROM retail_sales;

-- How many customer we have? 
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- How many categroies do we have?
SELECT DISTINCT category
FROM retail_sales;

-- Data Analysis & Business Key Problems 
-- (1) Retrieve all columns for sales made on '2022-11-05'
-- (2) Retrieve all transactions where the category is 'clothing' and the quantity sold is more than 3 in the month of November-22.
-- (3) Calculate the total sales for each category
-- (4) Find the average age of customers who purchased items from the 'Beauty Category'
-- (5) Find all the transaction where the total_sale is greater than 1000.
-- (6) Find the total number of transactions made by 'gender' for each 'category'
-- (7) Calculate the average sales for each month. Find out best selling month in each year.
-- (8) Find the top 5 customers based on the highest total sales
-- (9) Find the unique number of customers who purchased items from each category
-- (10) Create Each shift and number of orders



-- (1) Retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- (2) Retrieve all transactions where the category is 'clothing' and the quantity sold is more than 3 in the month of November-22.
SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND sale_date LIKE '2022-11-%' AND quantiy >= 4;

-- (3) Calculate the total sales for each category
SELECT category, SUM(total_sale) AS total_sales, COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY category;

-- (4) Find the average age of customers who purchased items from the 'Beauty Category'
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';

-- (5) Find all the transaction where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- (6) Find the total number of transactions made by 'gender' for each 'category'
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- (7) Calculate the average sales for each month. Find out best selling month in each year.
SELECT year, month, total_sale
FROM
(
	SELECT YEAR(sale_date) as year, MONTH(sale_date) AS month, ROUND(AVG(total_sale), 2) AS total_sale,
	RANK() OVER(PARTITION BY Year(sale_date) ORDER BY AVG(total_sale) DESC) AS best_sale_rank
	FROM retail_sales
	GROUP BY year, month
) AS best_sale_month
WHERE best_sale_rank = 1;

-- (8) Find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_amount
FROM retail_sales
GROUP BY customer_id
ORDER BY total_amount DESC
limit 5;

-- (9) Find the unique number of customers who purchased items from each category
SELECT 
	category,
    COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales
GROUP BY category;

-- (10) Create Each shift and number of orders
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN  'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
    COUNT(*) AS total_transactions
FROM hourly_sale
GROUP BY shift;

-- Project ends here --