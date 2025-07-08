USE `Parks_and_Recreation`;
-- JOINS
SELECT * FROM employee_demographics;

SELECT * FROM employee_salary;

SELECT * FROM employee_demographics dem
INNER JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name,age,gender,occupation,salary
FROM employee_demographics dem
INNER JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name,age,gender,occupation,salary
FROM employee_demographics dem
LEFT JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name,age,gender,occupation,salary
FROM employee_demographics dem
RIGHT JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id AS emp_santa,
dem.first_name AS first_name_santa,
dem.last_name as last_name_santa,
sal.first_name as emp_first_name,
sal.last_name as emp_Last_name
FROM employee_salary dem
INNER JOIN employee_salary sal
ON dem.employee_id + 1 = sal.employee_id;


SELECT dem.employee_id,dem.first_name,dem.last_name,age,gender,occupation,salary,
department_name
FROM employee_demographics dem
INNER JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd ON 
sal.dept_id = pd.department_id;


SELECT dem.employee_id,dem.first_name,dem.last_name,age,gender,occupation,salary,
department_name
FROM employee_demographics dem
INNER JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
LEFT JOIN parks_departments pd ON 
sal.dept_id = pd.department_id;

-- UNIONS

SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old Lady' as Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man'
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Highly Paid Employee'
FROM employee_salary
WHERE salary >= 70000
ORDER BY first_name;

-- STRING FUNCTION

SELECT LENGTH('sky');

SELECT first_name, LENGTH(first_name) 
FROM employee_demographics;

SELECT UPPER('sky');

SELECT first_name, UPPER(first_name) 
FROM employee_demographics;

SELECT LOWER('sky');

SELECT first_name, LOWER(first_name) 
FROM employee_demographics;

SELECT TRIM('sky'   );

SELECT LTRIM('     I           love          SQL');

SELECT LTRIM('     I love SQL');

SELECT RTRIM('I love SQL    ');

SELECT LEFT('Alexander', 4);

SELECT first_name, LEFT(first_name,4) 
FROM employee_demographics;

SELECT RIGHT('Alexander', 6);

SELECT first_name, RIGHT(first_name,4) 
FROM employee_demographics;
 
SELECT SUBSTRING('Alexander', 2, 3);

SELECT birth_date, SUBSTRING(birth_date,1,4) as birth_year
FROM employee_demographics;

SELECT REPLACE(first_name,'a','z')
FROM employee_demographics;

SELECT LOCATE('x', 'Alexander');

SELECT first_name, LOCATE('a',first_name) 
FROM employee_demographics;

SELECT first_name, LOCATE('Mic',first_name) 
FROM employee_demographics;

SELECT CONCAT('Alex', 'Freberg');

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

-- CASE 

SELECT first_name,last_name,age,
CASE
	WHEN age <30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN 'Unfit'
END AS work_category
 FROM employee_demographics;
 
 SELECT first_name,last_name,salary,
 CASE
	WHEN salary > 45000 THEN  salary + (salary * 0.05)
    	WHEN salary <= 45000 THEN  salary + (salary * 0.07)
 END AS new_salary,
 CASE
	WHEN dept_id = 6 THEN salary + (salary *0.1)
    ELSE 'No Bonus'
 END AS bonus
 FROM employee_salary;
 
 -- SUBQUERIES
 
 SELECT * FROM employee_demographics;
 
 SELECT * FROM employee_salary WHERE dept_id = 1;
 
 SELECT * FROM employee_demographics
 WHERE employee_id IN (
 SELECT employee_id FROM employee_salary WHERE dept_id = 1
 );
 
 SELECT first_name,salary,(
 SELECT AVG(salary) FROM employee_salary) AS avg_salary
 FROM employee_salary;
 
 SELECT * FROM (
 SELECT gender, AVG(age),MAX(age),MIN(age),COUNT(age)
 FROM employee_demographics GROUP BY gender) AS agg_table;
 
  SELECT AVG(max_age) FROM (
 SELECT gender, AVG(age),
 MAX(age) as max_age,
 MIN(age),COUNT(age)
 FROM employee_demographics GROUP BY gender) AS agg_table;
 
 -- WINDOW FUNCTIONS
 
 SELECT gender,AVG(salary)
 FROM employee_demographics dem
 JOIN employee_salary sal ON 
 dem.employee_id = sal.employee_id
 GROUP BY gender;
 
 SELECT gender, AVG(salary) OVER()
  FROM employee_demographics dem
 JOIN employee_salary sal ON 
 dem.employee_id = sal.employee_id;

SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;

SELECT dem.first_name,dem.last_name,salary,gender, AVG(salary) OVER(PARTITION BY gender) as avg_sal
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;

SELECT dem.first_name,dem.last_name,salary,gender, SUM(salary) OVER(PARTITION BY gender) as sum_sal
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;

SELECT dem.first_name,dem.last_name,salary,gender, SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) as sum_sal
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name,salary,gender,
 SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) as sum_sal,
ROW_NUMBER() OVER(PARTITION BY gender) row_num
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;

SELECT dem.employee_id,dem.first_name,dem.last_name,salary,gender,
 SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) as sum_sal,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_sal,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal ON 
dem.employee_id = sal.employee_id;
