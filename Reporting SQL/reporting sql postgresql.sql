-- Query the sport and distinct number of athletes
SELECT 
	sport, 
    count(distinct(athlete_id)) AS athletes
FROM summer_games
GROUP BY sport
-- Only include the 3 sports with the most athletes
ORDER BY athletes DESC
LIMIT 3;

------------------------------------------------------------
-- Query sport, events, and athletes from summer_games
SELECT 
	sport, 
    count(distinct(event)) AS events, 
    count(distinct(athlete_id)) AS athletes
FROM summer_games
GROUP BY sport;

----------------------------------------------------------

-- Select the age of the oldest athlete for each region
SELECT 
	region, 
    max(age) AS age_of_oldest_athlete
FROM countries
-- First JOIN statement
JOIN summer_games
on countries.id = summer_games.country_id
-- Second JOIN statement
JOIN athletes
on athletes.id = summer_games.athlete_id
GROUP BY region
ORDER BY age_of_oldest_athlete DESC;


----------------------------------------------------------

-- Select sport and events for summer sports
SELECT 
	sport, 
    count(distinct event) AS events
FROM summer_games
group by sport
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    count(distinct event) as events
FROM winter_games
group by sport
-- Show the most events at the top of the report
order by events desc;


------------------------------------------------------------
-- Add the rows column to your query
SELECT 
	medal, 
	count('NULL') AS rows
FROM summer_games

where medal like '%Bronze%'
GROUP BY medal;


----------------------------------------------------------


/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
SELECT count(bronze_medals)
FROM 
-- Previous query is shown below.  Alias this AS subquery
  (SELECT 
      country, 
      count(medal) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  where medal like '%Bronze%'
  GROUP BY country) as subquery
;

-------------------------------------------------

-- Pull athlete_name and gold_medals for summer games
SELECT 
	a.name AS athlete_name, 
    sum(medal) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
GROUP BY name
where medal like '%Gold%'
-- Filter for only athletes with 3 gold medals or more
having sum(gold) >=3
-- Sort to show the most gold medals at the top
ORDER BY gold_medals desc;





select count(medal)
from summer_games
where medal is not null


SELECT count(medal)
from summer_games
WHERE medal like '%Bronze%'
-----------------------------------------------------
--split the medal column to three columns 
ALTER TABLE summer_games
ADD COLUMN bronze_medals INT default 0,
ADD COLUMN silver_medals INT default 0,
ADD COLUMN gold_medals INT default 0;


--Update Values
UPDATE summer_games
SET 
bronze_medals = CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END,
silver_medals = CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END,
gold_medals = CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END;


-- let me drop the old column

ALTER TABLE summer_games DROP COLUMN medal


--do the same steps to winte_games

ALTER TABLE winter_games
ADD COLUMN bronze_medals INT default 0,
ADD COLUMN silver_medals INT default 0,
ADD COLUMN gold_medals INT default 0;


UPDATE winter_games 
SET 
bronze_medals = CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END,
silver_medals = CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END ,
gold_medals = CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END ; 



ALTER TABLE public.winter_games DROP COLUMN medal;


/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */
-- Select the total bronze_medals from your query
SELECT sum(bronze_medals)
FROM 
-- Previous query is shown below.  Alias this AS subquery
  (SELECT 
      country, 
      SUM(bronze_medals) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country) as subquery
;
-- the same result with this query
select sum(bronze_medals)
from summer_games







-- Pull athlete_name and gold_medals for summer games
SELECT 
	a.name AS athlete_name, 
    sum(gold_medals) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
GROUP BY name
-- Filter for only athletes with 3 gold medals or more
having sum(gold_medals) >=3
-- Sort to show the most gold medals at the top
ORDER BY gold_medals desc;



-- Query season, country, and events for all summer events
SELECT 
	'summer' AS season, 
    country, 
    count(distinct event) AS events
FROM summer_games AS s
JOIN countries AS c
ON c.id = s.country_id
GROUP BY season , country
-- Combine the queries
union all
-- Query season, country, and events for all winter events
SELECT 
	'winter' AS season, 
    country, 
    count(distinct  event) AS events
FROM winter_games AS w
JOIN countries AS c
ON c.id = w.country_id
GROUP BY season ,country
-- Sort the results to show most events at the top
ORDER BY events desc;


-- Add outer layer to pull season, country and unique events
SELECT 
	season, 
    country, 
    count(distinct event) AS events
