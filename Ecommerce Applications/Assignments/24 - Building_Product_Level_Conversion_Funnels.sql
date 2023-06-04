-- Step 1:  Find the relevant '/products' pageviews with website_session_id.

CREATE TEMPORARY TABLE product_pageviews AS 

SELECT 
	website_session_id,
    website_pageview_id,
    created_at,
    pageview_url AS product_seen
FROM website_pageviews
WHERE DATE(created_at) BETWEEN '2013-01-07' AND '2013-04-09' 
AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear');

-- Step 2:  Identify each relevant pageview as the specific funnel step.

CREATE TEMPORARY TABLE session_level_made_it AS

	SELECT 
		pp.product_seen,
        wp.website_pageview_id,
        wp.created_at,
        wp.website_session_id,
        wp.pageview_url,
        CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
        CASE WHEN wp.pageview_url = '/the-forever-love-bear' THEN 1 ELSE 0 END AS foreverbear_page,
        CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
		CASE WHEN wp.pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
		CASE WHEN wp.pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
		CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
		FROM product_pageviews pp
		LEFT JOIN website_pageviews wp
		ON pp.website_session_id = wp.website_session_id
        WHERE wp.pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear','/cart','/shipping','/billing-2','/thank-you-for-your-order');
        
        -- Step 3:  Create the session-level conversion funnel view.
        
		CREATE TEMPORARY TABLE conversion_funnel_view
        
        SELECT 
			product_seen,
			website_session_id,
			MAX(mrfuzzy_page) AS mrfuzzy_made_it,
			MAX(foreverbear_page) AS foreverbear_made_it,
			MAX(cart_page) AS cart_made_it,
			MAX(shipping_page) AS shipping_made_it,
			MAX(billing_page) AS billing_made_it,
			MAX(thankyou_page) AS thankyou_made_it
		FROM session_level_made_it
		GROUP BY product_seen,website_session_id;
        
        
-- Step 4:  Aggregate the data to assess funnel performance.
    
SELECT 
	product_seen,
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM conversion_funnel_view
GROUP BY product_seen;
    
-- 4a.  Calculate click-through rates.

    SELECT
		product_seen,
		COUNT(DISTINCT website_session_id) AS sessions,
		COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT website_session_id)  AS product_clickthrough_rate,
		COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough_rate,
        COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough_rate,
        COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) /  COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough_rate
        
	FROM conversion_funnel_view
    GROUP BY product_seen;




