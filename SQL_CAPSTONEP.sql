SELECT * FROM amazon;
desc amazon;
-- Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening.
--  This will help answer the question on which part of the day most sales are made.
alter table amazon add column timeofday varchar(20) after Time;
set sql_safe_updates = 0;
UPDATE amazon 
SET 
    timeofday = CASE
        WHEN
            time >= '00:00:00'
                AND time <= '12:00:00'
        THEN
            'Morning'
        WHEN
            time >= '12:00:00'
                AND time <= '18:00:00'
        THEN
            'Afternoon'
        ELSE 'Evening'
    END;
--     Add a new column named dayname that contains the extracted days of the week on which the given 
--     transaction took place (Mon, Tue, Wed, Thur, Fri). 
--     This will help answer the question on which week of the day each branch is busiest.
ALTER TABLE amazon ADD COLUMN dayname VARCHAR(20) AFTER Date;
UPDATE amazon 
SET 
    dayname = CASE DAYOFWEEK(STR_TO_DATE(Date, '%d-%m-%Y'))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        
    END;
-- Add a new column named monthname that contains the extracted months of the year on 
-- which the given transaction took place (Jan, Feb, Mar). 
-- Help determine which month of the year has the most sales and profit.
alter table amazon add column monthname varchar(20) after Date;
update amazon
set monthname=
case month(STR_TO_DATE(Date, '%d-%m-%Y'))
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'Auguest'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
	end;

-- Business Questions To Answer:
-- 1. What is the count of distinct cities in the dataset?
select count(distinct(city))  as count_city from amazon;
select distinct(City),count(*) as count_city from amazon
group by City
order by count_city desc;
-- 2. For each branch, what is the corresponding city?
select distinct Branch,City from amazon;
-- 3. What is the count of distinct product lines in the dataset?
select distinct(`Product line`),count(*) as count_product from amazon
group by `Product line`
order by count_product desc;

select distinct `Product line` as count_product_line from amazon;
select count(distinct `Product line`) as count_product_line from amazon;
-- 4. Which payment method occurs most frequently?
select payment,count(*) as frequency from amazon
group by Payment
order by frequency desc;
-- 5. Which product line has the highest sales?
select `product line`,count(*) as total_sales from amazon
group by `product line`
order by total_sales desc
limit 1;
-- 6. How much revenue is generated each month?
select * from amazon;
select monthname,sum(Total) as revenue from amazon
group by monthname
order by revenue desc;
-- 7. In which month did the cost of goods sold reach its peak?
select monthname,sum(cogs) as total_cogs from amazon
group by monthname 
order by total_cogs desc;
-- 8. Which product line generated the highest revenue?
select `Product line`,sum(Total) as revenue from amazon
group by `Product line`
order by revenue desc;
-- 9. In which city was the highest revenue recorded?
select City,sum(Total) as total_revenue from amazon
group by City
order by total_revenue desc;
-- 10. Which product line incurred the highest Value Added Tax?
select `Product line`, sum(`Tax 5%`) as highest_tax from amazon
group by `Product line`
order by highest_tax desc;
-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 
    `Product line`,
    SUM(Total) AS total_sales,
    CASE
        WHEN
            SUM(Total) > (SELECT 
                    AVG(Total)
                FROM
                    amazon)
        THEN
            'Good'
        ELSE 'Bad'
    END AS sales_status
FROM
    amazon
GROUP BY `Product line`
ORDER BY total_sales DESC;
-- 12. Identify the branch that exceeded the average number of products sold.
select * from amazon;
select Branch, sum(Quantity) as total_quantity
from amazon
group by Branch
having sum(Quantity) > (select avg(Quantity) from amazon);
-- 13. Which product line is most frequently associated with each gender?
select `Product line`,Gender,count(*) as frequency from amazon
group by Gender,`Product line`
order by frequency asc;
-- 14. Calculate the average rating for each product line.
select `Product line`,avg(Rating) as avg_rating from amazon
group by `Product line`
order by avg_rating desc;
-- 15. Count the sales occurrences for each time of day on every weekday.
select timeofday,dayname,count(*) as sales_occurencees from amazon 
where dayname in ('Monday','Tuesday','Wedneday','Thursday','Friday')
group by timeofday,dayname
order by sales_occurencees desc;
-- 16. Identify the customer type contributing the highest revenue.
select * from amazon;
select `Customer type`,sum(Total) as highest_revenue from amazon
group by `Customer type`
order by highest_revenue desc;
-- 17. Determine the city with the highest VAT percentage.
select City,sum(`Tax 5%`) as total_vat,sum(Total) as Total_sales,(sum(`Tax 5%`)/(sum(Total)))*100 as  VAT_percentage from amazon
group by City
order by VAT_percentage desc;
-- 18. Identify the customer type with the highest VAT payments.
select `Customer type`,sum(`Tax 5%`) as highest_vat_payment from amazon
group by `Customer type`
order by highest_vat_payment desc;
-- 19. What is the count of distinct customer types in the dataset?
select count(distinct(`Customer type`)) distinct_customer from amazon;
select distinct `Customer type`, count(*) as distinct_count from amazon
group by `Customer type`
order by distinct_count desc;
-- 20. What is the count of distinct payment methods in the dataset?
select * from amazon;
select count(distinct(Payment)) as distinct_payment from amazon;
select distinct Payment, count(*) as distinct_count from amazon
group by Payment
order by distinct_count desc;
-- 21. Which customer type occurs most frequently?
select `Customer type`,count(*) as frequency from amazon
group by `Customer type`
order by frequency desc
limit 1;
-- 22. Identify the customer type with the highest purchase frequency.
select `Customer type`,count(*) as frequency from amazon
group by `Customer type`
order by frequency desc
limit 1;
-- 23. Determine the predominant gender among customers.
select Gender,count(*) as gender_count from amazon
group by Gender
order by gender_count desc;
-- 24. Examine the distribution of genders within each branch.
select Branch,Gender,count(*) as gender_count from amazon
group by Branch,Gender
order by gender_count desc;
-- 25. Identify the time of day when customers provide the most ratings.
select timeofday, count(Rating) as total_rating from amazon 
group by timeofday
order by total_rating desc;
-- 26.Determine the time of day with the highest customer ratings for each branch.
SELECT Branch, timeofday, COUNT(*) AS rating_count
FROM amazon
GROUP BY Branch, timeofday
ORDER BY rating_count DESC;
-- 27.Identify the day of the week with the highest average ratings.
select * from amazon;
select dayname, avg(Rating) as avg_rating from amazon
group by dayname
order by avg_rating desc;
-- 28.Determine the day of the week with the highest average ratings for each branch.
select Branch,dayname,avg(Rating) as avg_rating from amazon 
group by Branch,dayname
order by avg_rating desc;









