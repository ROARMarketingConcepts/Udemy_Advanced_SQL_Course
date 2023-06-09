-- Flag all countries that are in the top 10 percentile for their region in terms of population.

SELECT 
    name,
    region_id,
    population,
    PERCENT_RANK() OVER(PARTITION BY region_id ORDER BY population DESC) AS percentile,
    CASE WHEN PERCENT_RANK() OVER(PARTITION BY region_id ORDER BY population DESC) <= 0.1 THEN 1 ELSE 0 END AS top_10_percentile_flag

    FROM eba_countries