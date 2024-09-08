#Check if columns is consistent across all tables
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
