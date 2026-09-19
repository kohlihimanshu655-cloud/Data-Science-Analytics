create database employee_behaviour;
use employee_behaviour;

create table employee_behaviour_analysis(
emp_no	varchar(200),
gender	varchar(200),
marital_status	varchar(200),
age_band	varchar(200),
age	int,
department	varchar(200),
education	varchar(200),
education_field	varchar(200),
job_role	varchar(200),
business_travel	varchar(200),
employee_count	varchar(200),
attrition	varchar(200),
attrition_label	varchar(200),
job_satisfaction int,
active_employee int);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Analyzing Employee Behaviour.csv"
INTO TABLE employee_behaviour_analysis
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from employee_behaviour_analysis;

describe employee_behaviour_analysis;

alter table employee_behaviour_analysis
modify column employee_count int;


select * from employee_behaviour_analysis
where emp_no is null;

-- 8.1 Find NULL Values 

select * from employee_behaviour_analysis
where emp_no is null
or gender is null
or marital_status is null
or age_band is null
or age is null
or department is null
or education is null
or education_field is null
or job_role is null
or business_travel is null
or employee_count is null
or attrition is null
or attrition_label is null
or job_satisfaction is null
or active_employee is null;



-- 8.2 Find Duplicate Records 

select emp_no, count(*) from employee_behaviour_analysis
group by emp_no
having count(*)>1;

select * from employee_behaviour_analysis;


-- 8.3 Remove Extra Spaces 
 UPDATE employee_behaviour_analysis
SET 

    gender = TRIM(gender),
    emp_no= trim(emp_no),
    marital_status = TRIM(marital_status),
    age_band = TRIM(age_band),
    age=TRIM(age),
    department = TRIM(department),
    education = TRIM(education),
    education_field = TRIM(education_field),
    job_role = TRIM(job_role),
    business_travel = TRIM(business_travel),
    employee_count = trim(employee_count),
    attrition = TRIM(attrition),
    attrition_label = TRIM(attrition_label),
    job_satisfaction= trim(job_satisfaction),
    active_employee= trim(active_employee);
    
    
    -- 8.4 Standardize Gender Values 
    
    Select distinct gender from
    employee_behaviour_analysis;
    
    

-- 8.5 Create Clean Salary Column 

select * from employee_behaviour_analysis;

alter table employee_behaviour_analysis
add column clean_salary int;

-- 8.6 Clean Salary Values 
update employee_behaviour_analysis
set clean_salary=floor(30000+(Rand()*70000));

-- 8.7 Detect Invalid Ages 

SELECT age
FROM employee_behaviour_analysis
WHERE age IS NULL
   OR age < 18
   OR age > 68;
   
   
    --  or use this
    
   SELECT age
FROM employee_behaviour_analysis
WHERE age REGEXP '[A-Z,a-z]';

-- 8.8 Standardize Joining Dates

UPDATE fyp
SET join_date =
DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND()*1000) DAY);



select * from employee_behaviour_analysis;

describe employee_behaviour_analysis;

-- 9 Data Validation done...all correct...
-- 9.1	

-- 9.2 Add NOT NULL Constraint 
ALTER TABLE employee_behaviour_analysis
MODIFY emp_no INT NOT NULL;
 

-- Which department has the highest employee attrition on rate? 

SELECT department,count(*),
    sum(CASE 
        WHEN attrition = 'Yes' THEN 1 else 0
    END) AS attrition ,
    round(sum(CASE 
        WHEN attrition = 'Yes' THEN 1 else 0
    END) * 100/count(*),2)
    AS attrition_rate
    from employee_behaviour_analysis
group by department
order by attrition_rate desc limit 1;

select * from employee_behaviour_analysis;


 alter table employee_behaviour_analysis
 add column overtime varchar(200);
 
 
 

UPDATE employee_behaviour_analysis
SET overtime = CASE
    WHEN RAND() > 0.7 THEN 'Yes'
    ELSE 'No'
END;



-- Does overtime increase resignation probability? 

