
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ORDERS_VIEW" ("ORDER_ID", "ORDER_DATETIME", "CUSTOMER_ID", "ORDER_STATUS", "STORE_ID", "REVENUE") AS 
  SELECT 
    o."ORDER_ID",o."ORDER_DATETIME",o."CUSTOMER_ID",o."ORDER_STATUS",o."STORE_ID",
    revenue
FROM orders o
LEFT JOIN 
    (SELECT 
        order_id,
        SUM(unit_price*quantity) AS revenue
    FROM order_items
    GROUP BY order_id) oi
ON o.order_id= oi.order_id
WHERE o.order_status='COMPLETE';


-- For each customer rank their orders from highest to lowest in terms of order total using Analytical Functions (use RANK())

SELECT 
    customer_id,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS sales_rank
FROM orders_view;



-- Using Analytical Functions find the difference between the order total for each 
-- order_id and the order_id with the maximum order total for that month/year

SELECT 
    order_id,
    TO_CHAR(order_datetime,'MM-YY') as month_year,
    revenue,
    MAX(revenue) OVER (PARTITION BY TO_CHAR(ORDER_DATETIME,'MM-YY') ORDER BY TO_CHAR(order_datetime,'MM-YY')) AS max_revenue,
    MAX(revenue) OVER (PARTITION BY TO_CHAR(ORDER_DATETIME,'MM-YY') ORDER BY TO_CHAR(order_datetime,'MM-YY')) - revenue AS difference_from_max
FROM orders_view


-- Using Analytical Functions find the order total for each order_id and subtract the 3 month rolling average 
-- order total (the average of the current month and the previous 2 months of orders). Your solution should only 
-- calculate the rolling average for months that are in the same year.


SELECT
order_id,
TO_CHAR(order_datetime,'MM-YY') as month_year,
TO_NUMBER(TO_CHAR(order_datetime,'YYMM')) AS month_year_code,
revenue,
ROUND(AVG(revenue) OVER(ORDER BY TO_NUMBER(TO_CHAR(order_datetime,'YYMM')) RANGE 2 PRECEDING),2) AS avg_3_months,
ROUND(revenue - AVG(revenue) OVER(ORDER BY TO_NUMBER(TO_CHAR(order_datetime,'YYMM')) RANGE 2 PRECEDING),2)  AS VAR
FROM
orders_view;

--  BONUS Problem


CREATE VIEW V_ORDER_YEAR_MONTH AS

SELECT 
    TO_CHAR(order_datetime, 'YYYY-MM') AS year_month,
    SUM(revenue) AS year_month_total
FROM orders_view
GROUP BY TO_CHAR(order_datetime,'YYYY-MM');

-- On the above view use Analytical Functions to create a running total column 
-- using the YEAR_MONTH_TOTAL field ordered  by the YEAR_MONTH field in ascending order


SELECT 
    year_month,
    year_month_total,
    SUM(year_month_total) OVER (ORDER BY year_month) AS running_total
FROM V_ORDER_YEAR_MONTH

-- OR

SELECT
YEAR_MONTH,
YEAR_MONTH_TOTAL,
SUM(YEAR_MONTH_TOTAL) OVER(ORDER BY YEAR_MONTH ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM V_ORDER_YEAR_MONTH;



