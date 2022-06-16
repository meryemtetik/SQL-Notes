--cnt of product by each category and brand
SELECT brand_id,category_id, COUNT(product_id) CNT_PROD
FROM product.product
GROUP BY brand_id, category_id;


SELECT DISTINCT brand_id,category_id,
       COUNT(product_id) OVER(PARTITION BY brand_id, category_id) CNT_PROD
FROM product.product;

----Analytic Navigation Functions------------
-----FIRST VALUE-------
--Wright a query that returns most stoced product in each store.
SELECT DISTINCT store_id,
	   FIRST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod 
FROM product.stock;
-------------------------
select distinct store_id, max(quantity) over (partition by store_id)
from product.stock;     --burada yalnizca 30 degerini döndürüyor.

--Write a query that returns customers and their most valuable order with total amount of it.
SELECT B.customer_id
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id;


SELECT B.customer_id, B.order_id, SUM(quantity*list_price*(1-discount)) net_price
FROM sale.order_item A, sale.orders B
WHERE A.order_id=B.order_id
GROUP BY B.customer_id,B.order_id
ORDER BY 1,2 DESC;


SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC;
WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT	DISTINCT customer_id,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MV_ORDER,
		FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MVORDER_NET_PRICE
FROM	T1;

--Write a query that returns first order date by month.
SELECT DISTINCT YEAR(order_date) ord_year,
	            MONTH(order_date) ord_month,FIRST_VALUE(order_date)
				     OVER(PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date ASC) first_order_date
FROM sale.orders;

--------LAST VALUE---------
--Wright a query that returns most stoced product in each store.
SELECT DISTINCT store_id,
	   LAST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity ASC,product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod 
FROM product.stock;
--------
SELECT DISTINCT store_id,
	   LAST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity ASC,product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod 
FROM product.stock;
--------LAG() AND LEAD() Functions--------
--Write a query that returns the order date of the one previous sale of each staff(use de LAG function).
SELECT O.order_id,S.staff_id,S.first_name,S.last_name,O.order_date ,
       LAG(order_date) OVER(PARTITION BY S.staff_id ORDER BY order_date) previous_order_date
FROM sale.staff S,sale.orders O
WHERE O.staff_id=S.staff_id;






