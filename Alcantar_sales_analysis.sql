-- The sales territory that I am covering is 'Maryland'

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell 
-- you what period the data covers?
USE sample_sales;
SELECT SUM(ss.Sale_Amount) AS Total_Revenue,
	MIN(ss.Transaction_Date) AS StartDate,
    MAX(ss.Transaction_Date) AS EndDate
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland';

-- What is the revenue breakdown by year and month for the sales territory?
USE sample_sales;
SELECT
	YEAR(ss.Transaction_Date) AS Sale_Year,
	MONTH(ss.Transaction_Date) AS Sale_Month,
	SUM(ss.Sale_Amount) AS Total_Revenue
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'
GROUP BY
	YEAR(ss.Transaction_Date),
    MONTH(ss.Transaction_Date)
ORDER BY
	Sale_Year, Sale_Month;
    
-- ∗ Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
USE sample_sales;
SELECT
	sl.State AS Sales_Territory,
    SUM(ss.Sale_Amount) AS Territory_Revenue,
	m.Region, 
	SUM(SUM(ss.Sale_Amount)) OVER (PARTITION BY m.Region
    ) AS Region_Revenue
FROM Store_Sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
JOIN management m
	ON sl.State = m.State
GROUP BY
	sl.State,
    m.Region
ORDER BY
	m.Region,
	sl.State;
    
-- What is the number of transaactions per month and average transaction amount by product category for the sales territory?
USE sample_sales;
SELECT YEAR(ss.Transaction_Date) AS Sale_Year,
MONTH(ss.Transaction_Date) AS Sale_Month,
ic.Category,
COUNT(*) AS Number_of_Transactions, AVG(ss.Sale_Amount) AS Average_Transaction_Amount
FROM store_sales ss
JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
JOIN products p 
	ON ss.Prod_Num = p.ProdNum
JOIN inventory_categories ic
	ON p.Categoryid = ic.Categoryid
WHERE sl.State = 'Maryland'
GROUP BY
	YEAR(ss.Transaction_Date),
    MONTH(ss.Transaction_Date),
    ic.Category
Order BY
	Sale_Year,
    Sale_Month,
    ic.Category;
    
-- ∗ Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?

USE sample_sales; 
SELECT 
    sl.StoreId, 
    SUM(ss.Sale_Amount) AS Total_Revenue, 
    RANK() OVER ( 
        ORDER BY SUM(ss.Sale_Amount) DESC 
    ) AS Sales_Rank 
FROM store_sales ss 
JOIN store_locations sl 
    ON ss.Store_ID = sl.StoreId 
WHERE sl.State = 'Maryland' 
GROUP BY 
    sl.StoreId 
ORDER BY 
	Sales_Rank; 
    
/* What is your recommendation for where to focus sales attention in the next quarter?
My recommendation where to focus sales attention in the next quarter is on storeId 731 because that store is making the least amount of revenue.
*/

USE sample_sales; 
SELECT
    ss.Store_ID, 
    YEAR(ss.Transaction_Date) AS Sale_Year,
    QUARTER(ss.Transaction_Date) AS Sale_Quarter, 
    SUM(ss.Sale_Amount) AS Total_Revenue, 
    COUNT(*) AS Total_Transactions, 
    AVG(ss.Sale_Amount) AS Average_Transaction_Amount
FROM store_sales ss 
WHERE ss.Store_ID IN ( 
    SELECT StoreId 
    FROM store_locations 
    WHERE State = 'Maryland' 
)
GROUP BY 
    ss.Store_ID, 
    YEAR(ss.Transaction_Date),
    QUARTER(ss.Transaction_Date) 
ORDER BY
    Sale_Year, 
    Sale_Quarter, 
    Total_Revenue DESC; 
/* First I start off my query with showing which store made the sales, then followed up with the year the sales happened.
After that I wanted the table to be easy to read and in the question we were asked about quarter sales so I implemented 
a QUARTER() statement. Then I added up the SUM of the revenue followed up with how many sales and the average sales amount to show
the average transaction amount. 


