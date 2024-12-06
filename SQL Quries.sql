USE Global_electronics_project;
select * from overall_data;

# Upadating the Profit column by Mulitplying with Quantity
UPDATE overall_data SET Profit = Quantity * Profit;
 Select profit from overall_data;

# Creating the New column as Age
ALTER TABLE overall_data ADD COLUMN Age INT;
UPDATE overall_data SET Age = TIMESTAMPDIFF(YEAR, BirthDay, CURDATE()) WHERE BirthDay IS NOT NULL;

Alter Table Overall_data add column Quarter_year int;
Update Overall_data set  Quarter_year = Quarter(Order_Date);

# Creating the New column as Age_group
ALTER TABLE overall_data ADD COLUMN Age_group VARCHAR(10);
UPDATE overall_data
SET Age_group = CASE
    WHEN age BETWEEN 10 AND 19 THEN '10-19'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    WHEN age BETWEEN 50 AND 59 THEN '50-59'
    WHEN age BETWEEN 60 AND 69 THEN '60-69'
    WHEN age >= 70 THEN '70+'
    ELSE 'Under 10'
END;

#1. Customer Analysis
# 1.1 Demographic Distribution: Analyze the distribution of customers based on gender, age (calculated from birthday), location (city, state, country,continent).
# 1.2 Purchase Patterns: Identify purchasing patterns such as average order value, frequency of purchases, and preferred products.
# 1.3 Segmentation: Segment customers based on demographics and purchasing behavior to identify key customer groups

select * from overall_data;

# 1.1 Demographic Distribution: Analyze the distribution of customers based on gender, age (calculated from birthday), location (city, state, country,continent).

# 1- Distribution of Unique customer based on Location (Continent, Country)
select Continent, Customer_Country, COUNT(Distinct CustomerKey) as No_of_Customer,  
	COUNT(CustomerKey) AS No_of_Orders, ROUND(SUM(Profit), 2) AS Profit 
	from overall_data group by Continent, Customer_Country ORDER BY Profit desc;

# 2- Distribution of Total Order based on Top city and State based on the Total No of Order in the country
WITH RankedData AS (
    SELECT Continent, Customer_Country, COUNT(CustomerKey) AS No_of_Order, ROUND(SUM(Profit), 2) AS Profit
    FROM overall_data GROUP BY Continent, Customer_Country )
SELECT Continent, Customer_Country, No_of_Order, Profit, 
   ( SELECT Customer_State FROM overall_data WHERE overall_data.Customer_Country = RankedData.Customer_Country 
     ORDER BY Customer_State LIMIT 1 ) AS Top_Customer_State,
   ( SELECT Customer_City FROM overall_data WHERE overall_data.Customer_Country = RankedData.Customer_Country 
     ORDER BY Customer_City LIMIT 1 ) AS Top_Customer_City
FROM RankedData ORDER BY No_of_Order DESC limit 10;

# 1 Analysis of total customers by gender
select Gender, count(CustomerKey) as Tot_Orders, count(distinct CustomerKey) as No_of_Customer from overall_data group by Gender order by Tot_Orders desc;

#2  Analysis of total customers gender wise by country
select Customer_Country,gender,count(distinct CustomerKey) as total_customers from overall_data group by Customer_Country,gender order by total_customers desc;

#3 Analysis of top 10 customers by revenue
select Name, round(sum(Quantity * Unit_Price_USD), 2) as total_revenue from overall_data group by Name order by total_revenue desc limit 10;



# 3- Distribution of customer based on Gender, Age
Select Gender, Age_group, COUNT(Distinct CustomerKey) as No_of_Customer, count(CustomerKey) as No_of_Oders, Round(sum(profit), 2) as Profits 
from overall_data group by Gender, Age_group order by No_of_Customer Desc;


# 1.2 Purchase Patterns: Identify purchasing patterns such as average order value, frequency of purchases, and preferred products.

