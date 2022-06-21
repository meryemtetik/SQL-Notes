--WEEKLY AGENDA_8--
--1) Report cumulative total turnover by months in each year in pivot table format.
WITH table1 AS(
SELECT YEAR(SO.order_date) years, MONTH(SO.order_date) ord_month,(OI.list_price*OI.quantity*(1-OI.discount)) turnover
     
FROM  
    sale.orders SO,sale.order_item OI
	WHERE SO.order_id=OI.order_id
	GROUP BY SO.order_date)
SELECT DISTINCT years,ord_month FROM table1
PIVOT  
(  
    SUM(turnover)  
FOR   
	turnover   
    IN ( table1.years, ord_month 
) AS pivot_table
; 
---------------------------------
SELECT *
FROM
	(
	SELECT	distinct YEAR (A.order_date) ord_year, MONTH(A.order_date) ord_month,
	SUM(quantity*list_price) OVER (PARTITION BY YEAR (A.order_date) ORDER BY YEAR (A.order_date), MONTH(A.order_date)) turnover
	FROM	sale.orders A, sale.order_item B
	WHERE	A.order_id = B.order_id
	) A
PIVOT
	(
	MAX(turnover)
	FOR ord_year
	IN ([2018], [2019],[2020])
	)
PIVOT_TA


---------------
--2) What percentage of customers purchasing a product have purchased the same product again?
WITH	table1
AS
		(
		SELECT	product_id,
				SUM(CASE WHEN counts >= 2 THEN 1 ELSE 0 END) AS cust_cnt,
				COUNT(customer_id) AS total_cust
		FROM	(
				SELECT DISTINCT	OI.product_id, SO.customer_id,
								COUNT(SO.customer_id) OVER (PARTITION BY OI.product_id, SO.customer_id) AS counts
				FROM	sale.orders SO, sale.order_item OI
				WHERE	SO.order_id = OI.order_id
				) as Table2
		GROUP BY product_id
		)
SELECT	product_id, CAST(1.0 * cust_cnt / total_cust AS NUMERIC(3,2)) perc
FROM	table1
---ALTERNATIVE-2
SELECT	soi.product_id,
		CAST(1.0*(COUNT(so.customer_id) - COUNT(DISTINCT so.customer_id))/COUNT(so.customer_id) AS DECIMAL(3,2)) per_of_cust_pur
FROM	sale.order_item soi, sale.orders so
		WHERE	soi.order_id = so.order_id		
GROUP BY soi.product_id;

--------------------------------------------------
/*From the following table of user IDs, actions, and dates, write a query to return the publication and
cancellation rate for each user.*/
CREATE TABLE WeeklyAgenda ([User_id] int, [Action] nvarchar (20), [Date] nvarchar(20)
					
) ;
--DROP TABLE IF EXISTS WeeklyAgenda;

INSERT INTO WeeklyAgenda ([User_id] , [Action] , [Date] )
VALUES (1,'Start','1-1-22'),
		(1,'Cancel','1-2-22'),
		(2,'Start','1-3-22'),
		(2,'Publish','1-4-22'),
		(3,'Start','1-5-22'),
		(3,'Cancel','1-6-22'),
		(1,'Start','1-7-22'),
		(1,'Publish','1-8-22')
		;
CREATE VIEW table3 AS
SELECT User_id, Strt,Publish, Cancel
FROM (SELECT User_id, 
		SUM(CASE WHEN Action='Start' THEN 1 ELSE 0 END) as Strt,
		SUM(CASE WHEN Action='Publish' THEN 1 ELSE 0 END) as Publish,
		SUM(CASE WHEN Action='Cancel' THEN 1 ELSE 0 END) as Cancel
FROM WeeklyAgenda
GROUP BY [User_id]) AS table2;

SELECT User_id, 
	CAST(1.0*Publish/Strt AS DECIMAL (2,1)) AS Publish_rate,
	CAST(1.0*Cancel/Strt AS DECIMAL (2,1)) AS Cancel_rate
FROM table3

