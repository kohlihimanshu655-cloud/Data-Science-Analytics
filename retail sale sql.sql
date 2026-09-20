create database sql_project_p2;
use sql_project_p2;

select * from retail_sales;

##DATA CLEANING--  

alter table retail_sales
rename column ï»¿transactions_id  to transaction_id;


select * from retail_sales
where 
transaction_id is null
or 
sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or 
category is null
or
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;


select count(*) from retail_sales;


##DATA EXPLORATION 
-- How many sales we have?
 select count(*) as Total_sales
 from retail_sales;

-- How many customer we have? 
select count(distinct customer_id) as total_customer
from retail_sales;


select count(distinct category) as total_category
from retail_sales;


select distinct category from retail_sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEM
select * from retail_sales;
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold
-- is more than 10 in the month of nov-2022 

select * from retail_sales
where category = 'Clothing' and quantiy > 10
and sale_date = '2022-11-01';


-- write a SQL query  to calculate the total sales for each category.

select category, sum(total_sale) as net_sales
from retail_sales
group by 1;


-- write a SQL query to find the average age  of customers who purchased items from the 'Beauty' category.
select age,avg(age) as avg_age, category
from retail_sales
where category = 'Beauty'
group by age;


select * from retail_sales;
-- write a SQL query  to find all transactions where the total sale is greater than 1000.

select * from retail_sales
where total_sale>1000;


-- write the  SQL query  to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(distinct transaction_id) 
from retail_sales
group by category,gender
order by 2;

select * from retail_sales;
-- write a SQL query to calculate the average sale for each month. find out best selling month in each year.

SELECT *
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS `rank`
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE `rank` = 1;

select * from retail_sales;
-- Write a SQL query to find the top 5 customers based on highest total sales

select customer_id, sum(total_sale)
from retail_sales
group by customer_id
order by 2 desc limit 5;

-- Write a  SQL query  to find the number of  unique customers who purchased items from each category.

select count(distinct customer_id) as uniquecustomer, category 
from retail_sales
group by category;

-- write a SQL query  to  create each shift and  number of orders (example morning <12,afternoon between 12 & 17, evening >17)

select *,
case
when hour(sale_time)<12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
else 'evening'
end as shift
from retail_sales;


-- END OF PROJECT
