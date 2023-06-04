SELECT
	CASE
		WHEN utm_source IS NULL AND utm_campaign IS NULL
			THEN 
				CASE WHEN http_referer IS NULL 
					THEN 'direct_type_in' ELSE 'organic_search' END
		WHEN utm_campaign='brand' THEN 'paid_brand'
		WHEN utm_campaign='nonbrand' THEN 'paid_nonbrand'
		WHEN utm_source='socialbook' THEN 'paid_social'  END 
		AS channel_group,
        COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) as new_sessions,
        COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) as repeat_sessions
	FROM website_sessions
	WHERE DATE(created_at) BETWEEN '2014-01-01' AND '2014-11-04' 
    GROUP BY 1
    ORDER BY 3 DESC