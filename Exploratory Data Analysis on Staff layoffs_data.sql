--Explore the clean layoffs_data and find trends or patterns or anything interesting like outliers

SELECT *
FROM laysoffs_raw_staging2;

--- exploring the extent of laying off with the total_laid_off and percentage_laid_off columns

SELECT MAX(total_laid_off)
FROM laysoffs_raw_staging2;

SELECT MAX(percentage_laid_off), MIN(percentage_laid_off)
FROM laysoffs_raw_staging2;

SELECT *
FROM laysoffs_raw_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM laysoffs_raw_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
-- Companies with the biggest single Layoff

SELECT *
FROM laysoffs_raw_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;

SELECT company, total_laid_off
FROM laysoffs_raw_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

SELECT company,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date)
FROM laysoffs_raw_staging2;

-- Lay_offs by industry
SELECT industry,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Lay_offs by location
SELECT country,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY country
ORDER BY 2 DESC;


---by date
SELECT date,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY date
ORDER BY 2 DESC;

--- by year
SELECT YEAR (date),SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY YEAR (date)
ORDER BY 2 DESC;

--- by the company STAGE
SELECT stage ,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY stage
ORDER BY 2 DESC;

---percentage laid_off
SELECT company,SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY company
ORDER BY 2 DESC;

--- exploring layoff by time

SELECT SUBSTRING(date,1,7) AS 'TIME',SUM(total_laid_off)
FROM laysoffs_raw_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY SUBSTRING(date,1,7)
ORDER BY 1 ASC;
----- Ranking based on year and total laid off
WITH ROLLING_TOTAL AS 
(SELECT SUBSTRING(date,1,7) AS timeseries ,SUM(total_laid_off) AS total_laid
FROM laysoffs_raw_staging2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY timeseries
ORDER BY 1 ASC
)
SELECT timeseries, total_laid, SUM(total_laid) OVER(ORDER BY timeseries) AS rolling_total
FROM ROLLING_TOTAL;

SELECT company,YEAR (date),SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY company,YEAR(date)
ORDER BY 3 DESC;

WITH Company_Years (Company, Years, Total_laid_off) AS 
(SELECT company,YEAR (date),SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY company,YEAR(date)
), COMPANY_YEAR_RANK AS 
(SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Ranking
FROM Company_Years
WHERE Years IS NOT NULL
)
SELECT *
FROM COMPANY_YEAR_RANK 
WHERE Ranking <=5;

---Ranking by Industry

WITH Industry_by_Years (Industry, Years, Total_laid_off) AS 
(SELECT industry,YEAR (date),SUM(total_laid_off)
FROM laysoffs_raw_staging2
GROUP BY industry,YEAR(date)
), INDUSTRY_YEAR_RANK AS 
(SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Total_laid_off DESC) AS Ranking
FROM Industry_by_Years
WHERE Years IS NOT NULL
)
SELECT *
FROM INDUSTRY_YEAR_RANK 
WHERE Ranking <=5;

