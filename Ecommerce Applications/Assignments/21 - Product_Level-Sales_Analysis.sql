SELECT 
	YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    MONTHNAME(created_at) AS month_name,
	SUM(items_purchased) AS num_sales,
    SUM(price_usd) AS total_revenue,
    SUM(cogs_usd) AS total_cogs,
    SUM(price_usd) - SUM(cogs_usd) AS total_margin
    FROM orders
    WHERE DATE(created_at) < '2013-01-04'
    GROUP BY YEAR(created_at), MONTH(created_at), MONTHNAME(created_at)
    ORDER BY YEAR(created_at), MONTH(created_at)