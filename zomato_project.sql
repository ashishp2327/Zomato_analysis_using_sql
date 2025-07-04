
-- Create Zomato Table
DROP TABLE IF EXISTS zomato;
CREATE TABLE zomato (
    restaurant_id INT,
    restaurant_name TEXT,
    city TEXT,
    cuisines TEXT,
    average_cost_for_two INT,
    price_range INT,
    has_online_delivery TEXT,
    has_table_booking TEXT,
    aggregate_rating FLOAT,
    votes INT
);

-- 1. Total number of restaurants
SELECT COUNT(*) AS total_restaurants FROM zomato;

-- 2. Top 5 cities with most restaurants
SELECT city, COUNT(*) AS total
FROM zomato
GROUP BY city
ORDER BY total DESC
LIMIT 5;

-- 3. Most common cuisines
SELECT cuisines, COUNT(*) AS freq
FROM zomato
GROUP BY cuisines
ORDER BY freq DESC
LIMIT 10;

-- 4. Restaurants with rating ≥ 4.5
SELECT restaurant_name, city, aggregate_rating
FROM zomato
WHERE aggregate_rating >= 4.5
ORDER BY aggregate_rating DESC;

-- 5. Average cost for two in each city
SELECT city, AVG(average_cost_for_two) AS avg_cost
FROM zomato
GROUP BY city
ORDER BY avg_cost DESC;

-- 6. Most expensive cuisines (avg cost)
SELECT cuisines, AVG(average_cost_for_two) AS avg_cost
FROM zomato
GROUP BY cuisines
ORDER BY avg_cost DESC
LIMIT 10;

-- 7. Cities with highest avg rating
SELECT city, AVG(aggregate_rating) AS avg_rating
FROM zomato
GROUP BY city
ORDER BY avg_rating DESC
LIMIT 5;

-- 8. Number of restaurants with online delivery
SELECT COUNT(*) AS online_delivery_count
FROM zomato
WHERE has_online_delivery = 'Yes';

-- 9. Number of restaurants offering both online delivery & table booking
SELECT COUNT(*) AS both_services
FROM zomato
WHERE has_online_delivery = 'Yes' AND has_table_booking = 'Yes';

-- 10. Top-rated restaurants in Delhi NCR
SELECT restaurant_name, aggregate_rating, votes
FROM zomato
WHERE city = 'Delhi NCR' AND aggregate_rating >= 4.5
ORDER BY aggregate_rating DESC;

-- 11. Cuisine with highest number of votes (popularity)
SELECT cuisines, SUM(votes) AS total_votes
FROM zomato
GROUP BY cuisines
ORDER BY total_votes DESC
LIMIT 5;
