-- Find the first pageview for a particular session.
-- Associate that pageview with the url seen.
-- Determine whether that session had any other pageviews.
-- pageviews = 1 --> bounce, otherwise, pageviews >1 no bounce

-- BUSINESS CONTEXT: we want to determine landing page performance over a particular time period

-- Step 1:  Find the first website_pageview_id for relevant sessions
-- Step 2:  Identify the landing page of each session.
-- Step 3:  Count pageviews for each session, identifying bounces.
-- Step 4:  Summarize total sessions and bounced sessions by landing page.

-- -----------------------------------------------------------------------------------------------------------------------

-- Step 1: Create a table that contains the first website_pageview_id for relevant sessions

CREATE TEMPORARY TABLE first_pageviews

SELECT wp.website_session_id, MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews wp
INNER JOIN website_sessions ws
ON wp.website_session_id=ws.website_session_id 
AND wp.created_at  BETWEEN '2012-06-19' AND '2012-07-27'
AND utm_source='gsearch'
AND utm_campaign='nonbrand'
GROUP BY website_session_id;

-- Step 2:  Bring in the landing page info for each session, but restrict to '\home' only.

CREATE TEMPORARY TABLE sessions_with_landing_pages

SELECT fpv.website_session_id, wpv.pageview_url AS landing_page
FROM first_pageviews fpv
LEFT JOIN website_pageviews wpv
ON wpv.website_pageview_id = fpv.min_pageview_id
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
