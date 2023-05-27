WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')
    
SELECT 
	YEAR(created_at) AS year,
	MONTH(created_at) AS month,
    MONTHNAME(created_at) AS month_name,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(swo.website_session_id) AS orders,
    COUNT(swo.website_session_id) / COUNT(ws.website_session_id) AS conv_rate
    FROM website_sessions ws
    LEFT JOIN sessions_with_order swo
    ON ws.website_session_id = swo.website_session_id
    WHERE DATE(created_at) < '2013-01-02'
    GROUP BY YEAR(created_at), MONTH(created_at), MONTHNAME(created_at)
    ORDER BY YEAR(created_at),MONTH(created_at);
    
WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')
    
SELECT 
	MIN(DATE(created_at)) AS week_startdate,
	COUNT(ws.website_session_id) AS sessions,
    COUNT(swo.website_session_id) AS orders,
    COUNT(swo.website_session_id) / COUNT(ws.website_session_id) AS conv_rate
    FROM website_sessions ws
    LEFT JOIN sessions_with_order swo
    ON ws.website_session_id = swo.website_session_id
    WHERE DATE(created_at) < '2013-01-02'
    GROUP BY WEEK(created_at)

    