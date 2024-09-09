-- Check if columns is consistent across all tables

WITH columns AS (
SELECT 
  table_name, column_name, data_type
FROM 
  `capstone-projects-434509.Case_Study_Cyclistic.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name IN ('tripdata_202301', 'tripdata_202302', 'tripdata_202303', 'tripdata_2023304', 'tripdata_202401', 'tripdata_202402', 'tripdata_202403', 'tripdata_202404')
  )
SELECT 
  column_name, COUNT(DISTINCT table_name) AS table_count
FROM 
  columns
GROUP BY 
  column_name
HAVING table_count < (SELECT COUNT(DISTINCT table_name) FROM columns); 


-- Combine all tables into one single table

CREATE TABLE capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined AS (
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202301`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202302`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202303`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202304`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202401`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202402`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202403`
  UNION ALL
  SELECT * FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_202404`
)

-- Check for duplicate record

WITH duplicates AS (
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, member_casual
    ) AS row_num
FROM 
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`
)
SELECT *
FROM
  duplicates
WHERE
  row_num > 1;

-- Check the combined data
SELECT *
FROM `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`

-- Check if we can replace the 'null' values by looking into the station name and station id where start lat is 42
SELECT DISTINCT
  start_station_name, start_station_id
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`
WHERE
  start_lat = 42;

-- Check if we can replace the 'null' values by looking into the station name and station id where end lat is 42
SELECT DISTINCT
  end_station_name, end_station_id
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`
WHERE
  end_lat = 42;

-- Check how many type of bike
SELECT DISTINCT
  rideable_type
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`

-- Check member type
SELECT DISTINCT
  member_casual
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`

-- Check if dates are in correct format
SELECT 
  started_at, CHAR_LENGTH(FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', started_at)) AS start_length,
  ended_at, CHAR_LENGTH(FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', ended_at)) AS end_length
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`;

-- Check for null values in all columns
SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_null,
  COUNTIF(rideable_type IS NULL) AS rideable_type_null,
  COUNTIF(started_at IS NULL) AS started_at_null,
  COUNTIF(ended_at IS NULL) AS ended_at_null,
  COUNTIF(start_station_name IS NULL) AS start_station_name_null,
  COUNTIF(start_station_id IS NULL) AS start_station_id_null,
  COUNTIF(end_station_name IS NULL) AS end_station_name_null,
  COUNTIF(end_station_id IS NULL) AS end_station_id_null,
  COUNTIF(start_lat IS NULL) AS start_lat_null,
  COUNTIF(start_lng IS NULL) AS start_lng_null,
  COUNTIF(end_lat IS NULL) AS end_lat_null,
  COUNTIF(end_lng IS NULL) AS end_lng_null,
  COUNTIF(member_casual IS NULL) AS member_casual_null
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`


-- Create a new table to manipulate and clean the data
CREATE TABLE capstone-projects-434509.Case_Study_Cyclistic.cleaned_tripdata_combined AS (
  SELECT *
  FROM
  `capstone-projects-434509.Case_Study_Cyclistic.tripdata_combined`
)

-- Replace null values in start_station_name column
UPDATE 
  `capstone-projects-434509.Case_Study_Cyclistic.cleaned_tripdata_combined`
SET
  start_station_name = IF(start_station_name IS NULL, "Data not provided", start_station_name),
  start_station_id = IF(start_station_id IS NULL, "Data not provided", start_station_id),
  end_station_name = IF(end_station_name IS NULL, "Data not provided", end_station_name),
  end_station_id = IF(end_station_id IS NULL, "Data not provided",end_station_id),
  end_lat = IF(end_lat IS NULL, 0, end_lat),
  end_lng = IF(end_lng IS NULL, 0, end_lng)
WHERE
  ride_id IS NOT NULL

-- Recheck for null values in all columns

SELECT
  COUNTIF(ride_id IS NULL) AS ride_id_null,
  COUNTIF(rideable_type IS NULL) AS rideable_type_null,
  COUNTIF(started_at IS NULL) AS started_at_null,
  COUNTIF(ended_at IS NULL) AS ended_at_null,
  COUNTIF(start_station_name IS NULL) AS start_station_name_null,
  COUNTIF(start_station_id IS NULL) AS start_station_id_null,
  COUNTIF(end_station_name IS NULL) AS end_station_name_null,
  COUNTIF(end_station_id IS NULL) AS end_station_id_null,
  COUNTIF(start_lat IS NULL) AS start_lat_null,
  COUNTIF(start_lng IS NULL) AS start_lng_null,
  COUNTIF(end_lat IS NULL) AS end_lat_null,
  COUNTIF(end_lng IS NULL) AS end_lng_null,
  COUNTIF(member_casual IS NULL) AS member_casual_null
FROM
  `capstone-projects-434509.Case_Study_Cyclistic.cleaned_tripdata_combined`

--Check for additional needed data
SELECT 
  started_at,
  ended_at,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minute,
  EXTRACT (YEAR FROM started_at) AS year,
  FORMAT_TIMESTAMP('%B', started_at) AS month_name,
  EXTRACT (MONTH FROM started_at) AS month_number,
  FORMAT_TIMESTAMP('%A', started_at) AS started_day_name,
  EXTRACT (DAYOFWEEK FROM started_at) AS started_day_of_week,
  FORMAT_TIMESTAMP('%A', ended_at) AS ended_day_name,
  EXTRACT (DAYOFWEEK FROM ended_at) AS ended_day_of_week
FROM 
  `capstone-projects-434509.Case_Study_Cyclistic.cleaned_tripdata_combined`;

-- Create final table for data analysis
CREATE TABLE IF NOT EXISTS capstone-projects-434509.Case_Study_Cyclistic.finalized_data AS (
SELECT 
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minute,
  EXTRACT (YEAR FROM started_at) AS year,
  FORMAT_TIMESTAMP('%B', started_at) AS month_name,
  EXTRACT (MONTH FROM started_at) AS month_number,
  FORMAT_TIMESTAMP('%A', started_at) AS started_day_name,
  EXTRACT (DAYOFWEEK FROM started_at) AS started_day_of_week,
  FORMAT_TIMESTAMP('%A', ended_at) AS ended_day_name,
  EXTRACT (DAYOFWEEK FROM ended_at) AS ended_day_of_week,
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,
  member_casual,
  start_lat,
  start_lng,
  end_lat,
  end_lng
FROM 
  `capstone-projects-434509.Case_Study_Cyclistic.cleaned_tripdata_combined`
)




