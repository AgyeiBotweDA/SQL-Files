

-- Getting familiar with the Tables
SELECT*
FROM data_dictionary
LIMIT 5;

SELECT*
FROM employee;
    
-- Remove the space between the first and last names and replacing with full stop
SELECT REPLACE(employee_name, ' ','.')  
FROM employee;

-- Make first and last names lowercase
SELECT LOWER(REPLACE(employee_name, ' ','.')) 
FROM employee;
    
-- Creating an email address for each employee
SELECT
   CONCAT(
   LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') AS new_email 
FROM employee;
  
-- Setting to Safe before Update
SET SQL_SAFE_UPDATES = 0;
  
-- UPDATE the email column with the email addresses in the EMPLOYEE table
UPDATE employee
SET email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov');

-- Verify if it worked    
SELECT *
FROM employee
LIMIT 8;

-- Fixing errors in phone_number column by first checking the length
SELECT LENGTH(phone_number)
FROM employee;
  
-- Update the phone_number column by removing trailing spaces
UPDATE employee
SET phone_number = RTRIM("phone_number");

-- Use the employee table to count how many of our employees live in each town
SELECT DISTINCT town_name,
     COUNT(employee_name) AS number_of_employees
FROM employee
GROUP BY town_name;
     
-- Find the top 3 field surveyors to with the highest visits to congratulate
SELECT assigned_employee_id,
     COUNT(visit_count) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY assigned_employee_id
LIMIT 3;

-- Finding the employee info of these three top surveyors
SELECT employee_name, phone_number, email, assigned_employee_id
FROM employee
WHERE assigned_employee_id = 0 OR 1 OR 2
LIMIT 3;

-- Querying the Location table
SELECT *
FROM location;
   
-- Counting the number of records per town
SELECT town_name,
  COUNT(town_name) AS records_per_town
FROM location 
GROUP BY town_name
ORDER BY records_per_town DESC;

-- Counting the records by province 
SELECT province_name,
  COUNT(province_name) AS records_per_province
FROM location 
GROUP BY province_name
ORDER BY records_per_province DESC;

-- Showing count for both province and town
SELECT town_name,  province_name,
  COUNT(town_name) AS records_per_town
FROM location 
GROUP BY town_name, province_name
ORDER BY  COUNT(province_name) DESC;

-- Showing count for location type
SELECT location_type,
  COUNT(location_type) AS name_sources
FROM location 
GROUP BY location_type
ORDER BY name_sources;

-- Determining which percentage of water sources are in rural communities
SELECT 23740 / (15910 + 23740) * 100;

-- Determining which percentage of water sources are in urban communities 
SELECT 15910 / (15910 + 23740) * 100;

-- Dive in the water_sources table
SELECT *
FROM water_source;
   
-- Total number of People surveyed
SELECT
     SUM(number_of_people_served) AS total_number_of_people_surveyed
FROM water_source;
     
-- Number of taps, wells, and rivers available
SELECT  type_of_water_source,
    COUNT(type_of_water_source) AS number_of_sources
FROM water_source
GROUP BY type_of_water_source
ORDER BY number_of_sources DESC;

-- Number of people that share particular type of water source on average
SELECT type_of_water_source,
    AVG(number_of_people_served) AS average_people
FROM  water_source
GROUP BY type_of_water_source
ORDER BY average_people DESC;

-- Number of people getting water from each type of water source
SELECT type_of_water_source,
     SUM(number_of_people_served) AS total_people
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people DESC;
     
-- Use percentage to properly understand the total number of people that share each type of water
SELECT type_of_water_source,
       SUM(number_of_people_served) AS total_people,
       ROUND((SUM(number_of_people_served) / 
       (SELECT SUM(number_of_people_served) 
       FROM water_source)) * 100, 0) AS percentage
FROM  water_source
GROUP BY  type_of_water_source
ORDER BY total_people DESC,
         percentage DESC;

-- Using the Rank() to rank the total number of people served by each water source
SELECT type_of_water_source,
     SUM(number_of_people_served) AS total_people,
     RANK() OVER (ORDER BY SUM(number_of_people_served) DESC)
     AS ranking
FROM water_source
GROUP BY type_of_water_source
ORDER BY ranking;     

-- Analyze queues 
SELECT *
FROM visits;

-- survey duration
SELECT
	MIN(time_of_record),
    MAX(time_of_record),
    DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS survey_duration
FROM
	visits;

-- average queue in time
SELECT
ROUND(AVG(NULLIF(time_in_queue,0)), 0)
FROM md_water_services.visits;

-- average queue time on different days
SELECT
   DAYNAME(time_of_record) AS day_of_week,
   ROUND(AVG(NULLIF(time_in_queue,0)), 0) AS average_queue_time
FROM md_water_services.visits
GROUP BY day_of_week
ORDER BY average_queue_time DESC;

-- time during the day people collect water 
SELECT 
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(NULLIF(time_in_queue,0)), 0) AS average_queue_time
FROM visits
GROUP BY hour_of_day
ORDER BY average_queue_time DESC;

SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Sunday,
-- Monday
	ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Monday,
-- Tuesday
ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Tuesday,
-- Wednesday
ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Wednesday,
-- Thursday
ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Thursday,
-- Friday
ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Friday,
-- Saturday
ROUND(AVG(
		CASE
			WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
			ELSE NULL
		END
		),0) AS Saturday
FROM visits
WHERE time_in_queue != 0 
GROUP BY hour_of_day
ORDER BY hour_of_day;
