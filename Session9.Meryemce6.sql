----------GROUP BY-----------------------
SELECT product_id, SUM(quantity) AS total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id;

------------WINDOW FUNCTIONS-----------------
SELECT *, SUM(quantity) OVER(PARTITION bY product_id) sumWF
FROM product.stock
ORDER BY product_id;

-----------------------------------------------
SELECT  product_id, SUM(quantity) OVER(PARTITION bY product_id) sumWF
FROM product.stock
ORDER BY product_id;

SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION bY product_id) sumWF
FROM product.stock
ORDER BY product_id;
---------------------------------------------
-- Markalara göre ortalama ürün fiyatlarını hem Group By hem de Window Functions ile hesaplayınız.
SELECT DISTINCT brand_id, AVG(list_price) OVER(PARTITION bY brand_id) avg_price
FROM product.product 
ORDER BY brand_id;

SELECT brand_id, AVG(list_price) AS avg_price
FROM product.product
GROUP BY brand_id;
--------------------------------------------
select	*,
		count(*) over(partition by brand_id) CountOfProduct,
		max(list_price) over(partition by brand_id) MaxListPrice
from	product.product
order by brand_id, product_id
;

------------------------------------------------
select	*,
		count(*) over(partition by brand_id) CountOfProduct,
		count(*) over(partition by category_id) CountOfProductInCategory
from	product.product
order by brand_id, product_id
;
--Window function ile oluşturduğunuz kolonlar birbirinden bağımsız hesaplanır.
--Dolayısıyla aynı select bloğu içinde farklı partitionlar tanımlayarak yeni kolonlar oluşturabilirsiniz.

select	product_id, brand_id, category_id, model_year
from	product.product
order by brand_id, category_id, model_year;
-----------------
select	product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by brand_id, category_id, model_year;
----------------------------------------------
-- Window Frames

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satırda işlem yapılacak olan frame in büyüklüğünü (satır sayısını) tespit edip window frame in nasıl oluştuğunu aşağıdaki sorgu sonucuna göre konuşalım.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

;

-----------------------------------------------
-- Cheapest product price in each category.
-- Herbir kategorideki en ucuz ürünün fiyatı.
SELECT DISTINCT category_id, MIN(list_price) OVER(PARTITION BY category_id) cheapest_by_cat
FROM product.product
;

-- How many different product in the product table?
-- Product tablosunda toplam kaç faklı product bulunduğu
SELECT DISTINCT COUNT(product_id) OVER() num_of_product
FROM product.product

-- How many different product in the order_item table?
-- Order_item tablosunda kaç farklı ürün bulunmaktadır?
SELECT COUNT(*) num_of_product
FROM (SELECT DISTINCT product_id,COUNT(*) OVER(PARTITION BY product_id) num_of_product
FROM sale.order_item) S;


--hocanin cözümü:
select	count(distinct product_id) UniqueProduct      --dogru olan...
from	sale.order_item
;
select	count(distinct product_id) over() UniqueProduct      --hata veriyor.
from	sale.order_item
;


----/////
-- Write a query that returns how many different products are in each order?
-- Her siparişte kaç farklı ürün olduğunu döndüren bir sorgu yazın?

select	order_id,count(distinct product_id) UniqueProduct,
        sum(quantity) TotalProduct
from	sale.order_item
GROUP BY order_id;


select distinct [order_id]
	,sum(quantity) over(partition by [order_id]) count_of_product
from [sale].[order_item];
 

----------------------------------------
-- How many different product are in each brand in each category?
-- Herbir kategorideki herbir markada kaç farklı ürünün bulunduğu
SELECT DISTINCT category_id,brand_id,COUNT(*) OVER(PARTITION BY category_id,brand_id) num_of_prod	
FROM product.product
;

select	A.*, B.brand_name
from	(
		select	distinct category_id, brand_id,
				count(*) over(partition by brand_id, category_id) CountOfProduct
		from	product.product
		) A, product.brand B
where	A.brand_id = B.brand_id;
--------------------------------------
select	distinct category_id, A.brand_id,
		count(*) over(partition by A.brand_id, A.category_id) CountOfProduct,
		B.brand_name
from	product.product A, product.brand B
where	A.brand_id = B.brand_id
;



