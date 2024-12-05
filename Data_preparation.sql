USE Global_electronics_project;
select count(CustomerKey) from overall_data;

# Use Safe Update to bypass this restriction and error
SET SQL_SAFE_UPDATES =1;

# Change all date date to DATETIME Format
UPDATE overall_data SET Birthday = STR_TO_DATE(BirthDay, '%m/%d/%Y');
UPDATE overall_data SET Order_Date = DATE(Order_Date);
UPDATE overall_data SET Birthday = STR_TO_DATE(BirthDay, '%Y-%m-%d');


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




