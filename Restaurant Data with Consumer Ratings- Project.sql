USE [Resturants]

--How many pepole in each city?
SELECT CITY, COUNT(*)
FROM consumers
GROUP BY CITY 


--What is the avarage age by city?
SELECT City, AVG(Age) AS AVG_AGE
FROM consumers
GROUP BY CITY


-- What is the Preferred cuisine in each city?
SELECT CN.City,
		CNP.Preferred_Cuisine,
		COUNT(*) AS CNT,
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CN.CITY)*100 AS PCT
FROM consumers CN
JOIN consumer_preferences CNP
	ON CN.Consumer_ID=CNP.Consumer_ID
GROUP BY CN.City,CNP.Preferred_Cuisine
ORDER BY CN.City, CNT DESC

-- How many restaurants from each cuisine type there are in each city?
SELECT rs.City,
		rsc.Cuisine, 
		COUNT(*) AS CNT 
FROM  restaurants rs
JOIN  restaurant_cuisines  rsc
	ON rs.Restaurant_ID= rsc.Restaurant_ID
GROUP BY rs.City, rsc.Cuisine
ORDER BY rs.City, CNT DESC


SELECT  RES.City,
		res.Smoking_Allowed,
		AVG(rt.Food_Rating) AS AVG_Food_Rating,
		AVG(rt.Overall_Rating) AS AVG_Overall_Rating,
		AVG(rt.Service_Rating) AS AVG_Service_Rating
FROM  restaurants res
JOIN ratings  rt
	ON rt.Restaurant_ID=res.Restaurant_ID
GROUP BY res.Smoking_Allowed,RES.City

--What percentage of the customers drinks, divided by cities.
SELECT CITY,
		Drink_Level, COUNT(*) AS 'CNT',
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Drink_Level
ORDER BY CITY,COUNT(*) DESC



--What is the customer's budget by city?
SELECT CITY, Budget,
		COUNT(*) AS 'NUM_OF_PPL',
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Budget
ORDER BY CITY, PCT DESC

--What percentage of the customers smoking, divided by cities.
SELECT CITY,
		Smoker,
		COUNT(*) AS 'NUM_OF_PPL',
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Smoker
ORDER BY CITY, PCT DESC

--What kind of transportation the customer's using in each city?
SELECT City,
		Transportation_Method,
		COUNT(*) AS 'NUM_OF_PPL',
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Transportation_Method
ORDER BY CITY, PCT DESC

-- What is the customer's Merital_status by city?
SELECT CITY,
		Marital_Status,
		COUNT(*) AS 'NUM_OF_PPL',
		COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Marital_Status
ORDER BY CITY, PCT DESC


-- What is the occupation status in each city?
SELECT CITY,
		Occupation, COUNT(*) AS 'NUM_OF_PPL',
		 COUNT(*)*1.0/SUM(COUNT(*)) OVER(PARTITION BY CITY)*100 AS PCT
FROM consumers
GROUP BY CITY, Occupation
ORDER BY CITY, PCT DESC

--The customers AVG rating of the restaurant divided by the smoking allowed using Pivot

--The Overall rating
SELECT * 
FROM (SELECT res.Smoking_Allowed, cn.Smoker,CAST(rt.Overall_Rating AS decimal(3,2)) AS Overall_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Overall_Rating) FOR Smoking_Allowed IN ([Bar Only],[Smoking Section],[No],[Yes])) AS PVT
 
--The Food rating

SELECT * 
FROM (SELECT res.Smoking_Allowed, cn.Smoker,CAST(rt.Food_Rating AS decimal(3,2)) AS Food_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Food_Rating) FOR Smoking_Allowed IN ([Bar Only],[Smoking Section],[No],[Yes])) AS PVT

--The Service rating
SELECT * 
FROM (SELECT res.Smoking_Allowed, cn.Smoker,CAST(rt.Service_Rating AS decimal(3,2)) AS Service_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Service_Rating) FOR Smoking_Allowed IN ([Bar Only],[Smoking Section],[No],[Yes])) AS PVT



--The customers AVG rating of the restaurant by the different Budget and resturants price.

SELECT cn.Budget,
		res.Price AS res_price,
		AVG(rt.Food_Rating*1.0) AS AVG_Food_Rating,
		AVG(rt.Overall_Rating*1.0) AS AVG_Overall_Rating,
		AVG(rt.Service_Rating*1.0) AS AVG_Service_Rating
FROM consumers cn
JOIN ratings rt 
	ON rt.Consumer_ID=cn.Consumer_ID
JOIN restaurants res 
	ON res.Restaurant_ID=rt.Restaurant_ID
GROUP BY cn.Budget,res.Price
ORDER BY cn.Budget,AVG(rt.Overall_Rating)

--The customers with cars AVG rating of the restaurant considering the resturant parking.

SELECT res.Parking,
		AVG(rt.Food_Rating*1.0) AS AVG_Food_Rating,
		AVG(rt.Overall_Rating*1.0) AS AVG_Overall_Rating,
		AVG(rt.Service_Rating*1.0) AS AVG_Service_Rating
FROM consumers cn
JOIN ratings rt 
	ON rt.Consumer_ID=cn.Consumer_ID
JOIN restaurants res 
	ON res.Restaurant_ID=rt.Restaurant_ID
WHERE cn.Transportation_Method='car'
GROUP BY res.Parking
ORDER BY res.Parking,AVG(rt.Overall_Rating)

--The customers AVG rating of the restaurant considering the drinking service in the restaurant and the kind of drinker the customer is.