SELECT 
    overtime,
    COUNT(*) AS employees,
    sum(CASE 
        WHEN attrition = 'Yes' THEN 1 else 0
    END) AS attrition
    ,round(sum(CASE 
        WHEN attrition = 'Yes' THEN 1 else 0
    END*100)/count(*),2) AS attrition
FROM employee_behaviour_analysis
GROUP BY overtime;


ALTER TABLE employee_behaviour_analysis
ADD performance_rating INT,
ADD work_life_balance INT,
ADD monthly_hours INT,
ADD years_at_company INT;


---

# 5. Generate Sample Data for New Columns

## Random Salary


UPDATE employee_behaviour_analysis
SET clean_salary = FLOOR(30000 + (RAND() * 90000));


---

## Random Overtime




---

## Random Performance Rating


UPDATE employee_behaviour_analysis
SET performance_rating = FLOOR(1 + (RAND() * 5));


---

## Random Work Life Balance


UPDATE employee_behaviour_analysis
SET work_life_balance = FLOOR(1 + (RAND() * 5));


---

## Random Monthly Hours


UPDATE employee_behaviour_analysis
SET monthly_hours = FLOOR(120 + (RAND() * 120));


---

## Random Years at Company


UPDATE employee_behaviour_analysis
SET years_at_company = FLOOR(1 + (RAND() * 20));

select *from employee_behaviour_analysis;

-- Which employees are at highest attrition on risk? 


SELECT COUNT(*) AS total_employees
FROM employee_behaviour_analysis
WHERE performance_rating < 2
AND work_life_balance < 2
AND monthly_hours > 100
AND years_at_company > 6;


--  Which department has the highest burnout level?

SELECT
    department,
    AVG(monthly_hours) AS avg_hours,
    AVG(work_life_balance) AS avg_work_life_balance
FROM employee_behaviour_analysis
GROUP BY department
ORDER BY avg_hours DESC, avg_work_life_balance ASC;

select *from employee_behaviour_analysis;

--  Are high-performing employees underpaid?

select emp_no,performance_rating,clean_salary
from employee_behaviour_analysis
where clean_salary<= (select avg(clean_salary)from employee_behaviour_analysis)
and performance_rating >=4;


  -- 0r use below
  
  
SELECT 
    emp_no,
    performance_rating,
    clean_salary,
    CASE 
        WHEN clean_salary >= 30000 
        AND performance_rating >= 4 
        THEN 'Good Pay'
        ELSE 'Underpaid'
    END AS good_pay
FROM employee_behaviour_analysis;

select *from employee_behaviour_analysis;

 -- Which department gives the best performance for salary paid?
select department, 
round(avg(clean_salary),2) as avg_salary,
round(avg(performance_rating),2) as avg_per_rating,
round(avg(clean_salary)/avg(performance_rating),2) as efficiency_score
from employee_behaviour_analysis
group by department
order by efficiency_score;


-- Which employees deserve promotion?

select emp_no,performance_rating,years_at_company,
case
when years_at_company>=4
and performance_rating>=4
then 'promotion'
else 'no_promotion'
END AS promotion
FROM employee_behaviour_analysis;


-- Which departments have poor work-life balance?

SELECT 
    department,
    work_life_balance,
    CASE
        WHEN work_life_balance < 3 THEN 'Poor'
    END AS Balance
FROM employee_behaviour_analysis
WHERE work_life_balance < 3
;

-- or we can use below


SELECT 
    department,
    COUNT(*) AS poor_employee_count,
    'Poor' AS Balance
FROM employee_behaviour_analysis
WHERE work_life_balance < 3
GROUP BY department;


select *from employee_behaviour_analysis;

-- Which employees work excessive hours?

SELECT
    emp_no,
    department,
    monthly_hours
FROM employee_behaviour_analysis
WHERE monthly_hours > (select Avg(monthly_hours) from employee_behaviour_analysis)
ORDER BY monthly_hours DESC;

-- Which departments retain employees best?

select department,round(sum(case when attrition ='No' then 
1 else 0 end)
*100.0/count(*),2)
as retention_rate
from employee_behaviour_analysis
group by department
order by retention_rate desc;
  
  
  