FROM
    -- Pull season, country_id, and event for both seasons
    (SELECT 
     	'summer' AS season, 
     	country_id, 
     	event
    FROM summer_games as s
    union all
    SELECT 
     	'winter' AS season, 
     	country_id, 
     	event
    FROM winter_games as w) AS subquery
JOIN countries AS c
ON c.id = subquery.country_id
-- Group by any unaggregated fields
GROUP BY season, country
-- Order to show most events at the top
ORDER BY events desc;


SELECT 
	name,
    -- Output 'Tall Female', 'Tall Male', or 'Other'
	CASE
     WHEN height >=175 AND gender = 'F' THEN 'Tall Female'
     WHEN height >= 190 AND gender = 'M' THen 'Tall Male'
     ELSE 'Other' END AS segment
FROM athletes;



-- Pull in sport, bmi_bucket, and athletes
SELECT 
	sport,
    -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
    CASE WHEN 100 * a.weight / height^2 < .25 THEN '<.25'
    WHEN 100 * a.weight / height^2 <= .30 THEN '.25-.30'
    WHEN 100 * a.weight / height^2 > .30 THEN '>.30' END AS bmi_bucket,
    count(distinct athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
-- GROUP BY non-aggregated fields
GROUP BY sport ,bmi_bucket
-- Sort by sport and then by athletes in descending order
ORDER BY sport , athletes DESC;



-- Show height, weight, and bmi for all athletes
SELECT 
	height,
    weight,
    100*weight / height^2 AS bmi
FROM athletes
-- Filter for NULL bmi values
WHERE 100 * weight/height^2 IS NULL;


SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30'
    -- Add ELSE statement to output 'no weight recorded'
    ELSE 'no weight recorded' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30'
    -- Add ELSE statement to output 'no weight recorded'
    ELSE 'no weight recorded' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;




-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze_medals) AS bronze_medals, 
    SUM(silver_medals) AS silver_medals, 
    SUM(gold_medals) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
-- Filter for athletes age 16 or below
WHERE age <= 16;





-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze_medals) AS bronze_medals, 
    SUM(silver_medals) AS silver_medals, 
    SUM(gold_medals) AS gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id
     FROM athletes
     WHERE age <=16);
-- same results but first one use subquery and second joins
SELECT  
    SUM(bronze_medals) AS bronze_medals,
	SUM(silver_medals) AS silver_medals,
	SUM(gold_medals) AS gold_medals
FROM summer_games s
JOIN athletes a
ON a.id = s.athlete_id
WHERE age <= 16



-- Pull event and unique athletes from summer_games 
SELECT 
	event, 
    -- Add the gender field below
    CASE WHEN event LIKE '%Women''s%' THEN 'female' 
    ELSE 'male'  END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;


-------- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners > 0 )
GROUP BY event;


-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Add the second query below and combine with a UNION
UNION
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Order and limit the final output
ORDER BY athletes DESC
LIMIT 10;


--Validation and cleaning

-- Pull column_name & data_type from the columns table
SELECT 
	column_name,
    data_type
FROM information_schema.columns
-- Filter for the table 'country_stats'
WHERE table_name = 'country_stats';



SELECT AVG(CAST (pop_in_millions AS FLOAT)) AS avg_pop
from country_stats
-- pull country_id , count_of_athletes in summer_athletes and winter_athletes
SELECT 
    
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games AS w
-- Fix the error by making both columns integers
ON s.country_id = CAST(w.country_id AS int)
GROUP BY s.country_id;




SELECT 
    year,
    -- Pull decade, decade_truncate, and the world's gdp
    DATE_PART('decade' , CAST(year AS date)) AS decade,
    DATE_TRUNC('decade' , CAST(year AS date)) AS decade_truncated,
    sum(gdp) AS world_gdp
FROM country_stats
-- Group and order by year in descending order
GROUP BY year
ORDER BY world_gdp DESC;


-- Convert country to proper case
SELECT 
    country, 
    INITCAP(country) AS country_altered
FROM countries
GROUP BY country;


-- Output the left 3 characters of country
SELECT 
    country, 
    LEFT(country , 3) AS country_altered
FROM countries
GROUP BY country;


-- Output all characters starting with position 7
SELECT 
    country, 
    SUBSTRING(country from 7) AS country_altered
FROM countries
GROUP BY country;



SELECT 
    region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region , '&' , 'and') AS character_swap,
    -- Remove all periods
    REPLACE(region , '.' , '') AS character_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;


