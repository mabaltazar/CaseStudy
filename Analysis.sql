-- Number of riders for 2023 and 2024

SELECT 
  member_casual, year, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
GROUP BY
  member_casual, year

  -- number of uses per bike type
SELECT 
  member_casual, year, rideable_type, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
GROUP BY
  member_casual, year, rideable_type

-- Number of rides per month
SELECT 
  member_casual, year, rideable_type, month_name, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
GROUP BY
  member_casual, year, rideable_type, month_name

-- Number of rides per day
SELECT 
  member_casual, year, started_day_name, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
GROUP BY
  member_casual, year, started_day_name

-- Top 5 starting point of riders
SELECT 
  member_casual, year, start_station_name, start_station_id, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
WHERE
  year = 2023
GROUP BY
  member_casual, year, start_station_name, start_station_id
ORDER BY
  ride_count DESC
Limit 10

-- Top 5 ending point of riders
SELECT 
  member_casual, year, end_station_name, end_station_id, COUNT(ride_id) AS ride_count
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
WHERE
  year = 2023
GROUP BY
  member_casual, year, end_station_name, end_station_id
ORDER BY
  ride_count DESC
Limit 10

--Avg ride per month in 2023
SELECT 
  member_casual, year, month_name, AVG(ride_length_minute) AS duration
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
WHERE
  year = 2023
GROUP BY
  member_casual, year, month_name
ORDER BY
  month_name

--Maximum duration per month in 2023
SELECT 
  member_casual, year, month_name, MAX(ride_length_minute) AS duration
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
WHERE
  year = 2023
GROUP BY
  member_casual, year, month_name
ORDER BY
  month_name

-- Average ride per day in 2023
SELECT 
  member_casual, year, started_day_name, AVG(ride_length_minute) AS duration
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.finalized_data`
WHERE
  year = 2023
GROUP BY
  member_casual, year, started_day_name
ORDER BY
  started_day_name
