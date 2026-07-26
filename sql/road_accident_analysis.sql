select* from cleaned_indian_roads_dataset  ;


SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_name = 'cleaned_indian_roads_dataset';


--changing data type of date and time 
alter table cleaned_indian_roads_dataset 
alter column date type DATE 
using date::DATE;

ALTER TABLE cleaned_indian_roads_dataset
ALTER COLUMN time TYPE TIME
USING time::TIME;


--total number of accidents 
SELECT COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset;


--total number of people affected in accident 
SELECT SUM(casualties) AS total_casualties
FROM cleaned_indian_roads_dataset;


--average risk score and temperature
SELECT ROUND(AVG(risk_score)::numeric,2) AS avg_risk_score
FROM cleaned_indian_roads_dataset;

SELECT ROUND(AVG(temperature),2) AS avg_temperature
FROM cleaned_indian_roads_dataset;


--maximum casualties  
SELECT MAX(casualties) AS max_casualties
FROM cleaned_indian_roads_dataset;


--minimum risk score 
SELECT MIN(risk_score) AS min_risk
FROM cleaned_indian_roads_dataset;


--total accident occur city and state wise
select city ,count(*) as city_total_accidents
from cleaned_indian_roads_dataset
group by city 
order by city_total_accidents desc;

select state ,count(*) as state_total_accidents
from cleaned_indian_roads_dataset
group by state 
order by state_total_accidents desc;


-- average risk score city wise
SELECT city,
       ROUND(AVG(risk_score)::numeric,2) AS avg_risk
FROM cleaned_indian_roads_dataset
GROUP BY city
ORDER BY avg_risk DESC;


--count of accident severity ,weather type , road type
SELECT accident_severity,
       COUNT(*) AS total
FROM cleaned_indian_roads_dataset
GROUP BY accident_severity;

select weather,count(*)as total 
from cleaned_indian_roads_dataset 
group by weather ;

select road_type,count(*)as total 
from cleaned_indian_roads_dataset 
group by road_type ;

SELECT traffic_density,
       COUNT(*) AS total
FROM cleaned_indian_roads_dataset
GROUP BY traffic_density;

SELECT accident_severity,
       ROUND(AVG(casualties),2) AS avg_casualties
FROM cleaned_indian_roads_dataset
GROUP BY accident_severity;

SELECT festival_flag,
       COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY festival_flag;


select city , count(*)as total_accidents
from cleaned_indian_roads_dataset
group by city 
having count(*)>2500

SELECT city,
       ROUND(AVG(risk_score)::numeric,2) AS avg_risk
FROM cleaned_indian_roads_dataset
GROUP BY city
HAVING AVG(risk_score) > 0.5;

SELECT road_type,
       COUNT(*) AS total
FROM cleaned_indian_roads_dataset
GROUP BY road_type
HAVING COUNT(*) > 5000;

select 
case when is_weekend=1 then 'weekend'
else 'weekday'
end as day_type,
count(*)as total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY day_type;

select 
case when is_peak_hour =1 then 'peak hour'
else 'non-peak hour'
end as traffic_time,
count(*)as total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY traffic_time;

--extracting  year ,month etc

SELECT EXTRACT(YEAR FROM date) AS year,
       COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY year
ORDER BY year;

SELECT TO_CHAR(date,'Month') AS month,
       COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY month
ORDER BY MIN(EXTRACT(MONTH FROM date));

SELECT EXTRACT(QUARTER FROM date) AS quarter,
       COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY quarter
ORDER BY quarter;

SELECT
    day_of_week,
    COUNT(*) AS total_accidents
FROM cleaned_indian_roads_dataset
GROUP BY day_of_week
ORDER BY
   CASE day_of_week
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END;

WITH city_data AS (
    SELECT city, COUNT(*) AS total_accidents
    FROM cleaned_indian_roads_dataset
    GROUP BY city
)
SELECT * FROM city_data
WHERE total_accidents > 2500;



WITH city_data AS (
    SELECT
        city,
        COUNT(*) AS total_accidents
    FROM cleaned_indian_roads_dataset
    GROUP BY city
)

SELECT
    city,
    total_accidents,
    RANK() OVER (ORDER BY total_accidents DESC) AS city_rank
FROM city_data;


WITH city_data AS (
    SELECT
        city,
        COUNT(*) AS total_accidents
    FROM cleaned_indian_roads_dataset
    GROUP BY city
)

SELECT
    city,
    total_accidents,
    DENSE_RANK() OVER (ORDER BY total_accidents DESC) AS city_rank
FROM city_data;


-- Rank cities within each state based on the total number of accidents
SELECT
    state,
    city,
    COUNT(*) AS total_accidents,
    RANK() OVER (
        PARTITION BY state
        ORDER BY COUNT(*) DESC
    ) AS state_rank
FROM cleaned_indian_roads_dataset
GROUP BY state, city;

---- Creating a view to summarize accident statistics for each city

CREATE VIEW city_summary AS
SELECT
    city,
    COUNT(*) AS total_accidents,
    SUM(casualties) AS total_casualties,
    ROUND(AVG(risk_score)::numeric,2) AS avg_risk
FROM cleaned_indian_roads_dataset
GROUP BY city;

---- Create a view to summarize monthly accident and casualty statistics
CREATE VIEW monthly_summary AS
SELECT
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    COUNT(*) AS total_accidents,
    SUM(casualties) AS total_casualties
FROM cleaned_indian_roads_dataset
GROUP BY
    EXTRACT(YEAR FROM date),
    EXTRACT(MONTH FROM date);
