/*
Discount Effects

Generate a report including product IDs and discount effects on whether the increase in the discount rate positively
impacts the number of orders for the products.
In this assignment, you are expected to generate a solution using SQL with a logical approach. 

Turkish: İndirim oranındaki artışın ürünler için sipariş sayısını olumlu etkileyip etkilemediğine dair
ürün kimliklerini ve indirim etkilerini içeren bir rapor oluşturun.
Bu ödevde mantıksal bir yaklaşımla SQL kullanarak bir çözüm üretmeniz beklenmektedir.
*/
-----product_id ye göre gruplandirip pozitifligine bakacagiz.
USE SampleRetail;
SELECT * 
FROM sale.orders,sale.order_item

---------------------
select  quantity, discount, sum (quantity) toplam
from  sale.order_item
where product_id = 2
group by  quantity, discount
order by discount
-------------------------
/*select
   min(quantity),
   percentile_cont(0.25) within group (order by discount asc) over(PARTITION BY quantity) as p25,
   percentile_cont(0.50) within group (order by discount asc) over(PARTITION BY quantity) as median,
   avg(quantity) as mean,
   percentile_cont(0.75) within group (order by discount asc) over(PARTITION BY quantity) as p75,
   max(quantity),
   STDEV(quantity)
from sale.order_item
where product_id=2
group by  quantity, discount
order by discount;

with stat as (
   select distinct
     percentile_cont(0.25) within group (order by discount asc) over(PARTITION BY product_id) as p25,
     percentile_cont(0.50) within group (order by discount asc) over(PARTITION BY product_id) as median,
     avg(quantity) over(partition by order_id order by discount) as mean,
     percentile_cont(0.75) within group (order by discount asc) over(PARTITION BY product_id) as p75,
     (stdev(quantity) over(partition by product_id order by discount))*1.0 std 
  from sale.order_item

)
select
  (3 * (mean - median))/std as pearson_coeff
from stat
where std is not null and std <>0;
*/--Hocam yorumdaki kisimla cözmeyi denedim ama sonuca ulasamadim.--
---------------------------
--------------------------
SELECT DISTINCT product_id, discount, 
SUM(quantity) OVER(PARTITION BY product_id,discount) AS sale_quantity 
FROM sale.order_item 
ORDER BY product_id,discount;

--------------------------

CREATE VIEW next_table AS
		(SELECT product_id, discount,	
			LEAD(discount) OVER (PARTITION BY product_id ORDER BY discount ) AS next_discount,
			SUM(quantity) AS sale_quantity,		
			LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount ) AS next_sale_quantity		
		FROM sale.order_item 
		GROUP BY product_id, discount);
-------------------------------------
SELECT product_id,
		(next_sale_quantity-sale_quantity)/(next_discount-discount) AS rate		
FROM next_table
--------------RESULT-----------------------

WITH  discount_effect AS 
	(SELECT product_id,		
		SUM((next_sale_quantity-sale_quantity)/(next_discount-discount)) as rate_sum		
	FROM next_table GROUP BY product_id)
SELECT product_id,	
	CASE WHEN rate_sum>0 THEN 'Positive'		
		  WHEN rate_sum=0 THEN 'Neutral'		
		  WHEN rate_sum<0 THEN 'Negative' end  as Discount_Effect
FROM discount_effect;


