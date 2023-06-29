-- most purchased sub-categories of items
SELECT DISTINCT sub_category,
                COUNT(*) OVER(PARTITION BY sub_category) as count
FROM product
ORDER BY count desc

-- Total profit and sales in each year
SELECT order_year,
       SUM(profit) as year_profit,
	   SUM(sales) as year_revenue,
	   ROUND((CAST(SUM(profit) AS FLOAT)/CAST(SUM(sales) AS FLOAT))*100,2) AS profit_margin
FROM orders o JOIN sales s on o.order_id=s.order_id
GROUP BY order_year
ORDER BY profit_margin desc

-- sales, profits, profit margins grouped by markets
SELECT market,
       SUM(profit) as market_profit,
	   SUM(sales) as market_revenue,
	   ROUND((CAST(SUM(profit) AS FLOAT)/CAST(SUM(sales) AS FLOAT))*100,2) AS profit_margin
FROM customer c JOIN sales s on c.order_id=s.order_id
GROUP BY market
ORDER BY profit_margin desc

-- sales percentage by market
SELECT distinct *
FROM   (SELECT market,
       ROUND((CAST(SUM(sales) OVER (PARTITION BY market) AS float) / CAST(SUM(sales) OVER() AS float)) *100 , 2) AS market_sales_percentage
        FROM customer c JOIN sales s ON c.order_id=s.order_id) t
ORDER BY market_sales_percentage

-- Revenue, Profit, Profit margin grouped by markets in given years
SELECT order_year,
       market,
	   CAST (SUM(sales) as float) as t_sales,
	   CAST (SUM(profit) as float) as t_profit,
	   ROUND ((CAST (SUM(profit) as float)/CAST (SUM(sales) as float))*100 ,2) as profit_margin
FROM orders o JOIN sales s on o.order_id= s.order_id 
              JOIN customer c on c.order_id= s.order_id
GROUP BY order_year, market
ORDER BY order_year, profit_margin desc

-- TOP 10 most profitable products
SELECT product_name,
       profited
FROM (SELECT product_name,
       SUM(profit) as profited,
	   RANK() OVER (ORDER BY SUM(profit) DESC) as rankk
      FROM product p LEFT JOIN sales s on p.order_id= s.order_id
      GROUP BY product_name) t
WHERE rankk<=10
ORDER BY rankk

--TOP 10 customers most sold to
SELECT customer_name,
       total_sold
FROM ( SELECT customer_name,
              SUM(sales) as total_sold,
			  RANK() OVER (ORDER BY SUM(sales) DESC) as rankk
	   FROM customer c LEFT JOIN sales s on c.order_id= s.order_id
	   GROUP BY customer_name) t
WHERE rankk<=10
ORDER BY rankk

-- sales by sub_category in given years
SELECT order_year as year,
       sub_category,
       SUM(sales) as sales,
	   SUM(profit) as profit
FROM orders o JOIN product p  on o.order_id=p.order_id
              JOIN sales s on p.order_id=s.order_id
GROUP BY order_year, sub_category
ORDER BY order_year

-- number of orders per country
SELECT country,
       COUNT(*) as count
FROM customer c JOIN orders o on c.order_id= o.order_id
GROUP BY country
ORDER BY count desc

-- number of orders per region
SELECT region,
       COUNT(*) as count
FROM customer c JOIN orders o on c.order_id= o.order_id
GROUP BY region
ORDER BY count desc


-- sales and profit by region in the United States in 2014
SELECT region,
       SUM(sales) as total_sales,
	   SUM(profit) as profit,
	   ROUND(CAST(SUM(profit) AS FLOAT)/(CAST (SUM(sales) AS FLOAT)) *100 ,2) as profit_margin
FROM customer c JOIN sales s on c.order_id= s.order_id
                JOIN orders o on s.order_id= o.order_id
WHERE order_year=2014 AND country='United States'
GROUP BY region
ORDER BY profit_margin DESC

-- classifying order transactions as profitable, unprofitable, break-even
SELECT order_id,
       (CASE WHEN profit>0 THEN 'Profit'
	         WHEN profit <0 THEN 'Loss'
			 WHEN profit=0 THEN 'Break-Even' END) as class
FROM sales

-- counting order transactions according to it being profitable, unprofitable, break-even in USA regions
SELECT country,
       region,
	   SUM(CASE WHEN profit>0 THEN 1 ELSE NULL END) AS profit_count,
	   SUM(CASE WHEN profit<0 THEN 1 ELSE NULL END) AS loss_count,
	   SUM(CASE WHEN profit=0 THEN 1 ELSE NULL END) AS break_even_count
FROM customer c JOIN sales s on c.order_id= s.order_id
WHERE country='United States'
GROUP BY country, region


-- top 10 most expensive countries to ship to
SELECT TOP 10 country,
       ROUND((CAST (sum(shipping_cost) as float))/(CAST (sum(sales) AS float)), 2) as cost_per_revenue_unit
FROM customer c JOIN sales s on c.order_id= s.order_id
GROUP BY country
ORDER BY cost_per_revenue_unit desc

select top 5 * from product

SELECT DISTINCT sub_category,
                COUNT(*) OVER(PARTITION BY sub_category) as count
FROM product
ORDER BY count desc

-- Total sales and profit for product with "samsung" in their names
SELECT SUM(sales) as total_sales,
       SUM(profit) as total_profit
FROM sales s JOIN product p on s.order_id=p.order_id
WHERE lower(product_name) LIKE '%samsung%'

