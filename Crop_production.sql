USE PROJECTS;
CREATE TABLE CROP_PRODUCTION(
State_Name varchar(50),
District_Name varchar(50),
Crop_Year year,
Season varchar(20),
Crop varchar(50),
Area int,
Production int 
);
SELECT * FROM CROP_PRODUCTION;
SHOW VARIABLES LIKE "secure_file_priv";

-- Loading the data 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crop Production data.csv'
INTO TABLE CROP_PRODUCTION
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 

-- Checking for the 'NULL' values
SELECT *
FROM crop_production
WHERE State_Name IS NULL AND
District_Name IS NULL AND
Crop_Year IS NULL AND
Season IS NULL AND
Crop IS NULL AND
Area IS NULL AND
Production;

-- Total No. of rows
SELECT COUNT(*) AS row_count FROM crop_production;

-- Top 5 Crop Years by Total Production
SELECT crop_year, SUM(production) AS total_production
FROM crop_production
GROUP BY crop_year
ORDER BY total_production DESC
LIMIT 5;

-- Seasonal Production Trends
SELECT
	CONCAT(crop_year,'-', season) AS Year_Seasons, SUM(Production) AS total_production
FROM crop_production
GROUP BY Crop_year, season
ORDER BY Crop_year, season;

-- Most Cultivated Crop, Which crop has the highest total area cultivated?
SELECT crop , SUM(area) AS Total_cultivated_area
FROM crop_production 
GROUP BY crop
ORDER BY Total_cultivated_area DESC LIMIT 1;

-- District with Highest Production: Which district has the highest production overall, and which crop and crop year contributed to it?
SELECT cp.district_name, cp.crop, cp.crop_year, cp.production
FROM crop_production cp
JOIN (
    SELECT district_name, MAX(production) AS Max_production
    FROM crop_production
    GROUP BY district_name
) max_prod ON cp.district_name = max_prod.district_name AND cp.production = max_prod.Max_production;

-- Crop Yield Analysis: Calculate the yield (production per unit area) for each crop and identify the top 5 crops with the highest yield.
SELECT Crop, SUM(Production) / SUM(Area) AS Yield
FROM crop_production
GROUP BY Crop
ORDER BY Yield DESC
LIMIT 5;

-- Yearly Production Variation: How does production vary from year to year? Identify the years with the highest and lowest production.
SELECT Crop_Year, SUM(Production) AS Total_Production
FROM crop_production
GROUP BY Crop_Year
ORDER BY Total_Production DESC
LIMIT 1;

-- Crop Area Distribution: Determine the distribution of crop area across different crops.
SELECT Crop, SUM(Area) AS Total_Area
FROM crop_production
GROUP BY Crop
ORDER BY Total_Area DESC;


-- Seasonal Production Growth: Calculate the production growth rate between consecutive years for each season.
SELECT curr.Crop_Year AS Year, curr.Season, (curr.Total_Production - prev.Total_Production) / prev.Total_Production * 100 AS Growth_Rate
FROM
    (SELECT Crop_Year, Season, SUM(Production) AS Total_Production
    FROM crop_production
    GROUP BY Crop_Year, Season
    ) curr
JOIN
    (SELECT Crop_Year, Season, SUM(Production) AS Total_Production
    FROM crop_production
    GROUP BY Crop_Year, Season
    ) prev ON curr.Season = prev.Season AND curr.Crop_Year = prev.Crop_Year + 1
ORDER BY curr.Crop_Year, curr.Season;

-- Comparative Analysis: Compare production trends between different states or districts.
SELECT State_Name, SUM(Production) AS Total_Production
FROM crop_production
GROUP BY State_Name
ORDER BY Total_Production DESC;

-- Crop Area vs. Production
SELECT Crop, SUM(Area) AS Total_Area, SUM(Production) AS Total_Production
FROM crop_production
GROUP BY Crop;


