-- The sales territory that I am covering is MD

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?

-- ∗ What is the revenue breakdown by year and month for the sales territory?
-- ∗ Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
-- ∗ What is the number of transactions per month and average transaction amount by product category for the sales territory?
-- ∗ Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
-- ∗ What is your recommendation for where to focus sales attention in the next quarter?

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell 
-- you what period the data covers?
USE sample_sales;
SELECT SUM(Sale_Amount AND SalesTotal) AS total_revenue, MIN(s.Transaction_Date) as StartDate, MAX(s.Transaction_Date) as EndDate
FROM store_sales s
JOIN online_sales o
JOIN store_locations l
ON s.Store_ID = o.id
WHERE l.State = 'Maryland';

USE sample_sales;
SELECT SUM(revenue) AS total_revenue, 
MIN(sale_date) as StartDate,
MAX(sale_date) as EndDate
FROM (
	SELECT
		ss.Sale_Amount AS revenue,
        ss.Transaction_Date AS sale_date
	FROM store_sales ss
    JOIN store_locations sl
		ON ss.Store_ID = sl.StoreId
	WHERE sl.State = 'Maryland'
    UNION ALL
    SELECT
		os.SalesTotal AS revenue,
		os.Date AS sale_date
	FROM online_sales os
    WHERE os.ShiptoState = 'Maryland'
) AS all_sales;


-- ∗ What is the revenue breakdown by year and month for the sales territory?
USE sample_sales;
SELECT SUM(Sale_Amount AND SalesTotal) 
AS total_revenue, MIN(s.Transaction_Date) as StartDate, MAX(s.Transaction_Date) as EndDate, FORMAT(2022-01-01, 'yyyy, MM')
FROM store_sales s
JOIN online_sales o
JOIN store_locations l
ON s.Store_ID = o.id
WHERE l.State = 'Maryland';



