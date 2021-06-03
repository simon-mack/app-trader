--1.f
select * 
from app_store_apps;
-- A: 7,197

SELECT *
FROM play_store_apps;
-- A: 10,840

-- INNER JOIN
SELECT  DISTINCT *
FROM play_store_apps
INNER JOIN app_store_apps
ON play_store_apps.name = app_store_apps.name
ORDER BY play_store_apps.name;

SELECT DISTINCT app_store_apps.name, app_store_apps.size_bytes, app_store_apps.currency, 
				app_store_apps.price, app_store_apps.rating, app_store_apps.content_rating, 
				app_store_apps.primary_genre, play_store_apps.name, play_store_apps.rating, 
				play_store_apps.type, play_store_apps.price, play_store_apps.content_rating, 
				play_store_apps.genres
FROM app_store_apps INNER JOIN play_store_apps
	ON app_store_apps.name = play_store_apps.name
ORDER BY app_store_apps.name;

-- CTE 
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
				ORDER BY app_store_apps.name)
				

-- LIFESPAN
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
				ORDER BY app_store_apps.name)
SELECT *, ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+.5),1) AS lifespan  
FROM both_stores;


-- GENRES WORTH INVESTING IN

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
SELECT name, lifespan, app_store_primary_genre, play_store_genres
FROM both_stores
WHERE app_store_primary_genre = 'Games'
AND lifespan = '9.5'
AND app_store_price < 1.00
ORDER BY app_store_price;

select DISTINCT genres
from play_store_apps
ORDER BY genres DESC 

-- extra
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
AND play_store_price <=1
OR app_store_price <=1
ORDER BY lifespan DESC, app_store_primary_genre, play_store_genres;

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
AND (play_store_price <=1 OR app_store_price <=1)
ORDER BY lifespan DESC, play_store_price DESC, app_store_price DESC;

SELECT DISTINCT primary_genre
FROM app_store_apps

SELECT  genres
FROM play_store_apps
ORDER BY genres;

-- CONTENT RATINGS WORTH INVESTING IN







-- PRICE RANGES WORTH INVESTING IN







-- TOP 10 APPS TO ACQUIRE
