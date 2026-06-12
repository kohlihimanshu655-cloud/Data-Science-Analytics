create database Swiggy_Dataa;
use Swiggy_Data;


create table Swiggy_Data (
State	varchar(200),
City varchar(200),
OrderDate varchar(200),
RestaurantName	 varchar(200),
Location	varchar(200),
Category	varchar(200),
DishName	varchar(200),
Price int,
Rating	decimal(10,2),
RatingCount int);


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Swiggy_Data.csv"
INTO TABLE Swiggy_Data
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from Swiggy_Data;

describe Swiggy_Data;

delete  from swiggy_data
where State = ' '
or City = ' '
or OrderDate = ' '
or RestaurantName = ' '
or Location = ' '
or Category = ' '
or DishName= ' ' 
;

###QUESTION
##Basic KPIs
##•	Total Orders
##•	Average Dish Price
##•	Average Rating
select * from Swiggy_Data;


Select OrderDate, count(*)as total_order from swiggy_data
group by OrderDate;

select DishName,avg(price) as avg_dish_price
from swiggy_data
group by DishName;

select DishName, avg(rating)as avg_rating
from swiggy_data
group by DishName;


##Date-Based Analysis
##•	Monthly order trends
##•	Quarterly order trends
##•
##•	Day-of-week patterns
select * from Swiggy_Data;
   
   UPDATE swiggy_data
SET OrderDate = DATE_FORMAT(
    STR_TO_DATE(OrderDate, '%Y-%m-%d'),
    '%Y/%m/%d'
);


select month(OrderDate) as Month ,
count(*) as total_order 
from swiggy_data
group by month(OrderDate)
order by Month desc
;

select * from Swiggy_Data;

SELECT 
    QUARTER(OrderDate) AS Quarter,
    COUNT(*) AS Total_Orders
FROM swiggy_data
GROUP BY QUARTER(OrderDate)
ORDER BY Quarter desc;

select year(OrderDate),sum(price)
from swiggy_data
group by year(OrderDate);

select * from Swiggy_Data;

SELECT 
    DAYNAME(OrderDate) AS day_name,
    COUNT(*) AS total_orders
FROM swiggy_data
GROUP BY day_name
ORDER BY total_orders DESC;

##Location-Based Analysis
##•	Top 10 cities by order volume
##•	Revenue contribution by states

select * from Swiggy_Data;

select City, count(*)as total_orders
from swiggy_data
group by City 
order by total_orders desc limit 10;


select State, sum(Price) as total_revenue
from swiggy_data
group by State
order by total_revenue desc;


#Food Performance
#•	Top 10 restaurants by orders
#•	Top categories (Indian, Chinese, etc.)
#	Most ordered dishes
#•	Cuisine performance → Orders + Avg Rating

select * from Swiggy_Data;

select RestaurantName, count(*) as OrderDate
from swiggy_data
group by RestaurantName
order by OrderDate desc limit 10;

 select Category, DishName, Rating from swiggy_data
 where Category = 'North Indian Rice'
 order by rating desc limit 1;
 
 SELECT DishName, COUNT(*) AS total_orders
FROM swiggy_data
GROUP BY DishName
ORDER BY total_orders DESC
LIMIT 5;
 
 select * from Swiggy_Data;
 
 select Category, DishName, Rating from swiggy_data
 where Category = 'Chinese Rice'
 order by rating desc limit 1;
 
 select DishName, count(*) as total_orders from swiggy_data
 group by DishName
 order by total_orders  desc limit 1 ;
 
SELECT 
    Category,
    COUNT(*) AS total_orders,
    AVG(Rating) AS avg_rating
FROM swiggy_data
GROUP BY Category
ORDER BY total_orders DESC;

#Buckets of customer spend:
#•	Under 100
#•	100–199
#•	200–299
#•	300–499
#•	500+
#With total order distribution across these ranges.

 select * from Swiggy_Data;
 
select case
when Price <100 then 'under 100'
when Price between 100 and 199 then '100-199'
when price between 200 and 299 then '200-299'
when Price between 300 and 499 then '300-499'
else '500+'
end as spend_bucket,
count(*) as total_orders
from swiggy_data
group by spend_bucket
order by total_orders desc;

##Distribution of dish ratings from 1–5.

select * from Swiggy_Data;

select rating ,DishName
from swiggy_data
order by Rating desc;

SELECT 
ROUND(Rating) AS rating,
COUNT(*) AS total_count
FROM swiggy_data
GROUP BY ROUND(Rating)
ORDER BY rating;

SELECT 
COUNT(*) AS five_star_orders
FROM swiggy_data
WHERE ROUND(Rating) = 5;

SELECT 
    Rating,
    COUNT(*) AS total_count
FROM swiggy_data
GROUP BY Rating
ORDER BY Rating desc;


