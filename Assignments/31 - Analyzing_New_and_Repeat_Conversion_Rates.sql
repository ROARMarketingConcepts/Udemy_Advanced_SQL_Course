SELECT 
	is_repeat_session,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate,
	SUM(price_usd) / COUNT(DISTINCT ws.website_session_id) AS rev_per_session
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE DATE(ws.created_at) BETWEEN '2014-01-01' AND '2014-11-08'
GROUP BY is_repeat_session