SELECT TRIM(' CHARACTER'),

SELECT ' CHARACTER' ;
SELECT GETDATE();

SELECT TRIM(' CHARACTER ');

SELECT TRIM( ' CHAR ACTER ');

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA');
SELECT TRIM('X' FROM 'ABCXXDE');
SELECT TRIM('X' FROM 'xxABCXXDEXX');

SELECT TRIM('#! ' FROM ' ##MATRIX#! ');

SELECT LTRIM ('     CHARACTER ');

SELECT RTRIM ('     CHARACTER ');

SELECT REPLACE('CHARACTER STRING', ' ', '/');

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER');

SELECT STR(5454);  -- string fonksiyonu her seferde bize 10 karakter döndürür.

SELECT STR (2135454654);

SELECT STR (133215.654645, 11, 3);  --11 karakterli bir text ve son 3 karakteri float.

SELECT len(STR (5454));

SELECT CAST (12345 AS CHAR);

SELECT CAST (123.65 AS INT);


SELECT CONVERT(int, 30.60);

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

SELECT ISNULL('', 'ABC');

SELECT ISNULL(NULL, 'ABC');

select ISNUMERIC(123)

select ISNUMERIC('ABC')

SELECT ISNUMERIC(123)
SELECT ISNUMERIC(STR(123))



SELECT * FROM [product].[category] RIGHT JOIN [product].[product]
ON [product].[category].[category_id] = [product].[product].[category_id]
ORDER BY [product].[category].[category_id],[product].[product].[product_id];

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product AS A 
INNER JOIN product.category AS B
ON A.category_id = B.category_id

SELECT staff.first_name, staff.last_name, store.store_name from sale.staff
join sale.store on store.store_id = staff.store_id;


SELECT A.product_id, A.product_name,B.order_id  from product.product A 
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id
WHERE B.order_id is NULL;

SELECT P.product_id, P.product_name, S.store_id, S.product_id, S.quantity
FROM product.product AS P
LEFT JOIN product.stock AS S
ON P.product_id=S.product_id
WHERE P.product_id>310;

-- right join
select	B.product_id, B.product_name, A.*
from	product.stock A
right join product.product B
	ON	A.product_id = B.product_id
where	B.product_id > 310

-- FULL OUTER JOIN
select	top 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
from	product.product A
FULL OUTER JOIN product.stock B
ON		A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C
ON		A.product_id = C.product_id
order by B.store_id


