-- Order the countries by population in ascending order and create a running total field for the population.

SELECT 
    name,
    population,
    SUM(population) OVER (ORDER BY population) AS running_total
FROM eba_countries;