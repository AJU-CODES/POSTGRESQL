use layoffs;

select * from layoffs;

-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL AND BLANK VALUES
-- 4. REMOVE UNNECESSARY COLUMNS


-- LETS MAKE A COPY OF layoffs TABLE 
CREATE TABLE layoffs_staging 
LIKE layoffs;
-- WE CREATE A TABLE NAMED layoffs_staging
SELECT * FROM layoffs_staging;
-- THE TABLE WAS CREATED BUT IT HAVE NO RECORDS
INSERT layoffs_staging
SELECT * FROM layoffs;
-- LETS INSERT THE RECORDS INTO OUR NEW TABLE
SELECT * FROM layoffs_staging;
-- layoffs_staging IS READY TO EXPLORE

-- 1. IDENTIFYING DUPLICATES USING ROW_NUMBER()
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,
total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
FROM layoffs_staging;
-- WE PARTITIONED ROW BY ALL THE FEATURE COLUMNS SO IF THERE IS ANY DUPLICATE IT WILL HAVE ROW NUMBER > 1
-- LETS CREATE A CTE AND FILTER THEM

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,
total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte 
WHERE row_num > 1;
-- THIS WILL SHOW THE DUPLICATE RECORDS PRESENT IN THEM

SELECT * FROM layoffs_staging
WHERE company = 'Casper';
-- WE NEED TO REMOVE ONE OF THE DUPLICATES

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,
total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE FROM duplicate_cte 
WHERE row_num > 1;
-- THE ABOVE QUERY MAKES ERROR SO WE MAKE A NEW TABLE AND PERFORM CLEANING

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- COPY FROM CLIPBOARD 
SELECT * FROM layoffs_staging2;
-- IT CONTAINS NO VALUES LETS INSERT THEM
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,
total_laid_off,percentage_laid_off,`date`,stage,country,
funds_raised_millions) AS row_num
FROM layoffs_staging;
-- VALUES GOT INSERTED
SELECT * FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE row_num >1;
-- LETS DELETE THE DUPLICATES

DELETE FROM layoffs_staging2
WHERE row_num >1;
SELECT * FROM layoffs_staging2
WHERE row_num >1;
-- NO DUPLICATES PRESENT

-- 2. STANDARDIZE DATA

SELECT DISTINCT(TRIM(company))
FROM layoffs_staging2;
SELECT company,TRIM(company)
FROM layoffs_staging2;
-- LETS UPDATE THE TRIMMED 
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;
-- WE CAN SEE Crypto, CryptoCurrency, Crypto Currency
-- ALL THE VALUES ABOVE CRYPTO MENTION THE SAME
-- LETS STANDARDIZE THEM
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- UPDATED
SELECT * FROM 
layoffs_staging2
WHERE industry LIKE 'Crypto%';
-- LETS CHECK FOR OTHER COLUMNS
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- UPDATED

-- LETS STANDARDIZE THE DATE
SELECT `date`, STR_TO_DATE(
`date`,'%m/%d/%Y')
FROM layoffs_staging2;
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(
`date`,'%m/%d/%Y');
-- LETS MODIFY THE DATATYPE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_staging2;

-- HANDLING NULL VALUESS

SELECT COUNT(*) FROM layoffs_staging2
WHERE total_laid_off IS NULL; -- 739

SELECT COUNT(*) FROM layoffs_staging2
WHERE percentage_laid_off IS NULL; -- 784

SELECT COUNT(*) FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL; -- 361

SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR
industry = '';

SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb';
-- FROM THIS WE CAME TO KNOW THE INDUSTRY OF Airbnb COMPANY
-- LETS UPDATE THEM

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';
SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.company,t1.industry,t2.industry
FROM layoffs_staging2 t1 JOIN
layoffs_staging2 t2 ON
t1.company = t2.company
WHERE t1.industry IS NULL AND
t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1 JOIN
layoffs_staging2 t2 ON
t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND
t2.industry IS NOT NULL;
SELECT t1.company,t1.industry,t2.industry
FROM layoffs_staging2 t1 JOIN
layoffs_staging2 t2 ON
t1.company = t2.company
WHERE t1.industry IS NULL AND
t2.industry IS NOT NULL;
SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT * FROM layoffs_staging2
WHERE industry IS NULL;
-- THIS Bally's Interactive IS THE ONLY COMPANY

-- LETS DELETE THE RECORDS WHERE BOTH total and percentage laid off WHERE EMPTY
-- BECAUSE THE CAUSE NO SENSE

DELETE FROM  layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;
SELECT * FROM  layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;
-- UPDATED

SELECT * FROM layoffs_staging2;
-- LETS DROP row_num

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;







