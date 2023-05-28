SELECT 
	MONTH(ws.created_at) AS month,
    YEAR(ws.created_at) AS year,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate,
    SUM(price_usd) / COUNT(ws.website_session_id) AS revenue_per_session,
	COUNT(CASE WHEN primary_product_id = 1 THEN primary_product_id ELSE NULL END) AS product_one_orders,
    COUNT(CASE WHEN primary_product_id = 2 THEN primary_product_id ELSE NULL END) AS product_two_orders
FROM website_sessions ws
LEFT JOIN orders o 
ON ws.website_session_id = o.website_session_id
WHERE DATE(ws.created_at) BETWEEN '2012-04-01' AND '2013-04-05'
GROUP BY YEAR (created_at), MONTH(created_at)
