SELECT *FROM zepto 

--data exploration

--count of rows
select count(*) from zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discount_percentage IS NULL
OR
discounted_selling_price IS NULL
OR
weight_in_gms IS NULL
OR
available_quantity IS NULL
OR
out_of_stock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT out_of_stock, COUNT(sku_id)
FROM zepto
GROUP BY out-of_stock;

--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discounted_selling_price = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discounted_selling_price = discounted_selling_price / 100.0;

SELECT mrp, discounted_selling_price FROM zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
ORDER BY discount_percentage DESC
LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE out_of_stock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discounted_selling_price * available_quantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
WHERE mrp > 500 AND discount_percentage < 10
ORDER BY mrp DESC, discount_percentage DESC;


--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discount_percentage),2) AS average_discount
FROM zepto
GROUP BY category
ORDER BY average_discount DESC
LIMIT 5;


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weight_in_gms, discounted_selling_price,
ROUND(discounted_selling_price/weight_in_gms,2) AS price_per_gram
FROM zepto
WHERE  weight_in_gms >= 100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weight_in_gms,
CASE WHEN weight_in_gms < 1000 THEN 'LOW' 
     WHEN weight_in_gms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

-- Q8. What is the total inventory weight per category?
SELECT category,
SUM(weight_in_gms * available_quantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
