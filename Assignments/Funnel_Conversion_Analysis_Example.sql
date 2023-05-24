-- Demo on Building Conversion Funnels

-- BUSINESS CONTEXT

-- We want to build a mini conversion funnel from /lander-2 to /cart.
-- We want to know how many people reach this step and also dropoff rates.
-- We are only considering /lander-2 traffic only.
-- We are also only considering customers who like Mr. Fuzzy

-- Step 1:  Select all pageviews for relevant sessions.
-- Step 2:  Identify each relevant pageview as the specific funnel step.
-- Step 3:  Create the session-level conversion funnel view.
-- Step 4:  Aggregate the data to assess funnel performance.

SELECT ws. website_session_id, wp.pageview_url, wp.created_at AS pageview_created_at,
CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
CASE WHEN wp.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions ws
LEFT JOIN website_pageviews wp
ON ws.website_session_id = wp.website_session_id
WHERE wp.created_at BETWEEN '2014-01-01' AND '2014-02-01'
AND wp.pageview_url IN ('/lander-2', '/products','/the-original-mr-fuzzy', '/cart')
ORDER BY ws.website_session_id, wp.created_at