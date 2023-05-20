-- Need to determine how utm_source, campaign, and referring domain are impacting website_sessions

SELECT utm_source, utm_campaign, http_referer, COUNT(DISTINCT website_session_id) AS cnt
FROM website_sessions
WHERE DATE(created_at) < '2012-04-12'
GROUP BY utm_source,utm_campaign,http_referer
ORDER BY cnt DESC