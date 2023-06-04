-- Step 1:  Find the relevant '/cart' pageviews with website_session_id.

CREATE TEMPORARY TABLE cart_sessions AS 

SELECT 
		(CASE 
			WHEN DATE(created_at) < '2013-09-25' THEN 'pre-cross-sell' 
			WHEN DATE(created_at) >= '2013-09-25' THEN 'post-cross-sell'
			END) AS time_period,
		website_session_id,
        website_pageview_id,
		created_at
FROM website_pageviews
WHERE DATE(created_at) BETWEEN '2013-08-25' AND '2013-10-25' 
AND pageview_url = '/cart';

-- Step 2:  Find the next website_pageview_id that occurs AFTER the '/cart' pageview.

CREATE TEMPORARY TABLE  cart_sessions_with_next_pageview

SELECT
	cs.time_period,
    cs.website_session_id,
    MIN(wp.website_pageview_id) AS min_next_pageview_id
FROM cart_sessions cs
LEFT JOIN website_pageviews wp
ON wp.website_session_id = cs.website_session_id
AND wp.website_pageview_id > cs.website_pageview_id  --  look for pageviews AFTER the '/cart' pageview
GROUP BY 1,2;

-- Step 3:  Find the order_id associated with any cart clickthrough.

CREATE TEMPORARY TABLE  cart_sessions_w_order_id

SELECT 
	cswnp.time_period,
    cswnp.website_session_id,
    cswnp.min_next_pageview_id,
    o.order_id
FROM cart_sessions_with_next_pageview cswnp
LEFT JOIN orders o
ON cswnp.website_session_id = o.website_session_id;

-- Step 4: Create a table with all the order info...

CREATE TEMPORARY TABLE order_info_table

SELECT  
		cswoi.*,
        oi.order_item_id,
        oi.product_id,
        oi.is_primary_item,
        oi.price_usd,
        oi.cogs_usd
FROM cart_sessions_w_order_id cswoi
LEFT JOIN order_items oi
ON cswoi.order_id = oi.order_id;

--  Step 5:  Aggregate columns in the order_info_table to generate desired performace metrics.

SELECT 
		time_period,
		COUNT(DISTINCT website_session_id)  AS cart_sessions,
        COUNT(DISTINCT min_next_pageview_id) AS clickthroughs,
        COUNT(DISTINCT min_next_pageview_id) / COUNT(DISTINCT website_session_id) AS ctr,
        COUNT(DISTINCT order_id) AS orders_placed,
        COUNT(product_id) AS products_purchased,
		COUNT(product_id) / COUNT(DISTINCT order_id) AS products_per_order,
        SUM(price_usd) AS revenue, 
        ROUND(SUM(price_usd) / COUNT(DISTINCT order_id), 2) AS aov,
        ROUND(SUM(price_usd) / COUNT(DISTINCT website_session_id),2) AS rev_per_cart_session        
FROM order_info_table
GROUP BY time_period
ORDER BY time_period DESC
