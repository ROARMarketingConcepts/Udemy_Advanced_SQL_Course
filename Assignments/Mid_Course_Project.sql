-- Mid-Course Project

-- Task 1: Gsearch seems to be the biggest driver of our business. Could you pull
-- monthly trends for gsearch session and orders so that we can showcase the growth there?

WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')
    
SELECT  
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT swo.website_session_id) AS orders,
    COUNT(DISTINCT swo.website_session_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM website_sessions ws
LEFT JOIN sessions_with_order swo
ON ws. website_session_id = swo.website_session_id
WHERE utm_source='gsearch' 
AND created_at  < '2012-11-27'
GROUP BY month_num, month
ORDER BY month_num;

-- Task 2:  Next, it would be great to see a similar monthly trend for Gsearch, but this time
-- splitting out nonbrand and brand campaigns separately . I am wondering if brand is picking up at all. If so, this is a good story to tell.

WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')

SELECT   
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
    COUNT(ws.website_session_id) AS total_sessions,
	COUNT(CASE WHEN utm_campaign='brand' THEN ws.website_session_id ELSE NULL END) AS brand_sessions,
    COUNT(CASE WHEN utm_campaign='brand' THEN swo.website_session_id ELSE NULL END) AS brand_orders,
    COUNT(CASE WHEN utm_campaign='brand' THEN swo.website_session_id ELSE NULL END) / COUNT(CASE WHEN utm_campaign='brand' THEN ws.website_session_id ELSE NULL END) AS brand_conv_rate,
	COUNT(CASE WHEN utm_campaign='nonbrand' THEN ws.website_session_id ELSE NULL END) AS nonbrand_sessions,
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN swo.website_session_id ELSE NULL END) AS nonbrand_orders,
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN swo.website_session_id ELSE NULL END) / COUNT(CASE WHEN utm_campaign='nonbrand' THEN ws.website_session_id ELSE NULL END) AS nonbrand_conv_rate
FROM website_sessions ws
LEFT JOIN sessions_with_order swo
ON ws. website_session_id = swo.website_session_id
WHERE DATE(created_at)  < '2012-11-27'
AND utm_source='gsearch'
GROUP BY month_num, month
ORDER BY month_num;

-- Task 3: While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device
-- type? I want to flex our analytical muscles a little and show the board we really know our traffic sources.

