-- Bid Optimization for Paid Traffic

SELECT 
		utm_source,
		utm_campaign,
        device_type,
		COUNT(DISTINCT  ws.website_session_id) AS sessions, 
		COUNT(DISTINCT o.order_id) AS orders,
		COUNT(DISTINCT order_id)/COUNT(DISTINCT  ws.website_session_id)  AS cvr
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE utm_source='gsearch' AND utm_campaign='nonbrand'
AND DATE(ws. created_at) < '2012-05-11'
GROUP BY device_type

