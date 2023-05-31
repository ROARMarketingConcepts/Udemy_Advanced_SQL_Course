-- Step 1: Identify the relevant new sessions.
-- Step 2: Use the user_id values from Step 1 to find any repeat sessions those users had.
-- Step 3: Analyze the data at the user level (how many sessions did each user have?)
-- Step 4: Aggregate the data to generate the desired metrics.

CREATE TEMPORARY TABLE new_sessions

	SELECT
		user_id,
		website_session_id
	FROM website_sessions
	WHERE DATE(created_at) BETWEEN '2014-01-01' AND '2014-11-01' 
    AND is_repeat_session = 0;  -- new sessions only

CREATE TEMPORARY TABLE sessions_with_repeats

	SELECT 
		ns.user_id,
		ns.website_session_id AS new_session_id,
		ws.website_session_id AS repeat_session_id
	FROM new_sessions ns
	LEFT JOIN website_sessions ws
	ON ns.user_id = ws.user_id
	AND ws.is_repeat_session = 1 -- redundant
	AND ws.website_session_id > ns.website_session_id
	AND DATE(created_at) BETWEEN '2014-01-01' AND '2014-11-01' ;
    
    CREATE TEMPORARY TABLE user_level
    
		SELECT 
			user_id,
            COUNT(DISTINCT new_session_id) AS new_sessions,
            COUNT(DISTINCT repeat_session_id) AS repeat_sessions
            FROM sessions_with_repeats
            GROUP BY user_id
            ORDER BY repeat_sessions DESC;
            
	SELECT 
		repeat_sessions,
        COUNT(DISTINCT user_id) AS users
        FROM user_level
        GROUP BY repeat_sessions
    

