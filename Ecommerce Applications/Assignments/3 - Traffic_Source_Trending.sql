-- gsearch, nonbrand trended session volume

SELECT   
	MIN(DATE(created_at)) AS week_start_date, 
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE utm_source='gsearch' AND utm_campaign='nonbrand'
AND created_at  < '2012-05-10'
GROUP BY WEEK(created_at)

