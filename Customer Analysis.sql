#1. Customer Analysis
# 1.1 Demographic Distribution: Analyze the distribution of customers based on gender, age (calculated from birthday), location (city, state, country,continent).
# 1.2 Purchase Patterns: Identify purchasing patterns such as average order value, frequency of purchases, and preferred products.
# 1.3 Segmentation: Segment customers based on demographics and purchasing behavior to identify key customer groups

select * from overall_data;

# 1.1 Demographic Distribution: Analyze the distribution of customers based on gender, age (calculated from birthday), location (city, state, country,continent).

# 1- Distribution of Unique customer based on Location (Continent, Country)
select Continent, Customer_Country, COUNT(Distinct CustomerKey) as No_of_Customer,  COUNT(CustomerKey) AS No_of_Orders, ROUND(SUM(Profit), 2) AS Profit 
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
select Gender, count(CustomerKey) as total_customers from overall_data group by Gender order by total_customers desc;

#2  Analysis of total customers gender wise by country
select Customer_Country,gender,count(CustomerKey) as total_customers from overall_data group by Customer_Country,gender order by total_customers desc;

#3 Analysis of top 10 customers by revenue
select Name,sum(Unit_Price_USD)as total_revenue from overall_data group by Name order by total_revenue desc limit 10;



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
select Quarter_year, Count(Quarter_year) as Total_Orders, sum(Unit_Price_USD) as Revenue from overall_data group by Quarter_year
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
