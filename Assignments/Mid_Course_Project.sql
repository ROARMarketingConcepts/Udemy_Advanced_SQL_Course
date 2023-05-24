-- Mid-Course Project

-- Task 1: Gsearch seems to be the biggest driver of our business. Could you pull
-- monthly trends for gsearch session and orders so that we can showcase the growth there?

SELECT   
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE utm_source='gsearch' 
AND created_at  < '2012-11-27'
GROUP BY month_num, month
ORDER BY month_num