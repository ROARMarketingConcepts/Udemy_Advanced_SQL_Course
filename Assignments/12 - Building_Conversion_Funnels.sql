-- Demo on Building Conversion Funnels

-- BUSINESS CONTEXT

-- We want to build a mini conversion funnel from /lander-2 to /thankyou.
-- We want to know how many people reach this step and also dropoff rates.
-- We are only considering /lander-2 traffic only.
-- We are also only considering customers who like Mr. Fuzzy

-- Step 1:  Select all pageviews for relevant sessions.
-- Step 2:  Identify each relevant pageview as the specific funnel step.
-- Step 3:  Create the session-level conversion funnel view.
-- Step 4:  Aggregate the data to assess funnel performance.

CREATE TEMPORARY TABLE session_level_made_it AS

	WITH pageview_level AS

		(SELECT 
			ws. website_session_id, wp.pageview_url, wp.created_at AS pageview_created_at,
			CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
			CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
			CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
            CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
            CASE WHEN wp.pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
            CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
		FROM website_sessions ws
		LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
		WHERE wp.created_at BETWEEN '2012-08-05' AND '2012-09-05'
		AND ws.utm_source='gsearch' AND ws.utm_campaign='nonbrand'
		ORDER BY ws.website_session_id, wp.created_at)
    
	SELECT 
		website_session_id,
		MAX(products_page) AS products_made_it,
		MAX(mrfuzzy_page) AS mrfuzzy_made_it,
		MAX(cart_page) AS cart_made_it,
        MAX(shipping_page) AS shipping_made_it,
        MAX(billing_page) AS billing_made_it,
        MAX(thankyou_page) AS thankyou_made_it
		FROM pageview_level
		GROUP BY website_session_id
    ;
    
-- Task 1
    
SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END)  AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
    
    FROM session_level_made_it;
    
-- Task 2
	
    SELECT
    
		COUNT(DISTINCT website_session_id) AS sessions,
		COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS lander_clickthrough_rate,
		COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough_rate,
		COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_clickthrough_rate,
		COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough_rate,
        COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough_rate,
        COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough_rate
        
	FROM session_level_made_it;
    
    