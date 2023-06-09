-- Find the population difference between the countries in the current row vs the country with the highest population.

SELECT 
    name,
    population,
    MAX(population) OVER () AS max_population,   -- max value for entire 'population' column
    MAX(population) OVER () - population AS difference
FROM eba_countries 