# 4- Overall average Order Value from overall Dataset
with AOV as(
select Count(Order_Number) as Total_Orders, sum(Unit_Price_USD) as Revenue from overall_data 
)
select Total_Orders, round(Revenue, 2) as Tot_Revenue, round(Revenue/Total_Orders, 2) as Average_order_value from AOV;


# 5 - Average Order Value from overall Dataset for every Quarter of the Year
with AOV as(
select Quarter_year, Count(Quarter_year) as Total_Orders, sum(Quantity * Unit_Price_USD) as Revenue from overall_data group by Quarter_year
 )
select Quarter_year, Total_Orders, round(Revenue, 2) as Tot_Revenue, round(Revenue/Total_Orders, 2) as Average_order_value from AOV group by Quarter_year;


# 6- Calculating the frequency of purchace more than one order
#-- Step 1: Count the number of line items per order
WITH OrderCounts AS (
    SELECT Order_Number, 
        COUNT(DISTINCT Line_Item) AS line_item_count
    FROM Overall_data GROUP BY Order_Number)
-- Step 2: Calculate the percentage
SELECT   COUNT(CASE WHEN line_item_count > 1 THEN 1 END) * 100.0 / COUNT(*) AS percentage_multiple_purchases
FROM OrderCounts ;

# 7 -Calculating the of purchace for every line_item
with Line_Items as(
SELECT Order_Number, COUNT(DISTINCT Line_Item) AS line_item_count FROM Overall_data GROUP BY Order_Number
	)
select line_item_count, count(line_item_count) as No_of_Customers from Line_Items group by line_item_count;



# 2. Sales Analysis
USE Global_electronics_project;
select * from overall_data;

# 2.1 Overall Sales Performance: Analyze total sales over time, identifying trends and seasonality


# 8- Sales by Product: Evaluate which products are the top performers in terms of quantity Revenue generated.
Select Product_Name, sum(Quantity) as Quantity, count(Product_Name) as Product_Count, sum(profit) as Profit from overall_data group by Product_Name order by profit Desc limit 10;

# 9- Sales by Product: Evaluate which products are the top performers in terms of Quantity Sold 
Select Product_Name, sum(Quantity) as Quantity, count(Product_Name) as Product_Count, sum(profit) as Profit from overall_data group by Product_Name order by Quantity Desc limit 10;

# 10- Sales by Store: Assess the performance of different stores based on sales data.
Select StoreKey, Square_Meters ,
	count(distinct Product_Name) as Product_Count, 
    sum(Quantity) as Quantity_sold, 
    Round(sum(profit), 2) as Profit_Revenue_generated 
from overall_data group by StoreKey, Square_Meters 
order by Profit_Revenue_generated Desc limit 10;

#4 sales analysis by category on quantity sold
select Category,sum(Quantity) as total_quantity from overall_data group by category order by total_quantity desc;

# 5- Sales analysis on profit by currency
select Currency,sum(Unit_Price_USD-Unit_Cost_USD)as profit from overall_data group by Currency order by profit desc;

# 6 sales analysis on top 10 products by profit and sales
select Product_Name,sum(Quantity+Unit_Price_USD)as total_sales,sum(Unit_Price_USD-Unit_Cost_USD)as profit
from overall_data group by Product_Name order by total_sales desc,profit desc limit 10;

select Continent, count(StoreKey) as No_of_Orders, count(Distinct StoreKey) as Unique_Store,
    Sum(Quantity) as Quantity_orders, round(sum(Square_Meters), 2) as Store_SQM, 
    round(sum(profit), 2) as Profit
from overall_data where Store_Country != 'Online' group by Continent ;

select Continent, count(StoreKey) as No_of_Orders,  
Sum(Quantity) as Quantity_orders, round(sum(profit), 2) as Profit
from overall_data 
where Store_Country = 'Online'
group by Continent ;

select Category,sum(Quantity) as total_quantity, round(sum(profit),2) as Profit 
from overall_data 
where Store_Country != 'Online'
group by category order by total_quantity desc;

select Category, sum(Quantity) as total_quantity, round(sum(profit),2) as Profit from overall_data group by category order by total_quantity desc;