SELECT 
    region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove,
    -- Combine the functions to run both changes at once
    REPLACE(REPLACE(region , '&' , 'and'),'.' ,'') AS character_swap_and_remove
FROM countries
WHERE region = '%LATIN AMER. & CARIB%'
GROUP BY region;	





-- Pull event and unique athletes from summer_games_messy 
SELECT 
    event, 
    count(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Group by the non-aggregated field
GROUP BY event;




-- Pull event and unique athletes from summer_games_messy 
SELECT 
    -- Remove dashes from all event values
    TRIM(REPLACE(event , '-' ,'')) AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Update the group by accordingly
GROUP BY event_fixed;



-- Show total gold_medals by country
SELECT 
    country,
    sum(gold_medals) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON c.id = w.country_id
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals desc;


-- Show total gold_medals by country
SELECT 
    country, 
    SUM(gold_medals) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Removes any row with no gold medals
WHERE gold_medals is not null
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;



-- Show total gold_medals by country
SELECT 
    country, 
    SUM(gold_medals) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Comment out the WHERE statement
--WHERE gold IS NOT NULL
GROUP BY country
-- Replace WHERE statement with equivalent HAVING statement
HAVING sum(gold_medals) is not null
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;




-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id,
    COUNT(event) AS total_events, 
    SUM(gold_medals) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY gold_medals DESC;


-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Add a field that averages the existing gold field
    avg(gold_medals) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold_medals) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;


-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Replace all null gold values with 0
    AVG(coalesce (gold_medals , 0)) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold_medals) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;


--Check Duplication
-- Pull total gold_medals for winter sports
SELECT sum(gold_medals) AS gold_medals
FROM winter_games;




-- Show gold_medals and avg_gdp by country_id
SELECT 
    c.country_id, 
    SUM(gold_medals) AS gold_medals, 
    AVG(gdp) AS avg_gdp
FROM winter_games AS w
JOIN country_stats AS c
-- Only join on the country_id fields
ON c.country_id = w.country_id
GROUP BY c.country_id;


-- Calculate the total gold_medals in your query
SELECT sum(gold_medals)
FROM
   (SELECT 
        w.country_id, 
      SUM(gold_medals) AS gold_medals, 
        AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    ON c.country_id = w.country_id
    -- Alias your query as subquery
    GROUP BY w.country_id) AS subquery;


--let's solve this duplication by joins
SELECT SUM(gold_medals) AS gold_medals
FROM
    (SELECT 
        w.country_id, 
        SUM(gold_medals) AS gold_medals, 
        AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    -- Update the subquery to join on a second field
    ON c.country_id = w.country_id AND w.year = CAST(c.year AS date)
    GROUP BY w.country_id) AS subquery;




--Report
SELECT 
    country,
    -- Add the three medal fields using one sum function
    SUM(COALESCE(bronze_medals, 0 ) + COALESCE(silver_medals , 0) + COALESCE(gold_medals , 0)) AS medals
FROM summer_games AS s
JOIN countries AS c
ON c.id = s.country_id
GROUP BY country
ORDER BY medals DESC;



SELECT 
    c.country,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) AS medals,
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Add a join
JOIN country_stats AS cs 
ON s.country_id = cs.country_id
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;


SELECT 
    c.country,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) AS medals,
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;


