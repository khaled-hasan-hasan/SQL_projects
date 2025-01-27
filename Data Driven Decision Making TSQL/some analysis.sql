use movies
 -- Order by recency in decreasing order
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
order by date_renting desc;
---------------------------------------------------------
--not all of users reating the movie after watch it
SELECT *
FROM renting
WHERE date_renting between '2018-01-01' and '2018-12-31' -- Renting in 2018
AND rating is not null; -- Rating exists
---------------------------------------------------------

SELECT *
FROM movies
where title in  ('Showtime','Love Actually','The Fighter'); -- Select all movies with the given titles
--------------------------------------------------------

--some of aggregation function with filter 
SELECT min(rating) as min_rating, -- Calculate the minimum rating and use alias min_rating
	   max(rating) as max_rating, -- Calculate the maximum rating and use alias max_rating
	   avg(rating) as avg_rating, -- Calculate the average rating and use alias avg_rating
	   count(rating) as number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
where movie_id = 25; -- Select all records of the movie with ID 25
-----------------------------------------------------
-- managed to extract all KPIs from the renting records by working with aggregations, NULL values and dates

SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    count(rating)  AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';
-------------------------------------------------------
--First account for each country.
SELECT country, -- For each country report the earliest date when an account was created
	min(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account asc;
-----------------------------------------------------------------------------
--Average movie ratings

SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
order by avg_rating desc; -- Order by average rating in decreasing order

--------------------------------------------------------------------------------
--Average rating per customer
SELECT customer_id, -- Report the customer_id
      avg(rating),  -- Report the average rating per customer
      count(rating),  -- Report the number of ratings per customer
      count(movie_id)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
having count(movie_id) >7 -- Select only customers with more than 7 movie rentals
ORDER BY avg(rating); -- Order by the average rating in ascending order

----------------------------------------------------------------------------------
--Join renting and customers
SELECT avg(r.rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';

----------------------------------------------------------------------------
--Aggregating revenue, rentals and active customers
SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting between '2018-01-01' and '2018-12-31' ;

--------------------------------------------------------------------
--movies and actors using joins
SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin as ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;
-----------------------------------------------------
--Income from movies
SELECT rm.title, -- Report the income from movie rentals for each movie 
       sum(rm.renting_price) AS income_movie
FROM
       (SELECT m.title,  
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
group by title
ORDER BY income_movie desc; -- Order the result by decreasing income
---------------------------------------------------------------------------------------
--Age of actors from the USA
SELECT a.gender, -- Report for male and female actors from the USA 
       MIN(a.year_of_birth), -- The year of birth of the oldest actor
       MAX(a.year_of_birth) -- The year of birth of the youngest actor
FROM
    (SELECT * -- Use a subsequent SELECT to get all information about actors from the USA
    FROM actors
    WHERE nationality = 'USA') AS a -- Give the table the name a
GROUP BY a.gender;
---------------------------------------------------------------------------------------------
--Identify favorite movies for a group of customers

SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
having count(*) >1
 -- Remove movies with only one rental
ORDER BY count(r.rating) desc ; -- Order with highest rating first
----------------------------------------------------------------------------------------------
--Identify favorite actors for Spain
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
where country = 'Spain' -- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 
ORDER BY avg_rating DESC, number_views DESC;
-----------------------------------------------------------------------
--KPIs per country
SELECT 
	country  ,                  -- For each country report
	count(*) AS number_renting, -- The number of movie rentals
	avg(rating) AS average_rating, -- The average rating
	sum(m.renting_price) AS revenue         -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
group by country;
---------------------------------------------------------------------------
--Often rented movies
SELECT *
FROM movies
where movie_id in -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5;
-------------------------------------------------------------

--Frequent customers
SELECT *
FROM customers
WHERE customer_id IN -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING COUNT(*) > 10);
-----------------------------------------------------------------------------
--Movies with rating above average
SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id IN
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));

----------------------------------------------------------------------------------
--Analyzing customer behavior
-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 > 
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);
----------------------------------------------------------------------------------
--Customers who gave low ratings
SELECT *
FROM customers as c
WHERE 4> -- Select all customers with a minimum rating smaller than 4 
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);
-----------------------------------------------------------------------------------
--Movies and ratings with correlated queries
SELECT *
FROM movies AS m
WHERE 8< -- Select all movies with an average rating higher than 8
	(SELECT avg(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);
------------------------------------------------------------------------------------
--Customers with at least one rating
SELECT *
FROM customers as c -- Select all customers with at least one rating
WHERE exists
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);
-----------------------------------------------------------------
--Actors in comedies
SELECT a.nationality,count(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
group by a.nationality;
----------------------------------------------------------------------------------------------
--Dramas with high ratings
SELECT *
FROM movies
where movie_id = -- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);
--------------------------------------------------------------------

--Groups of customers
SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   count(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;
-----------------------------------------------------------------
--Analyzing average ratings
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
group by cube(country,genre); -- For all aggregation levels of country and genre
----------------------------------------------------------------------
--Number of customers
-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
group by rollup (country,gender)
-- Order the result by country and gender
order by country,gender
----------------------------------------------------------------------------
--Analyzing preferences of genres across countries
-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY rollup (country,genre)
ORDER BY c.country, m.genre;
------------------------------------------------------------------------------------
--Exploring nationality and gender of actors
SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

-----------------------------------------------------------------------------
--Exploring rating by country and gender
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY cube (country, gender);
-----------------------------------------------------------------------------------------------

--Customer preference for genres
SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
order by avg_rating; -- Order the table by decreasing average rating
--------------------------------------------------------------------------
--Customer preference for actors
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY cube (nationality , gender); -- Provide results for all aggregation levels represented in a pivot table



