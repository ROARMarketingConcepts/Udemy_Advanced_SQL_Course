WITH daily_hourly_sessions AS 

	(SELECT 
		DATE(created_at) AS date,
		WEEKDAY(created_at) AS weekday,
		HOUR(created_at) AS hour,
		COUNT(DISTINCT website_session_id) AS sessions
	FROM website_sessions
	WHERE DATE(created_at) BETWEEN '2012-09-15' AND '2012-11-15'
	GROUP BY date, weekday, hour)

SELECT
    hour,
    ROUND(AVG(CASE WHEN weekday = 0 THEN sessions ELSE NULL END),1) AS mon,
	ROUND(AVG(CASE WHEN weekday = 1 THEN sessions ELSE NULL END),1) AS tue,
	ROUND(AVG(CASE WHEN weekday = 2 THEN sessions ELSE NULL END),1) AS wed,
	ROUND(AVG(CASE WHEN weekday = 3 THEN sessions ELSE NULL END),1) AS thu,
	ROUND(AVG(CASE WHEN weekday = 4 THEN sessions ELSE NULL END),1) AS fri,
	ROUND(AVG(CASE WHEN weekday = 5 THEN sessions ELSE NULL END),1) AS sat,
	ROUND(AVG(CASE WHEN weekday = 6 THEN sessions ELSE NULL END),1) AS sun
FROM daily_hourly_sessions
GROUP BY hour