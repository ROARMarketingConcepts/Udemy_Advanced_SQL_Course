CREATE TABLE qt (i INTEGER, p CHAR(1), o INTEGER);
INSERT INTO qt (i, p, o) VALUES
    (1, 'A', 1),
    (2, 'A', 2),
    (3, 'B', 1),
    (4, 'B', 2);
	
SELECT *
FROM qt

SELECT * 
 	FROM (
         SELECT i, p, o, 
                ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) AS row_num
            FROM qt
        ) result
    WHERE row_num = 1;
	
+---+---+---+---------+
| I | P | O | ROW_NUM |
|---+---+---+---------|
| 1 | A | 1 |       1 |
| 3 | B | 1 |       1 |
+---+---+---+---------+
	
	
SELECT i, p, o
    FROM qt
    QUALIFY ROW_NUMBER() OVER (PARTITION BY p ORDER BY o) = 1;
	
+---+---+---+---------+
| I | P | O | ROW_NUM |
|---+---+---+---------|
| 1 | A | 1 |       1 |
| 3 | B | 1 |       1 |
+---+---+---+---------+