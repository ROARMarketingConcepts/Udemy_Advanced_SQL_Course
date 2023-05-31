-- Step 1: Identify the relevant new sessions.
-- Step 2: Use the user_id values from Step 1 to find any repeat sessions those users had.
-- Step 3: Find the 'created_at' times for the first and second sessions.
-- Step 4: Find the days difference in the first and second sessions at the user level.
-- Step 5: Aggregate the user level data to find the average, min and max days between sessions.

CREATE TEMPORARY TABLE new_sessions

	SELECT
		user_id,
		website_session_id AS first_session_id,
        created_at AS first_session_date
	FROM website_sessions
	WHERE DATE(created_at) BETWEEN '2014-01-01' AND '2014-11-03' 
    AND is_repeat_session = 0;  -- new sessions only

CREATE TEMPORARY TABLE sessions_with_repeats

	SELECT 
		ns.user_id,
        ns.first_session_id AS new_session_id,
        ns.first_session_date AS new_session_created_at,
		ws.website_session_id AS repeat_session_id,
        ws.created_at AS repeat_session_created_at
	FROM new_sessions ns
	LEFT JOIN website_sessions ws
	ON ns.user_id = ws.user_id
	AND ws.is_repeat_session = 1 -- redundant
	AND ws.website_session_id > ns.first_session_id
	AND DATE(created_at) BETWEEN '2014-01-01' AND '2014-11-03' ;
    
-- The following table ensures we are grabbing the second session only.  Otherwise, we
-- would be including 3rd and 4th sessions which would not be correct.
    
CREATE TEMPORARY TABLE grab_second_session

	SELECT
		user_id,
        new_session_id,
        new_session_created_at,
        MIN(repeat_session_id) AS second_session_id,
        MIN(repeat_session_created_at) AS second_session_created_at
	FROM sessions_with_repeats
    GROUP BY 1,2,3;
    
CREATE TEMPORARY TABLE users_first_to_second
    
	SELECT 
		user_id,
		DATEDIFF(second_session_created_at,new_session_created_at) AS days_between_first_second_session
	FROM grab_second_session;
    
    SELECT 
		AVG(days_between_first_second_session) AS avg_days_first_to_second,
        MIN(days_between_first_second_session) AS min_days_first_to_second,
        MAX(days_between_first_second_session) AS max_days_first_to_second
	FROM users_first_to_second
