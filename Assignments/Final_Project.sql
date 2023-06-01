-- 1.  I’d like to show our volume growth. Can you pull overall session and order volume, trended by quarter
-- 		for the life of the business? Since the most recent quarter is incomplete, you can decide how to handle it. 

SELECT 
	YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE DATE(ws.created_at) < '2015-03-15'
GROUP BY year, quarter;

-- 2.  Next, let’s showcase all of our efficiency improvements. I would love to show quarterly figures since we
-- 		launched, for session to order conversion rate, revenue per order, and revenue per session. 

SELECT 
	YEAR(ws.created_at) AS year,
    QUARTER(ws.created_at) AS quarter,
	COUNT(DISTINCT order_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate,
    ROUND(SUM(price_usd) / COUNT(DISTINCT order_id),2) AS rev_per_order,
	ROUND(SUM(price_usd) / COUNT(DISTINCT ws.website_session_id),2) AS rev_per_session
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE DATE(ws.created_at) < '2015-03-15'
GROUP BY year, quarter;

-- 3.  I’d like to show how we’ve grown specific channels. Could you pull a quarterly view of orders from Gsearch
--  	nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type in? 

SELECT 
	YEAR(ws.created_at) AS year,
	QUARTER(ws.created_at) AS quarter,
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NULL THEN order_id END) AS direct_type_in,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NOT NULL THEN order_id END) AS organic_search,
	COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN order_id END) AS brand_search_overall,
	COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN order_id END) AS gsearch_nonbrand,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN order_id END) AS bsearch_nonbrand
	-- COUNT(DISTINCT CASE WHEN utm_source='socialbook' THEN order_id END) AS social
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE DATE(ws.created_at) < '2015-03-15'
GROUP BY 1,2;

-- 4.  Next, let’s show the overall session to order conversion rate trends for those same channels, by quarter.
-- 		Please also make a note of any periods where we made major improvements or optimizations.

SELECT 
	YEAR(ws.created_at) AS year,
	QUARTER(ws.created_at) AS quarter,
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NULL THEN order_id END) / 
	COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NULL THEN ws.website_session_id END) AS direct_type_in,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NOT NULL THEN order_id END) /
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND utm_campaign IS NULL AND http_referer IS NOT NULL THEN ws.website_session_id END) AS organic_search,
	COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN order_id END) / 
    COUNT(DISTINCT CASE WHEN utm_campaign='brand' THEN ws.website_session_id END) AS brand_search_overall,
	COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN order_id END) /
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND utm_campaign='nonbrand' THEN ws.website_session_id END) AS gsearch_nonbrand,
	COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN order_id END) /
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND utm_campaign='nonbrand' THEN ws.website_session_id END) AS bsearch_nonbrand
	-- COUNT(DISTINCT CASE WHEN utm_source='socialbook' THEN order_id END) AS social
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id=o.website_session_id
WHERE DATE(ws.created_at) < '2015-03-15'
GROUP BY 1,2;

-- 5. 	We’ve come a long way since the days of selling a single product. Let’s pull monthly trending for revenue 
-- 		and margin by product, along with total sales and revenue. Note anything you notice about seasonality.

SELECT 
	
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(CASE WHEN product_id=1 THEN product_id ELSE NULL END) AS mrfuzzy_quantity_sold,
	ROUND(SUM(CASE WHEN product_id=1 THEN price_usd ELSE 0 END),0) AS mrfuzzy_revenue,
    ROUND(SUM(CASE WHEN product_id=1 THEN price_usd-cogs_usd ELSE 0 END),0) AS mrfuzzy_margin,
    COUNT(CASE WHEN product_id=2 THEN product_id ELSE NULL END) AS lovebear_quantity_sold,
	ROUND(SUM(CASE WHEN product_id=2 THEN price_usd ELSE 0 END),0) AS lovebear_revenue,
    ROUND(SUM(CASE WHEN product_id=2 THEN price_usd-cogs_usd ELSE 0 END),0) AS lovebear_margin,
    COUNT(CASE WHEN product_id=3 THEN product_id ELSE NULL END) AS birthdaybear_quantity_sold,
	ROUND(SUM(CASE WHEN product_id=3 THEN price_usd ELSE 0 END),0) AS birthdaybear_revenue,
    ROUND(SUM(CASE WHEN product_id=3 THEN price_usd-cogs_usd ELSE 0 END),0) AS birthdaybear_margin,
    COUNT(CASE WHEN product_id=4 THEN product_id ELSE NULL END) AS minibear_quantity_sold,
	ROUND(SUM(CASE WHEN product_id=4 THEN price_usd ELSE 0 END),0) AS minibear_revenue,
    ROUND(SUM(CASE WHEN product_id=4 THEN price_usd-cogs_usd ELSE 0 END),0) AS minibear_margin
FROM order_items
GROUP BY 1,2



-- 6.	Let’s dive deeper into the impact of introducing new products. Please pull monthly sessions to the /products 
-- 		page, and show how the % of those sessions clicking through another page has changed over time, along with
-- 		a view of how conversion from /products to placing an order has improved.

-- 7.  We made our 4th product available as a primary product on December 05, 2014 (it was previously only a cross sell
-- 		item). Could you please pull sales data since then, and show how well each product cross sells from one another?

-- 8. 	In addition to telling investors about what we’ve already achieved, let’s show them that we still have plenty of
-- 		gas in the tank. Based on all the analysis you’ve done, could you share some recommendations and
-- 		opportunities for us going forward? No right or wrong answer here I’d just like to hear your perspective!