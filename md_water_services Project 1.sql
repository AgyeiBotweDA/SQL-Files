-- 1. Getting to know the data --
USE md_water_services;

##Looking at what each Table represent --
SHOW tables;

-- Looking at location Table 
SELECT *
FROM location
LIMIT 8;

SELECT *
FROM visits
LIMIT 8;

SELECT *
FROM water_source
LIMIT 8;

-- Looking at the various type of water sources
SELECT DISTINCT 
type_of_water_source
FROM water_source;

-- Retrieving all records where time_in_queue > 500 --
SELECT *
FROM visits
Where time_in_queue > 500;

-- Checking the type_of_water-sources to queue --
SELECT *
FROM water_source
WHERE source_id IN ("AkKi00881224", "SoRu37635224", "SoRu36096224", "AkRu05234224",
"HaZa21742224");

##Finding the water quality table --
SELECT *
FROM water_quality;

-- Find records where subject_quality_score is 10 and visit_count 2 
SELECT *
FROM water_quality
WHERE subjective_quality_score = 10 AND visit_count =2;

-- Count records where subject_quality_score is 10 and visit-count 2
SELECT COUNT(*)
FROM water_quality
WHERE subjective_quality_score = 10 AND visit_count = 2;

-- Finding first few rows from Well_Population Table
SELECT *
FROM well_pollution
LIMIT 10;

-- Check if the results is Clean but the biological column is > 0.01
SELECT *
FROM well_pollution
WHERE results = "Clean" AND biological > 0.01;

-- Searching for the word Clean with additional characters after it
SELECT*
FROM well_pollution
WHERE description LIKE "Clean %";

-- Setting to safe before updates
SET SQL_SAFE_UPDATES = 0;

-- Updating results in Description from Clean Bacteria: E. coli to Bacteria: E. coli
UPDATE well_pollution
SET description = "Bacteria: E. coli"
WHERE description = "Clean Bacteria: E. coli";

-- Updating results in description from Clean Bacteria: Giardia Lamblia to Bacteria: Giardia Lamblia
UPDATE well_pollution
SET description = "Bacteria: Giardia Lamblia"
WHERE description = "Clean Bacteria: Giardia Lamblia";

-- Updating result to Contaminated: Biological where biological is > 0.01 and current results is Clean
UPDATE well_pollution
SET results = "Contaminated: Biological"
WHERE biological > 0.01 AND results = "Clean";

-- Testing to see if errors have been fixed or corrected.
SELECT *
FROM well_pollution
WHERE description LIKE "Clean_%"
     OR (results = "Clean" AND biological > 0.01);
     