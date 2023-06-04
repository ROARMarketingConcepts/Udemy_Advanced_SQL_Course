SELECT   
	MIN(DATE(created_at)) AS week_start_date, 
	COUNT(CASE WHEN device_type="desktop" THEN device_type ELSE NULL END) AS dtop_sessions,
	COUNT(CASE WHEN device_type="mobile" THEN device_type ELSE NULL END) AS mob_sessions
FROM website_sessions
WHERE utm_source='gsearch' AND utm_campaign='nonbrand'
AND created_at  BETWEEN  '2012-04-15' AND  '2012-06-08'
GROUP BY WEEK(created_at)