--Final report in this step
SELECT 
    -- Clean the country field to only show country_code
    LEFT(REPLACE(UPPER(TRIM(c.country)), '.', ''), 3) AS country_code,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) AS medals,
    SUM(COALESCE(bronze_medals,0) + COALESCE(silver_medals,0) + COALESCE(gold_medals,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
-- Filter out null populations
WHERE cs.pop_in_millions IS NOT NULL
GROUP BY c.country, pop_in_millions
-- Keep only the top 25 medals_per_million rows
ORDER BY medals_per_million DESC
LIMIT 25;




--Using wWindow Functions

SELECT 
    country_id,
    year,
    gdp,
    -- Show the average gdp across all years per country
    AVG(gdp) OVER (PARTITION BY country_id) AS country_avg_gdp
FROM country_stats;


SELECT 
    country_id,
    year,
    gdp,
    -- Show total gdp per country and alias accordingly
    SUM(gdp) OVER (PARTITION BY country_id) AS country_sum_gdp
FROM country_stats;


SELECT 
    country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
    MAX(gdp) OVER ( ) AS global_max_gdp 
FROM country_stats



-- Query total_golds by region and country_id
SELECT 
    s.country_id, 
    region, 
    sum(gold_medals) AS total_golds
FROM summer_games AS s
JOIN countries AS c
ON c.id = s.country_id
GROUP BY s.country_id , region
ORDER BY total_golds DESC;


-- Pull in avg_total_golds by region
SELECT 
  region,
    avg(total_golds) AS avg_total_golds
FROM
  (SELECT 
      region, 
      country_id, 
      SUM(gold_medals) AS total_golds
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  -- Alias the subquery
  GROUP BY region, country_id) AS subquery
GROUP BY region
-- Order by avg_total_golds in descending order
ORDER BY avg_total_golds;



SELECT 
    -- Query region, athlete_name, and total gold medals
    region, 
    a.name AS athlete_name, 
    sum(s.gold_medals) AS total_golds,
    -- Assign a regional rank to each athlete
    ROW_NUMBER() OVER (PARTITION BY region ) AS row_num
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
JOIN countries AS c
ON c.id = s.country_id
GROUP BY region , athlete_name;




-- Query region, athlete name, and total_golds
SELECT 
    region,
    athlete_name,
    total_golds
FROM
    (SELECT 
        -- Query region, athlete_name, and total gold medals
        region, 
        name AS athlete_name, 
        SUM(gold_medals) AS total_golds,
        -- Assign a regional rank to each athlete
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold_medals) DESC) AS row_num
    FROM summer_games AS s
    JOIN athletes AS a
    ON a.id = s.athlete_id
    JOIN countries AS c
    ON s.country_id = c.id
    -- Alias as subquery
    GROUP BY region, athlete_name) AS subquery
-- Filter for only the top athlete per region
WHERE row_num = 1;



-- Pull country_gdp by region and country
SELECT 
    region,
    country,
    SUM(gdp) AS country_gdp
FROM country_stats AS cs
JOIN countries AS c
ON c.id = cs.country_id
-- Filter out null gdp values
WHERE gdp is NOT null 
GROUP BY  region ,country
-- Show the highest country_gdp at the top
ORDER BY  country_gdp DESC;


-- Pull country_gdp by region and country
SELECT 
    region,
    country,
    SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER() AS global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region , country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;



-- Pull country_gdp by region and country
SELECT 
    region,
    country,
    SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    sum(gdp) / sum(sum(gdp)) over () AS perc_global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;


-- An this isthe ful final query


-- Pull country_gdp by region and country
SELECT 
    region,
    country,
    SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER () AS perc_global_gdp,
    -- Calculate percent of gdp relative to its region
    SUM(gdp) / SUM(SUM(gdp)) OVER (PARTITION BY region) AS perc_region_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;






--make A GDP  per capita performance index
-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(CAST (pop_in_millions AS FLOAT)) AS gdp_per_million
-- Pull from country_stats_clean
FROM country_stats AS cs
JOIN countries AS c
ON c.id = cs.country_id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region , country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;



-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(CAST (pop_in_millions AS FLOAT)) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER() / SUM(SUM(CAST(pop_in_millions AS FLOAT))) OVER()  AS gdp_per_million_total
-- Pull from country_stats
FROM country_stats AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;



-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(CAST(pop_in_millions AS FLOAT)) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER () / SUM(SUM(CAST(pop_in_millions AS FLOAT))) OVER () AS gdp_per_million_total,
    -- Build the performance_index in the 3 lines below
    (SUM(gdp) / SUM(CAST(pop_in_millions AS FLOAT)))
    /
    (SUM(SUM(gdp)) OVER () / SUM(SUM(CAST(pop_in_millions AS FLOAT))) OVER() ) AS performance_index
-- Pull from country_stats_clean
FROM country_stats AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;



--Final Report about (Tallest Athletes and % GDP by region)



SELECT 
    -- Pull in country_id and height
    country_id,
    height,
    -- Number the height of each country's athletes
    ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
FROM winter_games AS w
JOIN athletes AS a
ON a.id = w.athlete_id
GROUP BY country_id, height
-- Order by country_id and then height in descending order
ORDER BY country_id, height DESC;



SELECT
    -- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest
FROM countries AS c
JOIN
    (SELECT 
        -- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a 
    ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;



SELECT
    -- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest,
    -- Calculate region's percent of world gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER() AS perc_world_gdp    
FROM countries AS c
JOIN
    (SELECT 
        -- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Join to country_stats
JOIN country_stats AS cs
ON cs.country_id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;















