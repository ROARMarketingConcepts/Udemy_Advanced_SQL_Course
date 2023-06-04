SELECT 
	MONTH(created_at) AS month,
	MONTHNAME(created_at) AS month_name,
	COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand'  THEN website_session_id ELSE NULL END) as nonbrand, 
    COUNT(DISTINCT CASE WHEN utm_campaign='brand'  THEN website_session_id ELSE NULL END) as brand, 
    COUNT(DISTINCT CASE WHEN utm_campaign='brand'  THEN website_session_id ELSE NULL END) / 
    COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand'  THEN website_session_id ELSE NULL END)  AS brand_pct_of_nonbrand,
	COUNT(DISTINCT CASE WHEN http_referer IS NULL THEN website_session_id ELSE NULL END) as direct, 
	COUNT(DISTINCT CASE WHEN http_referer IS NULL THEN website_session_id ELSE NULL END) / 
    COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand'  THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id ELSE NULL END) as organic, 
	COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id ELSE NULL END)  / 
    COUNT(DISTINCT CASE WHEN utm_campaign='nonbrand'  THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
FROM website_sessions
WHERE DATE(created_at) < '2012-12-23'
GROUP BY MONTH(created_at), MONTHNAME(created_at)
ORDER BY MONTH(created_at)
