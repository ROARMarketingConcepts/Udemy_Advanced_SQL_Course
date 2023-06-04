WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')

SELECT 
	device_type, utm_source,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT swo.website_session_id) AS orders,
    COUNT(DISTINCT swo.website_session_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate
    FROM website_sessions ws
LEFT JOIN sessions_with_order swo
ON ws.website_session_id = swo.website_session_id
WHERE utm_source IN ('gsearch','bsearch') AND utm_campaign='nonbrand'
AND DATE(created_at) BETWEEN '2012-08-22' AND '2012-09-18'
GROUP BY device_type, utm_source;