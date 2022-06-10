USE SampleRetail;
-- Charlotte şehrindeki müşteriler ile Aurora şehrindeki müşterilerin soyisimlerini listeleyin
SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';

--Çalışanların ve müşterilerin eposta adreslerinin unique olacak şekilde listeleyiniz.
SELECT email
FROM sale.staff
UNION
SELECT email
FROM sale.customer;

--
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas';


-- Write a query that returns brands that have products for both 2018 and 2019.
SELECT  A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year=2018
INTERSECT
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year=2019;

----
SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2018
INTERSECT
SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2019
INTERSECT
SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2020;
-------
SELECT * FROM
(SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2018
INTERSECT
SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2019
INTERSECT
SELECT C.first_name, C.last_name
FROM sale.customer C, sale.orders O
WHERE C.customer_id=O.customer_id AND YEAR(O.order_date) = 2020
) C,sale.orders O
WHERE	C.customer_id = O.customer_id and Year(O.order_date) in (2018, 2019, 2020)
order by C.customer_id, O.order_date;
-------
select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date;
-------
SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';
-------- Write a query that returns brands that have a 2018 model product but not a 2019 model product.
SELECT  A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year=2018
EXCEPT
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE a.brand_id=b.brand_id AND A.model_year=2019;

--Sadece 2019 yılında sipariş verilen diğer yıllarda sipariş verilmeyen ürünleri getiriniz.

select	C.product_id, D.product_name
from	
	(
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id
	except
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id
	) C, product.product D
where	C.product_id = D.product_id
;

-----------
-- 5 marka
select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A;

------PIVOT TABLE----
SELECT *
FROM
			(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;
-------
select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id
	except
	select	B.product_id, C.product_name
	from	sale.orders A, sale.order_item B, product.product C
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id AND
			B.product_id = C.product_id
21:08 Uhr
SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1;
-----------CASE
-- CASE
select	order_id, order_status,
		case order_status
			when 1 then 'Pending'
			when 2 then 'Processing'
			when 3 then 'Rejected'
			when 4 then 'Completed'
		end order_status_desc
from	sale.orders

------------
SELECT first_name,last_name,store_id,
    CASE store_id
	    when 1 then 'Davi techno Retail'
		when 2 then 'The BFLO Store'
		when 3 then 'Burkes Outlet'
	end as Store_name
FROM sale.staff
----------
--Müşterilerin e-mail adreslerindeki servis sağlayıcılarını yeni bir sütun oluşturarak belirtiniz.
SELECT first_name,last_name, email,
    CASE 
	    WHEN email like '%hotmail%' THEN 'Hotmail'
		WHEN email like '%gmail%' THEN 'Gmail'
		WHEN email like '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer
---------
-- Aynı siparişte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariş veren müşterileri bulunuz.
select	c.order_id, count(distinct a.category_id) uniqueCategory
from	product.category A, product.product B, sale.order_item C
where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
		A.category_id = B.category_id AND
		B.product_id = C.product_id
group by C.order_id
having	count(distinct a.category_id) = 3
;
-------
-- Aynı siparişte hem mp4 player, hem Computer Accessories hem de Speakers kategorilerinde ürün sipariş veren müşterileri bulunuz.
select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;




