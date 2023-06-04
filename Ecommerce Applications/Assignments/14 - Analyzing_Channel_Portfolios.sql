SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' THEN website_session_id ELSE NULL END) as gsearch_sessions,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch' THEN website_session_id ELSE NULL END) as bsearch_sessions,
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' THEN website_session_id ELSE NULL END) / COUNT(*)  AS pct_gsearch,
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' THEN website_session_id ELSE NULL END) / COUNT(*)  AS pct_bsearch
FROM website_sessions
WHERE utm_source IN ('gsearch','bsearch') AND utm_campaign='nonbrand'
AND DATE(created_at) BETWEEN '2012-08-22' AND '2012-11-28'
GROUP BY WEEK(created_at);