SELECT *
FROM layoffs_raw;
 To clean the data, the following will be done
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

--- Create a copy of the raw data

CREATE TABLE layoffs_raw_staging
LIKE layoffs_raw;

INSERT INTO layoffs_raw_staging
SELECT *
FROM layoffs_raw;

SELECT *
FROM layoffs_raw_staging;

--- 1. Remove Duplicates with CTE and Window function row_num()

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, percentage_laid_off, date,stage,country,funds_raised_millions) AS row_num
FROM layoffs_raw_staging;

WITH Duplicate_CTE AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, date,percentage_laid_off,stage,country,funds_raised_millions) AS row_num
FROM layoffs_raw_staging
)
SELECT *
FROM Duplicate_CTE
WHERE row_num > 1;

----
--- Confirming the Duplicates
SELECT *
FROM layoffs_raw_staging
WHERE company = 'Cazoo'

SELECT *
FROM layoffs_raw_staging
WHERE company = 'Casper'

SELECT *
FROM layoffs_raw_staging
WHERE company = 'Hibob'

SELECT *
FROM layoffs_raw_staging
WHERE company = 'Wildlife Studios'

---Deleting the columns

CREATE TABLE `laysoffs_raw_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
   `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM laysoffs_raw_staging2;



INSERT INTO laysoffs_raw_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,total_laid_off, percentage_laid_off,date,stage,country,funds_raised_millions) AS row_num
FROM layoffs_raw_staging;

SELECT *
FROM laysoffs_raw_staging2
WHERE row_num >1;

DELETE
FROM laysoffs_staging2
WHERE row_num >1;

--- Standardizing Data
 1.) company
 2.) Industry

SELECT *
FROM laysoffs_raw_staging2;

SELECT company, TRIM(company)
FROM laysoffs_raw_staging2;

UPDATE laysoffs_raw_staging2
SET company = trim(company);

SELECT distinct(industry)
FROM laysoffs_raw_staging2
ORDER BY industry;

UPDATE laysoffs_raw_staging2
SET industry = 'Crypto Currency'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT (location)
FROM laysoffs_raw_staging2
ORDER BY location;

SELECT DISTINCT (country)
FROM laysoffs_raw_staging2
ORDER BY country;

SELECT DISTINCT (country),trim(trailing "." FROM country)
FROM laysoffs_raw_staging2
ORDER BY country;

UPDATE laysoffs_raw_staging2
SET country = trim(trailing "." FROM country);

SELECT DISTINCT (stage)
FROM laysoffs_staging2;

SELECT DISTINCT (date)
FROM laysoffs_raw_staging2;

---FORMAT the date column to date format( currently represented as text data)

SELECT date,
STR_TO_DATE (date, '%m/%d/%Y')
FROM laysoffs_raw_staging2;

UPDATE laysoffs_raw_staging2
SET date = STR_TO_DATE (date, '%m/%d/%Y');

--- MODIFY the date column to a date datatype
ALTER TABLE laysoffs_raw_staging2
MODIFY COLUMN date DATE;

----  working on NULLS

SELECT *
FROM laysoffs_raw_staging2
WHERE industry = ''
OR industry is NULL;

SELECT *
FROM laysoffs_raw_staging2
WHERE company = 'Airbnb';

--- To fill in some blank values in industry column, we do a self join to populate it from rows with the same compay name 
 
SELECT t1.industry,t2.industry
FROM laysoffs_raw_staging2 as t1
JOIN laysoffs_raw_staging2 as t2
    ON t1.company = t2.company
    AND t1.location =t2.location
WHERE (t1.industry is NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE laysoffs_raw_staging2
SET industry = null
WHERE industry = '';

UPDATE laysoffs_raw_staging2 as t1
JOIN  laysoffs_raw_staging2 as t2
    ON t1.company =t2.company
SET t1.industry =t2.industry
WHERE t1.industry is NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM laysoffs_raw_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

 ----Since the emphasis of this data is on total laid off and percentage laid off, we are better off deleting these rows
DELETE
FROM laysoffs_raw_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

---DROP off redundant columns

ALTER TABLE laysoffs_raw_staging2
DROP COLUMN row_num;

SELECT *
FROM laysoffs_raw_staging2

 

