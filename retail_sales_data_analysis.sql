-- Create Table and Import Data

drop table if exists retail_sales_data;
create table RETAIL_SALES_DATA
(Transactions_id int Primary key,
Sale_Date date,
Sale_Time time,
Customer_id int,
Gender varchar(50),
Age int,
Category varchar(50),
Quantity int,
Price_per_unit float,
COGS float,
Total_Sale float
)
;

-- Dats Cleaning 

select *
from retail_sales_data
where Transactions_id is null
	or sale_date is null 
	or Sale_Time is null
	or Customer_id is null
    or Gender is null
    or Age is null
    or Category is null
    or Quantity is null
	or Price_per_unit is null
    or COGS is null
    or Total_Sale is null;
    
-- Data Exploration

-- How many sales we have??

select count(*)
from retail_sales_data;

-- How many customers we have??

select count(distinct Customer_id) as Total_Unique_Customer
from retail_sales_data;

-- Data Analysis / Business Key Problems and Answers

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
from retail_sales_data
where Sale_Date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:

select *, month(Sale_Date)
from retail_sales_data
where Category = 'Clothing' 
	and month(Sale_Date) = 11 
		and Quantity >= 4;
	
-- Write a SQL query to calculate the total sales (total_sale) for each category.:

select Category, SUM(Total_Sale)
From retail_sales_data
Group by 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select Category, avg(Age)
From retail_sales_data
where Category = 'Beauty'
;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select *
From retail_sales_data
where Total_Sale > 1000
;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select Category, Gender, Count(Transactions_id)
From retail_sales_data
Group by 1,2
order by 1,2
;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select *
From (
		select Year(Sale_Date) as yr, Month(Sale_Date) as mo, avg(Total_Sale), 
		rank() Over(Partition by Year(Sale_Date) order by avg(Total_Sale) desc) as ranking
		From retail_sales_data
		Group by 1,2
		Order by 3 desc
	) as t1 
where ranking = 1
;

-- Write a SQL query to find the top 5 customers based on the highest total sales

select Customer_id, sum(Total_Sale) as TOTALSALE
from retail_sales_data
group by 1
order by 2 desc
limit 5;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17

With Shift as 

(
select *,
CASE 
	WHEN Hour(Sale_Time) < 12 THEN 'Morning'
    WHEN Hour(Sale_Time) > 12 and Hour(Sale_Time) < 17 THEN 'Afternoon'
    Else 'Evening'
END as shift
from retail_sales_data
)

select shift, Count(*) as total_order
from Shift
group by 1
;