SELECT utm_content, COUNT(DISTINCT ws.website_session_id) AS sessions, COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id)/COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE  ws.website_session_id BETWEEN 1000 AND 2000
GROUP BY 1
ORDER BY 3 DESC
