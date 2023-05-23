-- Find the first pageview for a particular session.
-- Associate that pageview with the url seen.
-- Determine whether that session had any other pageviews.
-- pageviews = 1 --> bounce, otherwise, pageviews >1 no bounce

-- BUSINESS CONTEXT: we want to determine landing page performance over a particular time period

-- Step 1:  Find the first website_pageview_id for relevant sessions
-- Step 2:  Identify the landing page of each session.
-- Step 3:  Summarize by week total sessions, bounced sessions, bounce rate by landing page.

-- -----------------------------------------------------------------------------------------------------------------------

-- Step 1: Create a table that contains the first website_pageview_id for relevant sessions

CREATE TEMPORARY TABLE first_pageviews_and_pageview_count

SELECT 
        ws.website_session_id, 
		MIN(wp.website_pageview_id) AS first_pageview_id,
		COUNT(wp.website_pageview_id) AS count_pageviews
FROM website_sessions ws
LEFT JOIN website_pageviews wp
ON wp.website_session_id=ws.website_session_id 

WHERE wp.created_at  BETWEEN '2012-06-01' AND '2012-08-30'
AND utm_source='gsearch'
AND utm_campaign='nonbrand'

GROUP BY ws.website_session_id;

-- Step 2:  Bring in the landing page info for each session, but restrict to '/home' and '/lander-1' only.

CREATE TEMPORARY TABLE sessions_with_landing_pages

SELECT 
		wpv.created_at,
		fpvpc.website_session_id, 
		fpvpc.first_pageview_id, 
		fpvpc.count_pageviews,
		wpv.pageview_url AS landing_page
FROM first_pageviews_and_pageview_count fpvpc
LEFT JOIN website_pageviews wpv
ON wpv.website_pageview_id = fpvpc.first_pageview_id;

-- Step 3:  Summarize the 'sessions_with_landing_pages' table to get the output requested.

SELECT 
		YEARWEEK(created_at) AS year_week,
        MIN(DATE(created_at)) AS week_start_date,
        COUNT(DISTINCT website_session_id) AS total_sessions,
		COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END)  AS bounced_sessions,
		COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS bounce_rate,
        COUNT(DISTINCT CASE WHEN landing_page='/home' THEN website_session_id ELSE NULL END) AS home_sessions,
		COUNT(DISTINCT CASE WHEN landing_page='/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM sessions_with_landing_pages
GROUP BY YEARWEEK(created_at);
