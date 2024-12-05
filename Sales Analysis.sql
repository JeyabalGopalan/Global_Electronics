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

# 5sales analysis on profit by currency
select Currency,sum(Unit_Price_USD-Unit_Cost_USD)as profit from overall_data group by Currency order by profit desc;

# 6 sales analysis on top 10 products by profit and sales
select Product_Name,sum(Quantity+Unit_Price_USD)as total_sales,sum(Unit_Price_USD-Unit_Cost_USD)as profit
from overall_data group by Product_Name order by total_sales desc,profit desc limit 10;