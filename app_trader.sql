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
							 ROUND(((app_store_round_rating/0.5)+1),1) AS app_store_lifespan,
							 ROUND(((play_store_round_rating/0.5)+1),1) AS play_store_lifespan
							FROM both_stores),
	both_stores_each_profit AS (SELECT *,
								(500*12*app_store_lifespan)+(CASE WHEN app_store_price <1 THEN 10000
 																ELSE app_store_price*10000 END) AS app_store_cost,
								(500*12*play_store_lifespan)+(CASE WHEN play_store_price <1 THEN 10000
								  								ELSE play_store_price*10000 END) AS play_store_cost,
								(2000*12*app_store_lifespan)-(CASE WHEN app_store_price <1 THEN 10000
								 								ELSE app_store_price*10000 END) AS app_store_profit,
								(2000*12*play_store_lifespan)-(CASE WHEN play_store_price <1 THEN 10000
								  								ELSE play_store_price*10000 END) AS play_store_profit,
								(2500*12*app_store_lifespan)+(CASE WHEN app_store_price <1 THEN 10000
								 								ELSE app_store_price*10000 END) AS app_store_dev_make,
								(2500*12*play_store_lifespan)+(CASE WHEN app_store_price <1 THEN 10000
								 								ELSE app_store_price*10000 END) AS play_store_dev_make
								 FROM both_stores_lifespan),
	both_stores_total_profit AS (SELECT *,
								app_store_cost + play_store_cost AS total_cost,
								app_store_dev_make + play_store_dev_make AS total_dev_makes,
								app_store_profit + play_store_profit AS total_profit
								FROM both_stores_each_profit)
SELECT *
FROM both_stores_total_profit
ORDER BY total_profit DESC;