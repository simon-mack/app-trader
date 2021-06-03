/*As a follow up to the categories vs genres, you might want to run a COUNT(DISTINCT ()) over both columns to figure out which 
will be useful to you later.*/

SELECT *
FROM app_store_apps;

SELECT DISTINCT *
FROM app_store_apps
ORDER BY name;

SELECT *
FROM play_store_apps
ORDER BY name;
--yields 10840

SELECT DISTINCT *
FROM play_store_apps
ORDER BY name;
-- yields 10355

SELECT DISTINCT *
FROM app_store_apps
INNER JOIN play_store_apps 
ON app_store_apps.name = play_store_apps.name
ORDER BY app_store_apps.name;

/*both_stores CTE, lifespan calculated*/
WITH both_stores AS
				(SELECT DISTINCT app_store_apps.name,
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
FROM both_stores
ORDER BY lifespan DESC;

/*top lifespan, looking at price - without limits, returns 273 rows*/
WITH both_stores AS
				(SELECT DISTINCT app_store_apps.name,
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
FROM both_stores
WHERE lifespan >= 9.5
AND 
(play_store_price <=1.00 OR app_store_price <=1.00)
ORDER BY lifespan DESC, play_store_price DESC, app_store_price DESC;

/*What Genres tend to have the longest lifespan, regardless of price?*/
WITH both_stores AS
				(SELECT DISTINCT app_store_apps.name,
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
FROM both_stores
WHERE lifespan > 9.5
ORDER BY lifespan DESC, play_store_genres, app_store_primary_genre;

/*Darcy + Samantha code, Thursday AM*/
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
					ROUND(((app_store_round_rating/0.5)+1),1)
					AS app_store_lifespan,
					ROUND(((play_store_round_rating/0.5)+1),1)
					AS play_store_lifespan
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

/*Mal, using ERD, app store primary genre, play store category, play store genres - which of these $460,000 profit apps should we pick?*/

WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
					app_store_apps.price AS app_store_price,
					ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
					app_store_apps.content_rating AS app_store_content_rating,
					app_store_apps.primary_genre AS app_store_primary_genre, 
					play_store_apps.category AS play_store_category, 
					play_store_apps.genres AS play_store_genres,
					ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
					TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
					play_store_apps.content_rating AS play_store_content_rating
					FROM app_store_apps INNER JOIN play_store_apps
					ON app_store_apps.name = play_store_apps.name
					ORDER BY app_store_apps.name),
both_stores_lifespan AS (SELECT *,
					ROUND(((app_store_round_rating/0.5)+1),1)
					AS app_store_lifespan,
					ROUND(((play_store_round_rating/0.5)+1),1)
					AS play_store_lifespan
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
	WHERE total_profit >= 460000
	ORDER BY app_store_primary_genre, play_store_category, play_store_genres
	LIMIT 134;
	
/*Mal, pick your $460,000 profit app using the genre, category & genres patterns you see in the top 9*/
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
					app_store_apps.price AS app_store_price,
					ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
					app_store_apps.content_rating AS app_store_content_rating,
					app_store_apps.primary_genre AS app_store_primary_genre, 
					play_store_apps.category AS play_store_category, 
					play_store_apps.genres AS play_store_genres,
					ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
					TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
					play_store_apps.content_rating AS play_store_content_rating
					FROM app_store_apps INNER JOIN play_store_apps
					ON app_store_apps.name = play_store_apps.name
					ORDER BY app_store_apps.name),
both_stores_lifespan AS (SELECT *,
					ROUND(((app_store_round_rating/0.5)+1),1)
					AS app_store_lifespan,
					ROUND(((play_store_round_rating/0.5)+1),1)
					AS play_store_lifespan
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
	WHERE total_profit > 460000
	ORDER BY app_store_primary_genre, play_store_category, play_store_genres;