WITH sessions_with_order AS 
	(SELECT website_session_id 
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')

SELECT   
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
    COUNT(ws.website_session_id) AS total_sessions,
	COUNT(CASE WHEN device_type='mobile' THEN ws.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(CASE WHEN device_type='mobile' THEN swo.website_session_id ELSE NULL END) AS mobile_orders,
    COUNT(CASE WHEN device_type='mobile' THEN swo.website_session_id ELSE NULL END) / COUNT(CASE WHEN device_type='mobile' THEN ws.website_session_id ELSE NULL END) AS mobile_conv_rate,
	COUNT(CASE WHEN device_type='desktop' THEN ws.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(CASE WHEN device_type='desktop' THEN swo.website_session_id ELSE NULL END) AS desktop_orders,
    COUNT(CASE WHEN device_type='desktop' THEN swo.website_session_id ELSE NULL END) / COUNT(CASE WHEN device_type='desktop' THEN ws.website_session_id ELSE NULL END) AS desktop_conv_rate
FROM website_sessions ws
LEFT JOIN sessions_with_order swo
ON ws. website_session_id = swo.website_session_id
WHERE DATE(created_at)  < '2012-11-27'
AND utm_source='gsearch' AND utm_campaign='nonbrand'
GROUP BY month_num, month
ORDER BY month_num;


-- Task 4: I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from
-- Gsearch. Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?

SELECT   
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
	utm_source,
    utm_campaign,
    COUNT(website_session_id) AS sessions
FROM website_sessions
WHERE DATE(created_at)  < '2012-11-27'
GROUP BY utm_source, utm_campaign,month_num, month
ORDER BY month_num,utm_source;

-- Task 5: I’d like to tell the story of our website performance improvements over the course of the first 8 months.
-- Could you pull session to order conversion rates, by month ? 

WITH sessions_with_order AS 
	(SELECT website_session_id
	FROM website_pageviews
	WHERE pageview_url LIKE '/thank-you%')
    
SELECT  
	MONTH(created_at) AS month_num, 
	MONTHNAME(created_at) AS month,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT swo.website_session_id) AS orders,
    COUNT(DISTINCT swo.website_session_id) / COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM website_sessions ws
LEFT JOIN sessions_with_order swo
ON ws. website_session_id = swo.website_session_id
WHERE DATE(ws.created_at)  < '2012-11-27'
GROUP BY month_num, month
ORDER BY month_num;

-- Task 6: For the gsearch lander test, please estimate the revenue that test earned us (Hint: Look at the increase in CVR
-- from the test (Jun19 - Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value) 

-- First we need to find the first website_pageview_id where '/lander-1' appears, which is '23504'
SELECT MIN(website_pageview_id) 
FROM website_pageviews
WHERE pageview_url='/lander-1';

-- Step 1: Create a table that contains the first website_pageview_id for relevant sessions

CREATE TEMPORARY TABLE first_test_pageviews

SELECT 
		wp.website_session_id, 
		MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews wp
INNER JOIN website_sessions ws
ON wp.website_session_id=ws.website_session_id 
	AND utm_source='gsearch'
	AND utm_campaign='nonbrand' 
	AND DATE(ws.created_at) < '2012-07-28'
    AND wp.website_pageview_id >= 23504
GROUP BY website_session_id;

-- Step 2:  Bring in the landing page info for each session, but restrict to '\home' only.

CREATE TEMPORARY TABLE sessions_with_landing_pages

SELECT 
		ftpv.website_session_id, 
        wpv.pageview_url AS landing_page
FROM first_test_pageviews ftpv
LEFT JOIN website_pageviews wpv
ON wpv.website_pageview_id = ftpv.min_pageview_id
WHERE wpv.pageview_url IN ('/home', '/lander-1');

-- Step 3: We create a table to include a count of pageviews per sesson.
-- First we, show all of the sessions and then we will limit to bounced sessions
-- and create a table.

CREATE TEMPORARY TABLE bounced_sessions_only

SELECT  swlp.website_session_id, swlp.landing_page,
COUNT(wpv.website_pageview_id) AS cnt_page_views
FROM sessions_with_landing_pages swlp 
LEFT JOIN website_pageviews wpv
ON wpv.website_session_id = swlp.website_session_id
GROUP BY swlp.website_session_id, swlp.landing_page
HAVING cnt_page_views = 1;

-- Step 4:  Run the previous query to get a count of total sessions by landing page.
--  Then calculate a bounce rate for each landing page.

SELECT swlp.landing_page,  COUNT(DISTINCT swlp.website_session_id) AS total_sessions,
COUNT(DISTINCT bso.website_session_id) AS bounced_sessions,
COUNT(DISTINCT bso.website_session_id) / COUNT(DISTINCT swlp.website_session_id) AS bounce_rate
FROM sessions_with_landing_pages swlp
LEFT JOIN bounced_sessions_only bso
ON swlp.website_session_id = bso.website_session_id
GROUP BY swlp.landing_page;


-- Task 7: For the landing page test you analyzed previously, it would be great to show a full conversion funnel from each
-- of the two pages to orders . You can use the same time period you analyzed last time (Jun 19 - Jul 28).

-- Task 8: I’d love for you to quantify the impact of our billing test, as well. Please analyze the lift generated from the test
-- (Sep 10 - Nov 10), in terms of revenue per billing page session , and then pull the number of billing page sessions
-- for the past month to understand monthly impact.

