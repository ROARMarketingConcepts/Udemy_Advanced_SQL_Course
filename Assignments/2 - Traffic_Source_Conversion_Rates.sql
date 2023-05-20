-- Get conversion rate for gsearch nonbrand channel.  Need a CVR of >=4% 

SELECT  
		utm_source,
		utm_campaign,
		COUNT(DISTINCT  w.website_session_id) AS sessions, 
		COUNT(DISTINCT o.order_id) AS orders,
		COUNT(DISTINCT order_id)/COUNT(DISTINCT  w.website_session_id)  AS cvr
FROM website_sessions w
LEFT JOIN orders o
ON w.website_session_id = o.website_session_id
WHERE 
		DATE(w.created_at) < '2012-04-14' AND
		utm_source = 'gsearch' AND
		utm_campaign = 'nonbrand'
GROUP BY utm_source,utm_campaign


