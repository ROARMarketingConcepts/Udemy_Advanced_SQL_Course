SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch'  AND device_type='mobile' THEN website_session_id ELSE NULL END) as b_mob_sessions, 
	COUNT(DISTINCT CASE WHEN utm_source='gsearch'  AND device_type='mobile' THEN website_session_id ELSE NULL END) as g_mob_sessions,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch'  AND device_type='mobile' THEN website_session_id ELSE NULL END) /
	COUNT(DISTINCT CASE WHEN utm_source='gsearch'  AND device_type='mobile' THEN website_session_id ELSE NULL END) as b_pct_g_mobile,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch'  AND device_type='desktop' THEN website_session_id ELSE NULL END) as b_dtop_sessions,
    COUNT(DISTINCT CASE WHEN utm_source='gsearch'  AND device_type='desktop' THEN website_session_id ELSE NULL END) as g_dtop_sessions,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch'  AND device_type='desktop' THEN website_session_id ELSE NULL END) /
	COUNT(DISTINCT CASE WHEN utm_source='gsearch'  AND device_type='desktop' THEN website_session_id ELSE NULL END) as b_pct_g_dtop
FROM website_sessions
WHERE utm_campaign='nonbrand'
AND DATE(created_at) BETWEEN '2012-11-04' AND '2012-12-22'
GROUP BY WEEK(created_at);