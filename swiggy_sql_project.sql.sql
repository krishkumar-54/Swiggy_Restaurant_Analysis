-- 1. Cities with Highest Total Restaurant Price Listings

SELECT city, SUM(price) AS total_price
FROM swiggy_data
GROUP BY city
ORDER BY total_price DESC
LIMIT 5 ;

-- 2. Most Popular Restaurants Based on Rating Count

SELECT restaurant, SUM(rating_count) AS total_rating
FROM swiggy_data
GROUP BY restaurant
ORDER BY total_rating DESC
LIMIT 5;

-- 3. Find the city with the fastest average delivery_time.

SELECT city, ROUND(AVG(delivery_time),2) AS avg_ddelivery_time
FROM swiggy_data
GROUP BY city
ORDER BY avg_ddelivery_time
LIMIT 1;

-- 4. Which are the top 5 highest-rated restaurants in each city?

WITH cte AS(
	SELECT city, restaurant, AVG(rating) AS avg_rating
	FROM swiggy_data
	GROUP BY city, restaurant)
SELECT * 
FROM (SELECT city, restaurant, avg_rating, 
	  ROW_NUMBER() OVER (PARTITION BY city ORDER BY avg_rating DESC) AS top_restaurants
      FROM cte
)t 
WHERE top_restaurants <=5;

-- 5. What is the average delivery_time in each city.

SELECT city, ROUND(AVG(delivery_time),2) AS avg_delivery_time
FROM swiggy_data
GROUP BY city
ORDER BY avg_delivery_time;

-- 6. Top 5 Most Popular Restaurants in Each City

WITH cte AS (
    SELECT city,
           restaurant,
           SUM(rating_count) AS total_rating
    FROM swiggy_data
    GROUP BY city, restaurant)
SELECT * FROM(
SELECT city, restaurant, total_rating,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY total_rating DESC) AS most_popular
FROM cte)t
WHERE most_popular <= 5;

-- 7. Find restaurants with faster-than-average delivery_time.

SELECT restaurant, delivery_time
FROM swiggy_data
WHERE delivery_time < (SELECT AVG(delivery_time) 
					   FROM swiggy_data)
ORDER BY delivery_time;

-- 8. Categorize restaurants by price.

SELECT restaurant, price,
CASE
	WHEN price < 300 THEN 'Budget'
    WHEN price <= 700 THEN 'Mid-Range'
    ELSE 'Premium'
END AS category
FROM swiggy_data;

-- 9. Delivery performance categories.

SELECT restaurant, delivery_time,
CASE
	WHEN delivery_time < 30 THEN 'Fast'
    WHEN delivery_time <= 60 THEN 'Moderate'
    ELSE 'Slow'
END AS category
FROM swiggy_data;

-- 10. Fastest restaurants with high rating.

SELECT restaurant, rating, delivery_time
FROM swiggy_data
WHERE rating >= 4 AND delivery_time <=30
ORDER BY rating DESC, delivery_time;