CREATE TABLE sales_data (
    invoice_id INT PRIMARY KEY,
    Branch VARCHAR(50),
    City VARCHAR(100),
    category VARCHAR(100),
    unit_price FLOAT,
    quantity FLOAT,
    date DATE,
    time TIME,
    payment_method VARCHAR(50),
    rating FLOAT,
    profit_margin FLOAT,
	TotalPrice FLOAT
);
/* Selecting all data*/
select * from sales_data;

/* Altering the totalprice datatype  */
alter table sales_data
alter column totalprice TYPE
DECIMAL(5,2);

/* Counting number of rows*/
select count(*) from sales_data;

/* For Payment type and number of transactions*/
select  payment_method,
   count(*)
   from sales_data
group by payment_method;

/* Branch and Branch count*/
select count(distinct branch) 
from sales_data; 

select distinct branch
from sales_data;

-- 1.find different payment method ,number of transactions and quantity sold
select  payment_method,
   count(*) as No_payments,
   sum (quantity) as Net_Quantity_sold
   from sales_data
group by payment_method;

--2. identify highest rated category in each branch, displaying the branch,category,avg rating
select branch,category,
avg(rating) as avg_rating,
rank() over(partition by branch order by avg(rating) desc) as rank   /* here rank() -> It is a window function*/
from sales_data
group by 1,2

/* Now for highest rated category*/
select *
from(
select branch,category,
avg(rating) as avg_rating,
rank() over(partition by branch order by avg(rating) desc) as rank
from sales_data
group by 1,2
) where rank=1

--3.identify the busiest day for each branch based on the number of transactions
select *
from(
     select branch,
      TO_CHAR(date , 'Day') as Day_name,
     count(*) as No_transactions,
     rank() over(partition by branch order by count(*) desc) as rank
     from sales_data
     group by 1,2
    )
where rank = 1

--4.Determine the average ,minimum and maximum rating of products for each city
select city,category,
   min(rating) as min_rating,
   max(rating) as max_rating,
   avg(rating) as avg_rating
   from  sales_data
   group by 1,2

--5.Calculate the total profit for each category by considering total profit as (unitprice*quantity*profitmargin)
--list the category and totalprofit ,ordered from highest to lowest profit
select category,
       sum(totalprice) as Total_revenue,
	   sum(totalprice * profit_margin) as profit
from sales_data	   
group by 1

--6.Determine the most common payment method for each branch
with cte as
(
select branch,payment_method,
       count(*) as Total_transaction,
	   rank() over(partition by branch order by count(*) desc) as rank
from sales_data
group by 1,2
)
select * from cte where rank=1

--7.Find out each of for morning,afternoon and evening and number of invoices
alter table sales_data
add column Day_time TIME;
update sales_data
set Day_time = time;

select *,
    case
	    when extract(hour from day_time) < 12 then 'Morning'
		when extract(hour from day_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end day_time
from sales_data


 --Number of invoices for each shifts
select branch,
    case
	    when extract(hour from day_time) < 12 then 'Morning'
		when extract(hour from day_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end day_time,
	count(*)
from sales_data 
group by 1,2


--8.Identify the 5 branch with highest decrease ratio in revenue compare to last year.
select * ,
extract (year from date) as year_only --extracting year from "date"
from sales_data

--final ans:-
with 
revenue_2022 as
(
select branch,
       sum(totalprice) as revenue
	   from sales_data
	   where extract (year from date) =2022
	   group by 1
),

revenue_2023 as
(
select branch,
       sum(totalprice) as revenue
	   from sales_data
	   where extract (year from date) =2023
	   group by 1
)

select 
      ls.branch,
	  ls.revenue as last_year_revenue,
	  cs.revenue as current_year_revenue
from revenue_2022 as ls
join
     revenue_2023 as cs
	 on ls.branch = cs.branch
where ls.revenue > cs.revenue

--9.Calculate the total quantity and revenue for each branch, 
    --filtering for only branches with a total revenue over $1000:

SELECT branch, SUM(quantity) AS total_quantity, SUM(quantity * unit_price) AS total_revenue
FROM sales_data
GROUP BY branch
HAVING SUM(quantity * unit_price) > 1000


--10.Determine the payment method with the lowest average rating for 
   --invoices with a profit margin above 0.4:

SELECT payment_method, AVG(rating) AS average_rating
FROM sales_data
WHERE profit_margin > 0.4
GROUP BY payment_method
ORDER BY average_rating ASC
LIMIT 1;

--11.Find the top 3 cities with the highest total revenue for each category:

SELECT 
    category,
    city,
    total_revenue,
    RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS revenue_rank
	
FROM (
    SELECT 
        category,
        city,
        SUM(quantity * unit_price) AS total_revenue
    FROM sales_data
    GROUP BY category, city
) aggregated_data
ORDER BY category, revenue_rank;



--12.Calculate the year-over-year revenue growth for each branch:

WITH branch_revenue AS (
  SELECT
    branch,
    DATE_PART('year', date) AS revenue_year,
    SUM(quantity * unit_price) AS revenue
  FROM sales_data
  GROUP BY branch, DATE_PART('year', date) -- Corrected GROUP BY clause
)
SELECT
  branch,
  revenue_year,
  revenue,
  LEAD(revenue, 1) OVER (PARTITION BY branch ORDER BY revenue_year) AS prior_year_revenue,
  ROUND(
    CAST((revenue - LEAD(revenue, 1) OVER (PARTITION BY branch ORDER BY revenue_year)) AS numeric) / 
    CAST(LEAD(revenue, 1) OVER (PARTITION BY branch ORDER BY revenue_year) AS numeric),
    2
  ) AS yoy_growth_rate
FROM branch_revenue
ORDER BY branch, revenue_year;


--13.Find the payment method with the highest average rating for each category, 
--but only for categories with an average rating above 7.0:

SELECT
  category,
  payment_method,
  AVG(rating) AS average_rating
FROM sales_data
WHERE category IN (
  SELECT category
  FROM sales_data
  GROUP BY category
  HAVING AVG(rating) > 7.0
)
GROUP BY category, payment_method
ORDER BY category, average_rating DESC;