--The Overall rating
SELECT * 
FROM (SELECT res.Alcohol_Service, cn.Drink_Level, CAST(rt.Overall_Rating AS decimal(3,2)) AS Overall_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Overall_Rating) FOR Alcohol_Service IN ([None],[Wine & Beer],[Full Bar])) AS PVT

--The Food rating
SELECT * 
FROM (SELECT res.Alcohol_Service, cn.Drink_Level, CAST(rt.Food_Rating AS decimal(3,2)) AS Food_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Food_Rating) FOR Alcohol_Service IN ([None],[Wine & Beer],[Full Bar])) AS PVT

--The Service rating
SELECT * 
FROM (SELECT res.Alcohol_Service, cn.Drink_Level, CAST(rt.Service_Rating AS decimal(3,2)) AS Service_Rating  FROM consumers cn JOIN ratings rt
			ON rt.Consumer_ID=cn.Consumer_ID
			JOIN restaurants res 
			ON res.Restaurant_ID=rt.Restaurant_ID) AS TBL
PIVOT (AVG(Service_Rating) FOR Alcohol_Service IN ([None],[Wine & Beer],[Full Bar])) AS PVT


 -- The AVG customers rating of restaurants who does not match to their preferred cuisine
;WITH AVG_RT_PR AS
	(
		SELECT rt.[index],
				rs.Restaurant_ID,
				cn.Consumer_ID,
				rs_c.Cuisine,
				cn_p.Preferred_Cuisine,
				RT.Food_Rating,
				RT.Overall_Rating, 
				RT.Service_Rating,
				ROW_NUMBER() OVER(PARTITION BY rt.[index] ORDER BY (select null)) AS D_ROW
		FROM ratings rt
		left JOIN restaurants rs
			ON rt.Restaurant_ID=rs.Restaurant_ID
		 JOIN consumers cn
			ON cn.Consumer_ID=rt.Consumer_ID
		 JOIN restaurant_cuisines rs_c
			ON rt.Restaurant_ID=rs_c.Restaurant_ID
		 JOIN consumer_preferences	cn_p
			ON cn.Consumer_ID=cn_p.Consumer_ID
		WHERE rs_c.Cuisine=cn_p.Preferred_Cuisine
	),
 AVG_RT_PR2 AS
	(
	SELECT *
	FROM AVG_RT_PR 
	WHERE D_ROW=1
	),
 AVG_RT_NOT_PR AS
	(
	SELECT DISTINCT rt.[index],
				rs.Restaurant_ID,
				cn.Consumer_ID, 
				rs_c.Cuisine, 
				cn_p.Preferred_Cuisine,
				RT.Food_Rating,
				RT.Overall_Rating,
				RT.Service_Rating,
				ROW_NUMBER() OVER(PARTITION BY rt.[index] ORDER BY (select null)) AS D_ROW
	FROM ratings rt
	LEFT JOIN restaurants rs
		ON rt.Restaurant_ID=rs.Restaurant_ID
	 JOIN consumers cn
		ON cn.Consumer_ID=rt.Consumer_ID
	 LEFT JOIN restaurant_cuisines rs_c
		ON rt.Restaurant_ID=rs_c.Restaurant_ID
	 JOIN consumer_preferences	cn_p
		ON cn.Consumer_ID=cn_p.Consumer_ID
	WHERE rs_c.Cuisine!=cn_p.Preferred_Cuisine OR rs_c.Cuisine IS NULL  OR cn_p.Preferred_Cuisine IS NULL
	),
AVG_RT_NOT_PR2 AS
	(
		SELECT *
		FROM AVG_RT_NOT_PR
		WHERE D_ROW=1
	),
REMOVE_DOUBLE AS
	(
		SELECT [INDEX] FROM AVG_RT_NOT_PR2
		INTERSECT
		SELECT [INDEX] FROM AVG_RT_PR2
	)
SELECT AVG(Food_Rating*1.0) AS 'AVG_Food_Rating',
		AVG(Overall_Rating*1.0) AS 'AVG_Overall_Rating',
		AVG(Service_Rating*1.0) AS 'AVG_Service_Rating' 
FROM AVG_RT_NOT_PR2
WHERE [INDEX] NOT IN(SELECT [INDEX] FROM REMOVE_DOUBLE)



--The AVG customers rating of restaurants who does match to their preferred cuisine
;WITH AVG_RT_PR AS
(
	SELECT rt.[index],
		rs.Restaurant_ID,
		cn.Consumer_ID,
		rs_c.Cuisine,
		cn_p.Preferred_Cuisine,
		RT.Food_Rating,
		RT.Overall_Rating,
		RT.Service_Rating,
		ROW_NUMBER() OVER(PARTITION BY rt.[index] ORDER BY (select null)) AS D_ROW
	FROM ratings rt
	left JOIN restaurants rs
		ON rt.Restaurant_ID=rs.Restaurant_ID
	 JOIN consumers cn
		ON cn.Consumer_ID=rt.Consumer_ID
	 JOIN restaurant_cuisines rs_c
		ON rt.Restaurant_ID=rs_c.Restaurant_ID
	 JOIN consumer_preferences	cn_p
		ON cn.Consumer_ID=cn_p.Consumer_ID
	WHERE rs_c.Cuisine=cn_p.Preferred_Cuisine
)
	SELECT AVG(Food_Rating*1.0) AS 'AVG_Food_Rating_pp', AVG(Overall_Rating*1.0) AS 'AVG_Overall_Rating_pp', AVG(Service_Rating*1.0) AS 'AVG_Service_Rating_pp' 
	FROM AVG_RT_PR 
	WHERE D_ROW=1

