-- Step 1:  Find the relevant '/cart' pageviews with website_session_id.

CREATE TEMPORARY TABLE all_sessions AS 

SELECT 
		(CASE 
			WHEN DATE(created_at) < '2013-12-12' THEN 'pre-Birthday-Bear' 
			WHEN DATE(created_at) >= '2013-12-12' THEN 'post-Birthday-Bear'
			END) AS time_period,
		website_session_id
FROM website_sessions
WHERE DATE(created_at) BETWEEN '2013-11-12' AND '2014-01-12';

-- Step 2:  Join the 'orders' table with the 'all_sessions' table

CREATE TEMPORARY TABLE  sessions_with_order_info

SELECT 
	time_period,
    alls.website_session_id,
    order_id,
    primary_product_id,
    items_purchased,
    price_usd,
    cogs_usd
FROM all_sessions alls
LEFT JOIN orders o 
ON alls.website_session_id = o.website_session_id;

--  Step 3:  Aggregate columns in the 'sessions_with_order_info' table to generate desired performace metrics.

SELECT 
		time_period,
		COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id)  AS  session_to_order_conv_rate,
        ROUND(SUM(price_usd) / COUNT(DISTINCT order_id), 2) AS aov,
		ROUND(SUM(items_purchased) / COUNT(DISTINCT order_id), 2) AS products_per_order,
        ROUND(SUM(price_usd) / COUNT(DISTINCT website_session_id),2) AS rev_per_session        
FROM sessions_with_order_info
GROUP BY time_period
ORDER BY time_period DESC
