-- @label total_rows
SELECT COUNT(*) AS total_rows
FROM videogames
LIMIT 100
;

CREATE TABLE videogames_clean AS -- Create a new table to store the cleaned data
SELECT *
FROM videogames;

-- @label clean_data
SELECT *
FROM videogames_clean
LIMIT 100
;

-- @label detect_nulls
SELECT
  COUNT(*) AS total_rows,
  COUNT(Name) AS names_not_null, -- No nulls here
  COUNT(Platform) AS platform_not_null, -- No nulls here
  COUNT(Genre) AS genre_not_null, -- No nulls here
  COUNT(Publisher) AS publisher_not_null, -- No nulls here
  COUNT(Critic_Score) AS critic_score_not_null, -- There are some nulls here
  COUNT(Critic_Count) AS critic_count_not_null, -- Same nulls as critic_score
  COUNT(User_Score) AS user_score_not_null, -- Some nulls here as well  
  COUNT(User_Count) AS user_count_not_null, -- Some nulls, not the same as user_score
  COUNT(Year_of_Release) AS year_not_null, -- No nulls here
  COUNT(Global_Sales) AS sales_not_null, -- No nulls here
  COUNT(Developer) AS developer_not_null, -- Some nulls here
  COUNT(Rating) AS rating_not_null -- Nulls in this column as well
FROM videogames_clean
-- The columns with nulls are Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer and Rating.

--"total_rows","names_not_null","platform_not_null","genre_not_null","publisher_not_null","critic_score_not_null","critic_count_not_null","user_score_not_null","user_count_not_null","year_not_null","sales_not_null","developer_not_null","rating_not_null"
--16712,16712,16712,16712,16712,8136,8136,7589,7589,16443,16712,10094,9948

;

SELECT *
FROM videogames_clean
WHERE Critic_Score IS NULL
LIMIT 100 -- Typically, rows with NULL values in Critic_Score also have NULL values in Critic_Count, User_Score, User_Count, Developer and Rating, but not always.
;

-- @label detect_tbd
SELECT DISTINCT User_Score
FROM videogames_clean
ORDER BY User_Score -- The User_Score column contains the value 'tbd' which stands for 'to be determined', and it is not a valid score. We will need to handle this value as well.
;

-- @label convert_tbd
UPDATE videogames_clean
SET User_Score = NULL
WHERE User_Score = 'tbd' -- We will convert the 'tbd' values to NULL so that we can handle them as missing values.
;

-- @label check_data
SELECT DISTINCT User_Score
FROM videogames_clean
ORDER BY User_Score -- After the update, there should be no 'tbd' values in the User_Score column.
-- It works.
;

-- @label clean_nulls
-- Delete rows with null values in critical columns (Name, Genre, Publisher) since they are essential for analysis and cannot be imputed reliably.
DELETE FROM videogames_clean
WHERE Name IS NULL OR Genre IS NULL OR Publisher IS NULL
-- Not all rows with null values in some column are deleted, only those with null values in critical columns.
;

-- @label check_number_of_rows
SELECT COUNT(*) AS total_rows_after_cleaning
FROM videogames_clean -- 2 rows were deleted because they had null values in critical columns (Name, Genre, Publisher). Result: 16717 rows.
;


-- @label detect_tbd
SELECT DISTINCT Critic_Score
FROM videogames_clean
ORDER BY Critic_Score -- There are no 'tbd' values in the Critic_Score column.
;

-- @label clean_data
SELECT *
FROM videogames_clean
LIMIT 100
;

-- @label detect_type_of_columns
PRAGMA table_info(videogames_clean)
-- Note: Year_of_Release is stored as an integer. NA_Sales and Other_Sales are stored as integers, but EU_Sales, JP_Sales and Global_Sales are stored as real numbers. Finally, Critic_Score, User_Score, Critic_Count and User_Count are stored as text.
;

-- @label detect_duplicates
SELECT Name, Platform, Year_of_Release, COUNT(*) AS duplicates
FROM videogames_clean
GROUP BY Name, Platform, Year_of_Release
HAVING COUNT(*) > 1
ORDER BY duplicates DESC;

SELECT *
FROM videogames_clean
WHERE Name = 'Madden NFL 13' AND Platform = 'PS3'
-- There are two rows with Name 'Madden NFL 13' and Platform 'PS3', but one row has 2.56 in Global_Sales and the other row has 0.01 in Global_Sales. This second row is likely a duplicate with incorrect sales data, so we will delete it. The first row has correct sales data and will be kept.
;

-- @label delete_duplicates
DELETE FROM videogames_clean
WHERE Name = 'Madden NFL 13' 
AND Platform = 'PS3' 
AND Global_Sales = 0.01;

