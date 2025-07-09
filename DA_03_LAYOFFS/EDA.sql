-- EXPLORATORY DATA ANALYSIS

USE layoffs;

SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off),
MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT MAX(total_laid_off),
MIN(total_laid_off)
FROM layoffs_staging2;

SELECT MAX(percentage_laid_off),
MIN(percentage_laid_off)
FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off;

SELECT funds_raised_millions, company,
percentage_laid_off FROM layoffs_staging2
ORDER BY funds_raised_millions DESC;

SELECT company,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY company
ORDER BY tot_lay DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY industry
ORDER BY tot_lay DESC;

SELECT country,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY country
ORDER BY tot_lay DESC;

SELECT `date`,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY `date`
ORDER BY `date` DESC;

SELECT YEAR(`date`) as yr,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY yr
ORDER BY tot_lay DESC;

SELECT stage,SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY stage
ORDER BY tot_lay DESC;

SELECT SUBSTRING(`date`,6,2) as MON,
SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY MON;

SELECT SUBSTRING(`date`,1,7) AS yr,
SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY yr
ORDER BY yr;

WITH roll_tot AS (
SELECT SUBSTRING(`date`,1,7) AS yr,
SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY yr
ORDER BY yr
)
SELECT yr, tot_lay,SUM(tot_lay) OVER(ORDER BY yr) AS rt
FROM roll_tot;

SELECT company , YEAR(`date`), 
SUM(total_laid_off) as tot_lay
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH company_yr (comp,yrs,tot_lay) AS (
SELECT company , YEAR(`date`), 
SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Comp_yr_rank AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY yrs ORDER BY
tot_lay DESC) AS ranking FROM company_yr
WHERE yrs IS NOT NULL
)
SELECT * FROM Comp_yr_rank
WHERE ranking <= 5;


