SELECT 
	utm_source,
    COUNT(*) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) as mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) / COUNT(*)  AS pct_mobile
FROM website_sessions
WHERE utm_source IN ('gsearch','bsearch') AND utm_campaign='nonbrand'
AND DATE(created_at) BETWEEN '2012-08-22' AND '2012-11-29'
GROUP BY utm_source;