-- @label verify_deletion
-- Verify that the duplicate has been deleted
SELECT * FROM videogames_clean
WHERE Name = 'Madden NFL 13' AND Platform = 'PS3';

SELECT *
FROM videogames_clean
LIMIT 100;

-- @label check_platforms
SELECT DISTINCT Platform distinct_platforms
FROM videogames_clean
ORDER BY Platform -- all good here
;


-- @label check_genres
SELECT DISTINCT Genre distinct_genres
FROM videogames_clean
ORDER BY Genre -- all good here
;

-- @label check_ratings
SELECT DISTINCT Rating distinct_ratings
FROM videogames_clean
ORDER BY Rating -- Here we have the K-A and EC rating, which are not currently used in our analysis, so we will convert them to 'E' (Everyone) since they are the closest ratings to K-A and EC and it will allow us to include those games in our analysis without losing too much information. 
;

-- @label check k-a and ec
SELECT *
FROM videogames_clean
WHERE Rating = 'K-A'
OR Rating = 'EC'
;

UPDATE videogames_clean
SET Rating = 'E'
WHERE Rating = 'K-A'
OR Rating = 'EC';

-- @label verify_ratings
SELECT DISTINCT Rating FROM videogames_clean ORDER BY Rating;

SELECT *
FROM videogames_clean
LIMIT 100;

SELECT DISTINCT Year_of_Release
FROM videogames_clean
ORDER BY Year_of_Release DESC -- N/A values should be converted to NULL. Also, there are some games with Year_of_Release equal to 2017 or 2020, which are incorrect since the dataset was released in 2016.
;

SELECT *
FROM videogames_clean
WHERE Year_of_Release = 2017
OR Year_of_Release = 2020
-- Only 4 rows, we don't lose much information if we delete them.
;

DELETE FROM videogames_clean
WHERE CAST(Year_of_Release AS INTEGER) > 2016;

UPDATE videogames_clean
SET Year_of_Release = NULL
WHERE Year_of_Release = 'N/A';

-- @label verify_years
SELECT DISTINCT Year_of_Release
FROM videogames_clean
ORDER BY Year_of_Release DESC
;

CREATE TABLE videogames_final AS
SELECT
    Name,
    Platform,
    
    -- Año como entero
    CAST(Year_of_Release AS INTEGER) AS Year_of_Release,
    
    Genre,
    Publisher,
    
    -- Ventas como REAL
    CAST(NA_Sales AS REAL) AS NA_Sales,
    CAST(EU_Sales AS REAL) AS EU_Sales,
    CAST(JP_Sales AS REAL) AS JP_Sales,
    CAST(Other_Sales AS REAL) AS Other_Sales,
    CAST(Global_Sales AS REAL) AS Global_Sales,
    

    CAST(Critic_Score AS REAL) AS Critic_Score,
    CAST(Critic_Count AS INTEGER) AS Critic_Count,
    CAST(User_Score AS REAL) AS User_Score,
    CAST(User_Count AS INTEGER) AS User_Count,
    
    Developer,
    Rating

FROM videogames_clean;

SELECT *
FROM videogames_final
LIMIT 100
;

PRAGMA table_info(videogames_final);

-- @label detect_nulls
SELECT
  COUNT(*) AS total_rows,
  COUNT(Name) AS names_not_null, -- No nulls here
  COUNT(Platform) AS platform_not_null, -- No nulls here
  COUNT(Genre) AS genre_not_null, -- No nulls here
  COUNT(Publisher) AS publisher_not_null, -- No nulls here
  COUNT(Critic_Score) AS critic_score_not_null, -- There are some nulls here
  COUNT(Critic_Count) AS critic_count_not_null, -- Same nulls as critic_score
  COUNT(User_Score) AS user_score_not_null, -- Some nulls here as well  
  COUNT(User_Count) AS user_count_not_null, -- Some nulls, not the same as user_score
  COUNT(Year_of_Release) AS year_not_null, -- No nulls here
  COUNT(Global_Sales) AS sales_not_null, -- No nulls here
  COUNT(Developer) AS developer_not_null, -- Some nulls here
  COUNT(Rating) AS rating_not_null -- Nulls in this column as well
FROM videogames_final
-- The columns with nulls are Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer and Rating.
;

SELECT COUNT(*)
FROM videogames_final
WHERE Year_of_Release IS NULL
;

SELECT 
    COUNT(*) AS total,
    COUNT(Developer) AS with_developer,
    COUNT(*) - COUNT(Developer) AS without_developer
    -- There are 6618 rows with null values in the Developer column, around 40% of the total rows. We will not delete the column, but it will have a rather secondary role in our analysis.
FROM videogames_final;