USE seismic_project;
SHOW TABLES;
DESCRIBE earthquakes;
SELECT COUNT(*) AS total_earthquakes
FROM earthquakes;
SELECT 
    id,
    time,
    place,
    mag,
    depth_km
FROM earthquakes
ORDER BY mag DESC
LIMIT 10;
SELECT
    id,
    time,
    place,
    depth_km,
    mag
FROM earthquakes
WHERE depth_km IS NOT NULL
ORDER BY depth_km DESC
LIMIT 10;
SELECT
    id,
    time,
    place,
    depth_km,
    mag,
    magType
FROM earthquakes
WHERE depth_km < 50
  AND mag > 7.5
ORDER BY mag DESC;
SELECT
    magType,
    ROUND(AVG(mag), 2) AS average_magnitude
FROM earthquakes
WHERE mag IS NOT NULL
  AND magType IS NOT NULL
GROUP BY magType
ORDER BY average_magnitude DESC;
SELECT
    year,
    COUNT(*) AS total_earthquakes
FROM earthquakes
GROUP BY year
ORDER BY total_earthquakes DESC
LIMIT 1;
SELECT
    month,
    month_name,
    COUNT(*) AS total_earthquakes
FROM earthquakes
GROUP BY month, month_name
ORDER BY total_earthquakes DESC
LIMIT 1;
SELECT
    DAYNAME(time) AS day_of_week,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE time IS NOT NULL
GROUP BY DAYNAME(time)
ORDER BY total_earthquakes DESC
LIMIT 1;
SELECT
    HOUR(time) AS hour_of_day,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE time IS NOT NULL
GROUP BY HOUR(time)
ORDER BY hour_of_day;
SELECT
    net,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE net IS NOT NULL
GROUP BY net
ORDER BY total_earthquakes DESC
LIMIT 1;
SELECT
    place,
    SUM(felt) AS total_felt
FROM earthquakes
WHERE felt IS NOT NULL
GROUP BY place
ORDER BY total_felt DESC
LIMIT 5;
SELECT
    status,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE status IS NOT NULL
GROUP BY status
ORDER BY total_earthquakes DESC;
SELECT
    alert,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE alert IS NOT NULL
GROUP BY alert
ORDER BY total_earthquakes DESC;
SELECT
    types,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE types IS NOT NULL
GROUP BY types
ORDER BY total_earthquakes DESC
LIMIT 1;
SELECT
    type,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE type IS NOT NULL
GROUP BY type
ORDER BY total_earthquakes DESC;
SELECT
    id,
    time,
    place,
    mag,
    nst
FROM earthquakes
WHERE nst > 50
ORDER BY nst DESC;
SELECT
    year,
    COUNT(*) AS tsunami_events
FROM earthquakes
WHERE tsunami = 1
GROUP BY year
ORDER BY year;
SELECT
    country,
    ROUND(AVG(mag), 2) AS average_magnitude
FROM earthquakes
GROUP BY country
ORDER BY average_magnitude DESC
LIMIT 5;
SELECT
    alert,
    COUNT(*) AS total_earthquakes
FROM earthquakes
WHERE alert IS NOT NULL
GROUP BY alert
ORDER BY total_earthquakes DESC;
SELECT
    country,
    year,
    month
FROM earthquakes
WHERE depth_category IN ('Shallow', 'Deep')
GROUP BY country, year, month
HAVING COUNT(DISTINCT depth_category) = 2
ORDER BY country, year, month;
WITH yearly_counts AS (
    SELECT
        year,
        COUNT(*) AS total_earthquakes
    FROM earthquakes
    GROUP BY year
)
SELECT
    year,
    total_earthquakes,
    LAG(total_earthquakes) OVER (ORDER BY year) AS previous_year,
    ROUND(
        (total_earthquakes - LAG(total_earthquakes) OVER (ORDER BY year))
        * 100.0
        / LAG(total_earthquakes) OVER (ORDER BY year),
        2
    ) AS yoy_growth_percent
FROM yearly_counts
ORDER BY year;
SELECT
    place,
    COUNT(*) AS earthquake_count,
    ROUND(AVG(mag), 2) AS average_magnitude
FROM earthquakes
WHERE place IS NOT NULL
GROUP BY place
HAVING COUNT(*) >= 10
ORDER BY earthquake_count DESC, average_magnitude DESC
LIMIT 3;
SELECT
    country,
    ROUND(AVG(depth_km), 2) AS average_depth_km
FROM earthquakes
WHERE latitude BETWEEN -5 AND 5
  AND country IS NOT NULL
  AND depth_km IS NOT NULL
GROUP BY country
ORDER BY average_depth_km DESC;
SELECT
    country,
    SUM(CASE WHEN depth_category = 'Shallow' THEN 1 ELSE 0 END) AS shallow_count,
    SUM(CASE WHEN depth_category = 'Deep' THEN 1 ELSE 0 END) AS deep_count,
    ROUND(
        SUM(CASE WHEN depth_category = 'Shallow' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN depth_category = 'Deep' THEN 1 ELSE 0 END), 0),
        2
    ) AS shallow_deep_ratio
FROM earthquakes
WHERE country IS NOT NULL
GROUP BY country
HAVING deep_count > 0
ORDER BY shallow_deep_ratio DESC
LIMIT 10;
SELECT
    ROUND(AVG(CASE WHEN tsunami = 1 THEN mag END), 2) AS tsunami_avg_magnitude,
    ROUND(AVG(CASE WHEN tsunami = 0 THEN mag END), 2) AS non_tsunami_avg_magnitude,
    ROUND(
        AVG(CASE WHEN tsunami = 1 THEN mag END)
        - AVG(CASE WHEN tsunami = 0 THEN mag END),
        2
    ) AS magnitude_difference
FROM earthquakes
WHERE mag IS NOT NULL;
SELECT
    id,
    time,
    place,
    mag,
    gap,
    rms,
    ROUND(
        (gap / NULLIF((SELECT MAX(gap) FROM earthquakes), 0))
        +
        (rms / NULLIF((SELECT MAX(rms) FROM earthquakes), 0)),
        4
    ) AS reliability_score
FROM earthquakes
WHERE gap IS NOT NULL
  AND rms IS NOT NULL
ORDER BY reliability_score DESC
LIMIT 10;
SELECT
    place AS region,
    COUNT(*) AS deep_earthquake_count
FROM earthquakes
WHERE depth_km > 300
  AND place IS NOT NULL
GROUP BY place
ORDER BY deep_earthquake_count DESC
LIMIT 10;