CREATE TEMPORARY TABLE first_pageview

SELECT website_session_id, MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE DATE(created_at) < '2012-06-12'
GROUP BY website_session_id;


SELECT  wpv.pageview_url AS entry_page,
COUNT(DISTINCT fpv.website_session_id) AS sessions_hitting_entry_page
FROM first_pageview fpv 
LEFT JOIN website_pageviews wpv
ON fpv.min_pv_id = wpv.website_pageview_id
GROUP BY entry_page

