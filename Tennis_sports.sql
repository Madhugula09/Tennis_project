USE tennis_db;
CREATE DATABASE tennis_db;
Select * from competitions;
Select * from Categories;
select * from Complexes;
select * from Competitor_Rankings;
select * from competitors;
select * from Venues;
show tables;
DESC competitor_rankings;
DESC competitors;
DESC Venues;
DESC competitions;
DESC complexes;
DESC Categories;
-- categories_table & competitions_table 
-- 1.) List all competitions along with their category name
SELECT 
    c.competition_id, 
    c.competition_name, 
    c.type, 
    c.gender, 
    cat.category_name
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id;
-- 2.) Count the number of competitions in each category
SELECT 
    cat.category_name, 
    COUNT(c.competition_id) AS competition_count
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
GROUP BY cat.category_name;
-- 3.) Find all competitions of type 'doubles'
SELECT 
    competition_id, 
    competition_name, 
    type, 
    gender, 
    category_id
FROM competitions
WHERE type = 'doubles';
-- 4.) Get competitions that belong to a specific category (e.g., ITF Men)
SELECT 
    c.competition_id, 
    c.competition_name, 
    c.type, 
    c.gender, 
    cat.category_name
FROM competitions c
JOIN categories cat ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men';
-- 5.) Identify parent competitions and their sub-competitions
SELECT 
    cat.category_name, 
    c.competition_id AS parent_competition_id, 
    c.competition_name AS parent_competition_name, 
    sub.competition_id AS sub_competition_id, 
    sub.competition_name AS sub_competition_name
FROM competitions c
JOIN competitions sub 
    ON c.category_id = sub.category_id 
    AND c.type <> sub.type  -- Ensuring they are different types
JOIN categories cat 
    ON c.category_id = cat.category_id;
-- 6.) Analyze the distribution of competition types by category
SELECT 
    cat.category_name, 
    c.type, 
    COUNT(c.competition_id) AS competition_count
FROM competitions c
JOIN categories cat 
    ON c.category_id = cat.category_id
GROUP BY cat.category_name, c.type
ORDER BY cat.category_name, competition_count DESC;
-- 7.) List all competitions with no parent (top-level competitions)
SELECT 
    c.competition_id, 
    c.competition_name, 
    c.type, 
    cat.category_name
FROM competitions c
JOIN categories cat 
    ON c.category_id = cat.category_id
LEFT JOIN competitions sub 
    ON c.competition_id = sub.parent_competition_id
WHERE sub.parent_competition_id IS NULL;
--- Complexes Table & Venues Table ---
-- 1.) List all venues along with their associated complex name
SELECT 
    v.venue_id, 
    v.venue_name, 
    v.city_name, 
    v.country_name, 
    v.country_code, 
    v.timezone, 
    c.complex_name
FROM venues v
LEFT JOIN complexes c 
    ON v.complex_id = c.complex_id;
-- 2.) Count the number of venues in each complex
SELECT 
    c.complex_id, 
    c.complex_name, 
    COUNT(v.venue_id) AS total_venues
FROM complexes c
LEFT JOIN venues v 
    ON c.complex_id = v.complex_id
GROUP BY c.complex_id, c.complex_name
ORDER BY total_venues DESC;
-- 3.) Get details of venues in a specific country (e.g., Chile)
SELECT 
    venue_id, 
    venue_name, 
    city_name, 
    country_name, 
    country_code, 
    timezone, 
    complex_id
FROM venues
WHERE country_name = 'Chile';
-- 4.) Identify all venues and their timezones
SELECT 
    venue_id, 
    venue_name, 
    city_name, 
    country_name, 
    country_code, 
    timezone
FROM venues;
-- 5.) Find complexes that have more than one venue
SELECT 
    c.complex_id, 
    c.complex_name, 
    COUNT(v.venue_id) AS total_venues
FROM complexes c
JOIN venues v 
    ON c.complex_id = v.complex_id
GROUP BY c.complex_id, c.complex_name
HAVING COUNT(v.venue_id) > 1
ORDER BY total_venues DESC;
-- 6.) List venues grouped by country
SELECT 
    country_name, 
    COUNT(venue_id) AS total_venues
FROM venues
GROUP BY country_name
ORDER BY total_venues DESC;
-- 7.) Find all venues for a specific complex (e.g., Nacional)
SELECT 
    v.venue_id, 
    v.venue_name, 
    v.city_name, 
    v.country_name, 
    v.country_code, 
    v.timezone, 
    c.complex_name
FROM venues v
JOIN complexes c 
    ON v.complex_id = c.complex_id
WHERE c.complex_name = 'Nacional';
---------------------- Competitor_Rankings Table & Competitors Table ---------------------
-- 1.) Get all competitors with their rank and points.
SELECT 
    c.competitor_id, 
    c.name, 
    c.country, 
    c.country_code, 
    cr.rank, 
    cr.points
FROM competitors c
JOIN competitor_rankings cr 
    ON c.competitor_id = cr.competitor_id
ORDER BY cr.rank;
-- 2.) Find competitors ranked in the top 5
SELECT 
    c.competitor_id, 
    c.name, 
    c.country, 
    c.country_code, 
    cr.rank, 
    cr.points
FROM competitors c
JOIN competitor_rankings cr 
    ON c.competitor_id = cr.competitor_id
WHERE cr.rank <= 5
ORDER BY cr.rank;
-- 3.) List competitors with no rank movement (stable rank)
SELECT 
    c.competitor_id, 
    c.name, 
    c.country, 
    c.country_code, 
    cr.rank, 
    cr.points, 
    cr.movement
FROM competitors c
JOIN competitor_rankings cr 
    ON c.competitor_id = cr.competitor_id
WHERE cr.movement = 0
ORDER BY cr.rank;
-- 4.) Get the total points of competitors from a specific country (e.g., Croatia)
SELECT 
    c.country, 
    SUM(cr.points) AS total_points
FROM competitors c
JOIN competitor_rankings cr 
    ON c.competitor_id = cr.competitor_id
WHERE c.country = 'Croatia'
GROUP BY c.country;
-- 5.) Count the number of competitors per country
SELECT 
    c.country, 
    COUNT(c.competitor_id) AS total_competitors
FROM competitors c
GROUP BY c.country
ORDER BY total_competitors DESC;
-- 6.) Find competitors with the highest points in the current week
SELECT 
    c.competitor_id, 
    c.name, 
    c.country, 
    cr.rank, 
    cr.points
FROM competitors c
JOIN competitor_rankings cr 
    ON c.competitor_id = cr.competitor_id
ORDER BY cr.points DESC
LIMIT 10;