select *from employee_behaviour_analysis;
  
-- Does work-life balance affect performance?  

select work_life_balance,	
round(avg(performance_rating),2) as avg_performance
from employee_behaviour_analysis
group by work_life_balance
order by work_life_balance;

--  Which employees show exceptional performance? 

SELECT
    emp_no,
    department,
    performance_rating,
    salary
FROM analyzing_employee_behaviour
WHERE performance_rating = 5
ORDER BY salary DESC;


select *from employee_behaviour_analysis;
 -- Which departments are overstaffed or understaffed?
 
SELECT
    department,
    COUNT(*) AS employee_count,
    CASE
        WHEN COUNT(*) > 500 THEN 'Overstaffed'
        WHEN COUNT(*) < 100 THEN 'Understaffed'
        ELSE 'Balanced'
    END AS workforce_status
FROM employee_behaviour_analysis
GROUP BY department;
 
 
 select *from employee_behaviour_analysis;
 
 -- Which employees may require training
 
 select emp_no,
 department,
 performance_rating,
 job_satisfaction
 from employee_behaviour_analysis
 where performance_rating<=2
 or job_satisfaction<=2;
 
 -- Does salary impact attrition on? 
 
 SELECT
    attrition,
    ROUND(AVG(clean_salary),2) AS avg_salary
FROM employee_behaviour_analysis
GROUP BY attrition;
 
 select *from employee_behaviour_analysis;
 -- Which departments have the largest salary inequality?
 
 SELECT
    department,
    MAX(clean_salary) AS highest_salary,
    MIN(clean_salary) AS lowest_salary,
    MAX(clean_salary) - MIN(clean_salary) AS salary_gap
FROM employee_behaviour_analysis
GROUP BY department
ORDER BY salary_gap DESC;
 
 select *from employee_behaviour_analysis;
 
 -- Which employees are improving or declining? 
 
 SELECT 
    emp_no,
    performance_rating,
    work_life_balance,
    overtime,
    
    CASE
        WHEN performance_rating >= 4 
             AND work_life_balance >= 3 
        THEN 'Improving'
        
        WHEN performance_rating <= 2 
             AND work_life_balance < 3 
        THEN 'Declining'
        
        ELSE 'Stable'
    END AS employee_status
FROM employee_behaviour_analysis;


-- or use this

SELECT
    emp_no,
    department,
    clean_salary,
    LAG(clean_salary) OVER (
        PARTITION BY department
        ORDER BY years_at_company
    ) AS previous_salary,
     Lead(clean_salary) OVER (
        PARTITION BY department
        ORDER BY years_at_company
    ) AS salary_growth
FROM employee_behaviour_analysis;
 
 
 -- Which departments have the highest average performance? 
 
 SELECT
    department,
    ROUND(AVG(performance_rating),2) AS avg_performance
FROM employee_behaviour_analysis
GROUP BY department
order by avg_performance;

select *from employee_behaviour_analysis;

--  Which employees are ranked highest within departments?

SELECT
    emp_no,
    department,
    performance_rating,
    RANK() OVER (
        PARTITION BY department
        ORDER BY performance_rating DESC
    ) AS department_rank
FROM employee_behaviour_analysis;

-- Create a workforce KPI dashboard summary


# 20. Workforce KPI Dashboard Summary

## KPI 1 — Total Employees


SELECT COUNT(*) AS total_employees
FROM employee_behaviour_analysis;


---

## KPI 2 — Average Salary


SELECT ROUND(AVG(Clean_salary),2) AS average_salary
FROM employee_behaviour_analysis;


---

## KPI 3 — Attrition Rate


SELECT
    ROUND(
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM employee_behaviour_analysis;


---

## KPI 4 — Average Performance Rating


SELECT ROUND(AVG(performance_rating),2) AS avg_performance_rating
FROM employee_behaviour_analysis;


---

## KPI 5 — Overtime Employees


SELECT COUNT(*) AS overtime_employees
FROM employee_behaviour_analysis
WHERE overtime = 'Yes';




 