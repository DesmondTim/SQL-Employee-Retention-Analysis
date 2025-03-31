create database if not exists EmployeeAnalysis;
use employeeAnalysis;
## drop table if exists employees;
create table Employees(
employee_id int primary  key auto_increment,
satisfaction_level decimal(3,2),
last_evaluation decimal(3,2),
number_project int ,
average_monthly_hours int,
time_spend_company int,
work_accident tinyint(1),
left_company  tinyint(1),
promotion_last_5years tinyint(1),
department varchar(20),
salary enum ('low', 'medium', 'high')
);

use employeeanalysis;
select * from employees;

-- Trends Between Satisfaction Level and Employee Retention
select 
left_company, avg(satisfaction_level)  as avg_satisfaction
from employees
group by left_company;

-- Compare satisfaction level across different department
select 
department,
avg(satisfaction_level) as avg_satisfaction
from employees
group by department;

-- Impact of no of project and work hour of employee

select
	number_project,
	avg(last_evaluation) as avg_performance,
	avg(average_monthly_hour) as avg_hours
from employees
group by number_project
order by avg_performance desc;

select max(average_monthly_hour)from employees;


-- Identifying employess at risk of burnout
select
last_evaluation,
number_project,
average_monthly_hour
from employees
-- where average_monthly_hour>310
-- select average_monthly_hour avg(average_monthly_hour) from employees
where average_monthly_hour > (select avg(average_monthly_hour) from employees)
order by average_monthly_hour desc
limit 10;

-- 	COMMON PATTERNS AMONG EMPLOYEE THAT LEFT
select* from employees;
select 
	avg(satisfaction_level) as avg_satisfaction,
	avg(last_evaluation) as avg_performance,
	avg(number_project) as avg_project_handled,
	avg(time_spend_company) as avg_tenure,
	avg(salary) as avg_salary
from employees
where left_company = 1;

-- INFLUENCE ON PROMOTION AND RETENTION
SELECT 
	salary,
    promotion_last_5years,
    count(*) as Total_employee,
    sum(left_company) as Left_employee
    from employees
    group by salary, promotion_last_5years
    order by left_employee desc
    ;
    
    -- ASSESING TURN-OVER RATE BY THE DEPARTMENT
    select 
		department,
		count(*) as total_employee,
		sum(left_company) as left_employee,
		(sum(left_company)/ count(*))/ 100 as Turn_over_rate
from employees
group by department
order by turn_over_rate desc
;

-- Department with high retention and satisfaction
select
	department,
    avg(satisfaction_level) as avg_satisfaction,
        count(*) as Total_employees,
    sum(left_company) as left_employee
from employees
group by department
having left_employee< (select avg(left_company) from employees)
order by avg_satisfaction desc
;

-- 5 Analysing salary trends across department
 SELECT 
    department, 
    salary, 
    COUNT(*) AS total_employees, 
    SUM(left_company) AS employees_left 
FROM Employees
GROUP BY department, salary
ORDER BY department, salary desc
;

-- how salary influence satisfaction based on attrition
-- Attrition refers to the gradual reduction in the number of employees in a company due to resignations,
-- retirements, or other voluntary/involuntary departures.

SELECT 
    department, 
    salary, 
    COUNT(*) AS total_employees, 
    SUM(left_company) AS employees_left,
    ROUND((SUM(left_company) / COUNT(*)) * 100, 2) AS attrition_rate
FROM Employees
GROUP BY department, salary
ORDER BY attrition_rate DESC;

