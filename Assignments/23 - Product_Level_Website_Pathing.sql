-- Step 1:  Find the relevant '/products' pageviews with website_session_id.

CREATE TEMPORARY TABLE products_pageviews AS 

SELECT 
	website_session_id,
    website_pageview_id,
    created_at,
	(CASE 
		WHEN DATE(created_at) <= '2013-01-05' THEN 'pre-product-2' 
		WHEN DATE(created_at) >= '2013-01-06' THEN 'post-product-2'
		END) AS time_period
FROM website_pageviews
WHERE DATE(created_at) BETWEEN '2012-10-06' AND '2013-04-06' 
AND pageview_url = '/products';

-- Step 2:  Find the next website_pageview_id that occurs AFTER the '/products' pageview.

CREATE TEMPORARY TABLE  sessions_with_next_pageview

SELECT
	pv.time_period,
    pv.website_session_id,
    MIN(wp.website_pageview_id) AS min_next_pageview_id
FROM products_pageviews pv
LEFT JOIN website_pageviews wp
ON wp.website_session_id = pv.website_session_id
AND wp.website_pageview_id > pv.website_pageview_id  --  look for pageviews AFTER the '/products' pageview
GROUP BY 1,2;

-- Step 3:  Find the pageview_url associated with any applicable new website_pageview_id.

CREATE TEMPORARY TABLE  sessions_next_pageview_url

SELECT 
	time_period,
    swnp.website_session_id,
    min_next_pageview_id,
    pageview_url
FROM sessions_with_next_pageview swnp
LEFT JOIN website_pageviews wp
ON swnp.min_next_pageview_id = wp.website_pageview_id;

-- Step 4:  Summarize the data and analyze the pre- and post- period. 

SELECT 
	time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT min_next_pageview_id) AS sessions_w_next_pageview,
    COUNT(DISTINCT min_next_pageview_id)  / COUNT(DISTINCT website_session_id) AS pct_w_next_page,
    COUNT(CASE WHEN pageview_url LIKE '/the-original-mr-fuzzy' THEN pageview_url ELSE NULL END) AS to_mrfuzzy,
    COUNT(CASE WHEN pageview_url LIKE '/the-original-mr-fuzzy' THEN pageview_url ELSE NULL END) 
    / COUNT(DISTINCT website_session_id) AS pct_mrfuzzy,
    COUNT(CASE WHEN pageview_url LIKE '/the-forever-love-bear' THEN pageview_url ELSE NULL END) AS to_foreverlovebear,
    COUNT(CASE WHEN pageview_url LIKE '/the-forever-love-bear' THEN pageview_url ELSE NULL END) 
    / COUNT(DISTINCT website_session_id) AS pct_forevercarebear
FROM sessions_next_pageview_url
GROUP BY time_period
ORDER BY time_period DESC
	





