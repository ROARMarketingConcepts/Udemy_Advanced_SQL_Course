CREATE TABLE goals_per_season(player varchar(10), year_2018 int, year_2019 int, year_2020 int);

INSERT INTO goals_per_season VALUES ('Rick', 51,31,38);
INSERT INTO goals_per_season VALUES ('Jeff', 28,37,36);
INSERT INTO goals_per_season VALUES ('George', 40,55,48);

SELECT * FROM goals_per_season;

-- UNPIVOT the GOALS_PER_SEASON Table to have the following columns: player, season, goals

SELECT * FROM goals_per_season
UNPIVOT(goals for season in (year_2018, year_2019, year_2020));