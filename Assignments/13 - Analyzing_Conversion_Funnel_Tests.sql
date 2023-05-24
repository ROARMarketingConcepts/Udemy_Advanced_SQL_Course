WITH sessions_ids_by_billing_version_seen AS

	(SELECT 
		pageview_url AS billing_version_seen, 
		website_session_id
	FROM website_pageviews
	WHERE pageview_url IN ('/billing','/billing-2') 
	AND DATE(created_at) BETWEEN '2012-09-10' AND '2012-11-10'
	ORDER BY billing_version_seen, website_session_id),
    
pageviews_by_session AS
   
	(SELECT 
		a.billing_version_seen, 
		a.website_session_id, 
		b.website_pageview_id,
		b.pageview_url
	FROM sessions_ids_by_billing_version_seen a
	INNER JOIN website_pageviews b
	ON a.website_session_id = b.website_session_id)
    
    
SELECT 
	billing_version_seen, 
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(CASE WHEN pageview_url='/thank-you-for-your-order' THEN pageview_url ELSE NULL END) AS orders,
	COUNT(CASE WHEN pageview_url='/thank-you-for-your-order' THEN pageview_url ELSE NULL END) / COUNT(DISTINCT website_session_id)  AS billing_to_order_rt
    FROM pageviews_by_session
    GROUP BY billing_version_seen
