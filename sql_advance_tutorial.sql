USE `Parks_and_Recreation`;

-- COMMON TABLE EXPRESSION
with cte_example as (
select gender,avg(age),min(age),max(age),count(age)
from employee_demographics dem join
employee_salary sal on dem.employee_id = sal.employee_id
group by gender
)
select * from cte_example;

with cte_example as (
select gender,avg(salary) avg_sal,min(salary) min_sal,max(salary) max_sal,count(salary) count_sal
from employee_demographics dem join
employee_salary sal on dem.employee_id = sal.employee_id
group by gender
)
select avg(avg_sal),avg(max_sal) from cte_example;

with cte_example as (
select gender,
sum(salary) sum_sal,avg(salary) avg_sal,min(salary) min_sal,max(salary) max_sal,count(salary) count_sal
from employee_demographics dem join
employee_salary sal on dem.employee_id = sal.employee_id
group by gender
)
select gender,avg(sum_sal/count_sal) from cte_example
group by gender;

with cte_eg as(
select employee_id,first_name,gender
from employee_demographics 
where birth_date > '1985-01-01'
),cte_eg2 as (
select employee_id,salary from 
employee_salary where 
salary >= 50000
)
select e1.employee_id,first_name,gender,salary from cte_eg e1 join
cte_eg2 e2 on e1.employee_id = e2.employee_id;

with cte_eg as(
select employee_id,first_name,gender
from employee_demographics 
where birth_date > '1985-01-01'
),cte_eg2 as (
select employee_id,salary from 
employee_salary where 
salary >= 50000
)
select e1.employee_id,first_name,gender,salary from cte_eg e1 left join
cte_eg2 e2 on e1.employee_id = e2.employee_id;

-- TEMP TABLES
create temporary table fifa(
team varchar(30),
cups int,
manager varchar(30));

select * from fifa;

insert into fifa values('real madrid',11,'alonso');

select * from fifa;

create temporary table salary_over_50k
select * from employee_salary 
where salary >=50000;

select * from salary_over_50k;

-- STORED PROCEDURES

create procedure large_salary()
select * from employee_salary
where salary >= 50000;

call large_salary();

delimiter $$
create procedure large_sal2()
begin
select * from employee_salary
where salary >= 50000;
select * from employee_salary 
where salary > 11000;
end $$

delimiter ;

call large_sal2();

delimiter $$
create procedure emp_sal(i int)
begin
select salary from employee_salary
where employee_id = i;
end $$

delimiter ;

call emp_sal(2);

-- TRIGGERS

delimiter $$
create trigger emp_insert
after insert on employee_salary
for each row
begin 
insert into employee_demographics (employee_id,first_name,last_name)
values (new.employee_id,new.first_name,new.last_name);
end $$

delimiter ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13,'ajeeth','kumar','professor',10000000, NULL);

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(14,'krishna','devi','teacher',1000000, NULL);

select * from employee_salary;

select * from employee_demographics;

-- SET SQL_SAFE_UPDATES = 0;
-- delete from employee_salary where employee_id = 13;
-- delete from employee_salary where employee_id = 14;
-- delete from employee_demographics where employee_id = 14;

-- EVENTS

select * from employee_demographics
where age > 60;

DELIMITER $$
CREATE EVENT delete_retires
ON SCHEDULE EVERY 30 second
DO 
BEGIN
	DELETE FROM parks_and_recreation.employee_demographics
    where age >= 60;
END $$

DELIMITER ;

SELECT * FROM employee_demographics;