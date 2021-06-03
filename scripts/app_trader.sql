-- App Trader Project
-- Darcy Mack

/* 
- What genres are the most worth investing in?
- What content ratings are the most worth investing in?
- What price ranges are the most worth investing in?
- What 10 apps do we most recommend? 
*/ 

-- EXPLORATION
-----------------

SELECT *
FROM app_store_apps
ORDER BY name;


SELECT *
FROM play_store_apps
ORDER BY name;
			
			
SELECT DISTINCT * 
FROM app_store_apps INNER JOIN play_store_apps
	ON app_store_apps.name = play_store_apps.name
ORDER BY app_store_apps.name;
	-- Gets all info for apps in both stores. Includes duplicates. (500 rows)


SELECT DISTINCT app_store_apps.name, app_store_apps.size_bytes, app_store_apps.currency,
				app_store_apps.price, app_store_apps.rating, app_store_apps.content_rating,
				app_store_apps.primary_genre, play_store_apps.name, 
				play_store_apps.rating, 
				play_store_apps.type, play_store_apps.price, play_store_apps.content_rating, 
				play_store_apps.genres
FROM app_store_apps INNER JOIN play_store_apps
	ON app_store_apps.name = play_store_apps.name
ORDER BY app_store_apps.name;
	/* Gets all info for apps in both stores, excluding the review_count columns in both 
	   tables and the category, size, and install_count columns from play_store_apps so there aren't duplicates. 
	   (329 rows) */



-- CLEANED JOINED TABLE CTE
-----------------------------
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
			 			app_store_apps.price AS app_store_price,
			 			ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
			 			app_store_apps.content_rating AS app_store_content_rating,
			 			app_store_apps.primary_genre AS app_store_primary_genre,
			 			play_store_apps.genres AS play_store_genres,
			 			ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
			 			TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
			 			play_store_apps.content_rating AS play_store_content_rating,
					    ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+.5),1) AS lifespan
					 	FROM app_store_apps INNER JOIN play_store_apps
						ON app_store_apps.name = play_store_apps.name
						ORDER BY app_store_apps.name)
SELECT *
FROM both_stores;


 
 -- PROFITS
--------------
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
			 			app_store_apps.price AS app_store_price,
			 			ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
			 			app_store_apps.content_rating AS app_store_content_rating,
			 			app_store_apps.primary_genre AS app_store_primary_genre,
			 			play_store_apps.genres AS play_store_genres,
			 			ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
			 			TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
			 			play_store_apps.content_rating AS play_store_content_rating
					 	FROM app_store_apps INNER JOIN play_store_apps
						ON app_store_apps.name = play_store_apps.name
						ORDER BY app_store_apps.name),
	both_stores_lifespan AS (SELECT *, 
							   ROUND((app_store_round_rating/0.5),1) 
							 	  AS app_store_lifespan,
							   ROUND((play_store_round_rating/0.5),1) 
							 	  AS play_store_lifespan
							 FROM both_stores),
	both_stores_each_profit AS (SELECT *,
						   		(2000*12*app_store_lifespan)-(app_store_price*10000) AS app_store_profit,
						   		(2000*12*play_store_lifespan)-(play_store_price*10000) AS play_store_profit
						  		FROM both_stores_lifespan),
	both_stores_total_profit AS (SELECT *,
									app_store_profit + play_store_profit AS total_profit
								 FROM both_stores_each_profit)
SELECT *
FROM both_stores_total_profit
ORDER BY total_profit DESC;

/* - Removed lifespan from first CTE because I wanted to calculate the lifespan for each rating in each store
     because it gives a more accurate result
   - Adjusted lifespan formula because it was giving 10.5 for PewDiePie's Tuber Simulator
            - Removed the (+0.5) because it wasn't needed
   - Added 3 more CTEs:
			1. both_stores_lifespan to get the lifespan for an app in each store
			2. both_stores_each profit to get the profit for an app in each store (if app trader purchases both)
			3. both_storeS_total_profit to get the total profit for an app bought in both stores
   - Sorted by total_profit descending */






/***** 

OLD/UNNEEDED

-- RECOMMENDED PRICE RANGE
------------------------------------------------------------------------------------------------

-- Less than or equal to $1.00
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
			 			app_store_apps.price AS app_store_price,
			 			ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
			 			app_store_apps.content_rating AS app_store_content_rating,
			 			app_store_apps.primary_genre AS app_store_primary_genre,
			 			play_store_apps.genres AS play_store_genres,
			 			ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
			 			TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
			 			play_store_apps.content_rating AS play_store_content_rating,
					    ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+.5),1) AS lifespan
						FROM app_store_apps INNER JOIN play_store_apps
						ON app_store_apps.name = play_store_apps.name
						ORDER BY app_store_apps.name)
SELECT name, app_store_price, lifespan, play_store_price, lifespan
FROM both_stores
WHERE app_store_price <= 1
	OR play_store_price <= 1
ORDER BY lifespan DESC;

-- Greater than or equal to $1.00
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
			 			app_store_apps.price AS app_store_price,
			 			ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
			 			app_store_apps.content_rating AS app_store_content_rating,
			 			app_store_apps.primary_genre AS app_store_primary_genre,
			 			play_store_apps.genres AS play_store_genres,
			 			ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
			 			TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
			 			play_store_apps.content_rating AS play_store_content_rating,
					    ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+.5),1) AS lifespan
						FROM app_store_apps INNER JOIN play_store_apps
						ON app_store_apps.name = play_store_apps.name
						ORDER BY app_store_apps.name)
SELECT name, app_store_price, lifespan, play_store_price, lifespan
FROM both_stores
WHERE app_store_price >= 1
	OR play_store_price >= 1
ORDER BY lifespan DESC;

/* For apps in both stores that are less than or equal to $1.00, 49.3% of them have a 
   lifespan of 9.5 years or more. For apps in both stores that are greater than or equal
   to $1.00, 50.8% percent of them have a lifespan of 9.5 years or more. Because there isn't
   a significant difference between the lifespan among price ranges, we recommend only purchasing 
   apps that are priced at $1.00 or less. */ 
   
 ******/ 
