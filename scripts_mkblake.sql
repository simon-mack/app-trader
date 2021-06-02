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

