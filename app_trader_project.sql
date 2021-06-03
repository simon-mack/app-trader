-----------------------------------------------------------------ALL SELECT *
------------------------------------------APP STORE
SELECT *
FROM app_store_apps;
--7197 rows

------------------------------------------PLAY STORE
SELECT *
FROM play_store_apps;
--10840 rows

-----------------------------------------------------------------DISTINCT content_rating
------------------------------------------APP STORE
SELECT DISTINCT content_rating
FROM app_store_apps;

/*
4+
9+
12+
17+
*/

------------------------------------------PLAY STORE
SELECT DISTINCT content_rating
FROM play_store_apps;

/*
Everyone
Everyone 10+
Teen
Mature 17+
Adults only 18+
Unrated
*/

-----------------------------------------------------------------DISTINCT primary_genre / category
------------------------------------------APP STORE
SELECT DISTINCT primary_genre
FROM app_store_apps
ORDER BY primary_genre;

/* *** IS CALLED category in play ***
Count: 23
Book
Business
Catalogs
Education
Entertainment
Finance
Food & Drink
Games
Health & Fitness
Lifestyle
Medical
Music
Navigation
News
Photo & Video
Productivity
Reference
Shopping
Social Networking
Sports
Travel
Utilities
Weather
*/

------------------------------------------PLAY STORE
SELECT DISTINCT category
FROM play_store_apps
ORDER BY category;

/* *** IS CALLED primary_genre in app ***
Count: 33
ART_AND_DESIGN
AUTO_AND_VEHICLES
BEAUTY
BOOKS_AND_REFERENCE
BUSINESS
COMICS
COMMUNICATION
DATING
EDUCATION
ENTERTAINMENT
EVENTS
FAMILY
FINANCE
FOOD_AND_DRINK
GAME
HOUSE_AND_HOME
LIBRARIES_AND_DEMO
LIFESTYLE
MAPS_AND_NAVIGATION
MEDICAL
NEWS_AND_MAGAZINES
PARENTING
PERSONALIZATION
PHOTOGRAPHY
PRODUCTIVITY
SHOPPING
SOCIAL
SPORTS
TOOLS
TRAVEL_AND_LOCAL
VIDEO_PLAYERS
WEATHER
*/

-----------------------------------------------------------------DISTINCT price
------------------------------------------APP STORE
SELECT DISTINCT price
FROM app_store_apps
ORDER BY price;

/* *** IS numeric HERE, BUT IS text IN play ***
Count: 36
0.00
0.99
1.99
2.99
3.99
4.99
5.99
6.99
7.99
8.99
9.99
11.99
12.99
13.99
14.99
15.99
16.99
17.99
18.99
19.99
20.99
21.99
22.99
23.99
24.99
27.99
29.99
34.99
39.99
47.99
49.99
59.99
74.99
99.99
249.99
299.99
*/


------------------------------------------PLAY STORE
SELECT DISTINCT TRIM('$' FROM price)::numeric AS price
FROM play_store_apps
ORDER BY price;
/* *** IS text HERE, BUT IS numeric IN app ***
***above has dropped $ and made it numeric
Count: 92
0
0.99
1.00
1.04
1.20
1.26
1.29
1.49
1.50
1.59
1.61
1.70
1.75
1.76
1.96
1.97
1.99
2.00
2.49
2.50
2.56
2.59
2.60
2.90
2.95
2.99
3.02
3.04
3.08
3.28
3.49
3.61
3.88
3.90
3.95
3.99
4.29
4.49
4.59
4.60
4.77
4.80
4.84
4.85
4.99
5.00
5.49
5.99
6.49
6.99
7.49
7.99
8.49
8.99
9.00
9.99
10.00
10.99
11.99
12.99
13.99
14.00
14.99
15.46
15.99
16.99
17.99
18.99
19.40
19.90
19.99
24.99
25.99
28.99
29.99
30.99
33.99
37.99
39.99
46.99
74.99
79.99
89.99
109.99
154.99
200.00
299.99
379.99
389.99
394.99
399.99
400.00
*/

------------------------------------------------------------------------------------------INNER JOIN ON APP & PLAY STORE NAME-------------------------------------------------------


WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
									app_store_apps.price AS app_store_price,
									ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
									app_store_apps.content_rating AS app_store_content_rating,
									app_store_apps.primary_genre AS app_store_primary_genre,
									play_store_apps.genres AS play_store_genres,
									ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
									TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
									play_store_apps.content_rating AS play_store_content_rating,
					 				ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+1),1) AS lifespan
					 FROM app_store_apps INNER JOIN play_store_apps
					 ON app_store_apps.name = play_store_apps.name
					 ORDER BY app_store_apps.name)
SELECT *
FROM both_stores;

-------------329 rows



WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
									app_store_apps.price AS app_store_price,
									ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
									app_store_apps.content_rating AS app_store_content_rating,
									app_store_apps.primary_genre AS app_store_primary_genre,
									play_store_apps.genres AS play_store_genres,
									ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
									TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
									play_store_apps.content_rating AS play_store_content_rating,
					 				ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/1)+1),1) AS lifespan,
					 				TRIM('+' FROM play_store_apps.install_count) AS install_count
					 FROM app_store_apps INNER JOIN play_store_apps
					 ON app_store_apps.name = play_store_apps.name
					 ORDER BY app_store_apps.name)
SELECT name, lifespan, app_store_primary_genre, play_store_genres, install_count
FROM both_stores
WHERE lifespan >= '9.5'
AND (play_store_price <= 1.00 OR app_store_price <=1.00)
ORDER by lifespan DESC, install_count DESC, play_store_price DESC, app_store_price DESC
LIMIT 30;

--------------30 ROWS


---------------------------------------
WITH both_stores AS (SELECT DISTINCT app_store_apps.name,
									app_store_apps.price AS app_store_price,
									ROUND(ROUND(app_store_apps.rating/5,1)*5,1) AS app_store_round_rating,
									app_store_apps.content_rating AS app_store_content_rating,
									app_store_apps.primary_genre AS app_store_primary_genre,
									play_store_apps.genres AS play_store_genres,
									ROUND(ROUND(play_store_apps.rating/5,1)*5,1) AS play_store_round_rating,
									TRIM('$' FROM play_store_apps.price)::numeric AS play_store_price,
									play_store_apps.content_rating AS play_store_content_rating,
					 				ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+1),1) AS lifespan,
					 				ROUND(((((ROUND(ROUND(app_store_apps.rating/5,1)*5,1) + ROUND(ROUND(play_store_apps.rating/5,1)*5,1))/2)/0.5)+1),1)*12 AS lifespan_mths
					 FROM app_store_apps INNER JOIN play_store_apps
					 ON app_store_apps.name = play_store_apps.name
					 ORDER BY app_store_apps.name)
SELECT SUM((app_store_price/1*10000)
FROM both_stores
ORDER BY lifespan DESC;
		   
		   
-------------------------------------------------------------

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
							(2000*12*app_store_lifespan)-(CASE WHEN app_store_price <1 THEN 10000
														  ELSE app_store_price*10000 END) AS app_store_profit,
							(2000*12*play_store_lifespan)-(CASE WHEN play_store_price <1 THEN 10000
														   ELSE play_store_price*10000 END) AS play_store_profit
							FROM both_stores_lifespan),
both_stores_total_profit AS (SELECT *,
							 app_store_profit + play_store_profit AS total_profit
							 FROM both_stores_each_profit)
SELECT *
FROM both_stores_total_profit
ORDER BY total_profit DESC;


		   
		   
		   
		   
		   
		   