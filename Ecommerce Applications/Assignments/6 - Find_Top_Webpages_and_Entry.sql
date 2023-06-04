

SELECT pageview_url, COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE DATE(created_at) < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC