-- Arrange the countries in order of population from largest to smallest and find the difference between 
-- the population of the current row's country and the country immediately following it.

SELECT 
    name,
    population,
    LEAD(population,1) OVER (ORDER BY population DESC)
    population - LEAD(population,1) OVER (ORDER BY population DESC) AS variance
FROM eba_countries 
