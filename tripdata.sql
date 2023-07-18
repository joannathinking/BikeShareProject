USE cyclist;

-- select data that we are going to start with.
SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    member_casual
FROM tripdata
ORDER BY 
	started_at,
    ended_at;


-- check the missing data.

SELECT 
	count(*) AS total_records,
	count(ride_id) AS total_id,
    count(rideable_type) AS total_type,
    count(started_at) AS total_start,
    count(ended_at) AS total_end,
    count(member_casual) AS total_member_casual
FROM tripdata;


-- member and casual percentage.

SELECT 
(SELECT count(ride_id)
FROM tripdata
WHERE member_casual = 'member'
GROUP BY member_casual
) / count(member_casual) AS member_per,
(SELECT count(ride_id)
FROM tripdata
WHERE member_casual = 'casual'
GROUP BY member_casual
) / count(member_casual) AS casual_per
FROM tripdata;


-- standardize date	format.

SELECT
	CAST(started_at AS datetime),
    CAST(ended_at AS datetime)
FROM tripdata;

UPDATE tripdata
SET started_at = CAST(started_at AS datetime);

UPDATE tripdata
SET ended_at = CAST(ended_at AS datetime);


-- calculate the usage of the bike.

SELECT 
	member_casual,
    started_at, 
    ended_at,
    TIMESTAMPDIFF(minute, started_at, ended_at) AS bike_usage_min
FROM tripdata
WHERE TIMESTAMPDIFF(minute, started_at, ended_at) > 0;


-- calculate members and casuals' average bike usage.

WITH bike_usage_CTE AS (
SELECT 
	member_casual,
    started_at, 
    ended_at,
    TIMESTAMPDIFF(minute, started_at, ended_at) AS bike_usage_min
FROM tripdata
WHERE TIMESTAMPDIFF(minute, started_at, ended_at) > 0
)

SELECT 
	member_casual,
    AVG(bike_usage_min) AS avg_usage
FROM bike_usage_CTE
GROUP BY member_casual;


-- 24 hours trends

SELECT
	HOUR(started_at) AS time_hr,
	COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY HOUR(started_at), member_casual
ORDER BY HOUR(started_at);


-- weekly trends

SELECT
	-- DAYOFWEEK(started_at),
    DAYNAME(started_at) AS time_day,
	COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY 
	DAYOFWEEK(started_at), 
    DAYNAME(started_at),
    member_casual
ORDER BY DAYOFWEEK(started_at);


-- monthly trends

SELECT
	-- MONTH(started_at),
	MONTHNAME(started_at) AS time_day,
	COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY 
	MONTHNAME(started_at), 
    MONTH(started_at),
    member_casual
ORDER BY MONTH(started_at);


-- check different bike type usage

SELECT 
	rideable_type,
    COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY 
	rideable_type,
    member_casual
ORDER BY rideable_type;


-- check different bike type average using time

WITH bike_usage_CTE AS (
SELECT 
	rideable_type,
	member_casual,
    started_at, 
    ended_at,
    TIMESTAMPDIFF(minute, started_at, ended_at) AS bike_usage_min
FROM tripdata
WHERE TIMESTAMPDIFF(minute, started_at, ended_at) > 0
)

SELECT 
	rideable_type,
	member_casual,
    AVG(bike_usage_min) AS avg_usage
FROM bike_usage_CTE
GROUP BY 
	member_casual,
    rideable_type
ORDER BY rideable_type;


-- different types of bike 24 hour trends

SELECT
	rideable_type,
	HOUR(started_at) AS time_hr,
	COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY 
	HOUR(started_at), 
    member_casual,
    rideable_type
ORDER BY HOUR(started_at);


-- different types of bike weekly trends

SELECT
	-- DAYOFWEEK(started_at),
    rideable_type,
    DAYNAME(started_at) AS time_day,
	COUNT(ride_id) AS bike_using,
    member_casual
FROM tripdata
GROUP BY 
	rideable_type,
	DAYOFWEEK(started_at), 
    DAYNAME(started_at),
    member_casual
ORDER BY DAYOFWEEK(started_at);


-- different types of bike weekly trends

SELECT 
    rideable_type,
    MONTHNAME(started_at) AS time_day,
    COUNT(ride_id) AS bike_using,
    member_casual
FROM
    tripdata
GROUP BY rideable_type , MONTHNAME(started_at) , MONTH(started_at) , member_casual
ORDER BY MONTH(started_at);

    









	