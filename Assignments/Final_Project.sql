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
GROUP BY 1,2

-- 4.  Next, let’s show the overall session to order conversion rate trends for those same channels, by quarter.
-- 		Please also make a note of any periods where we made major improvements or optimizations.