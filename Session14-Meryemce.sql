CREATE PROCEDURE sp_sampleproc1
AS
BEGIN
SELECT 'Hello World';
END
EXEC sp_sampleproc1;

----------------------------------------

drop procedure sp_sampleproc1;
;
create procedure sp_sampleproc1
AS
begin
select 'Hello World!'
end
;
alter procedure sp_sampleproc1
AS
begin
select 'Hello World 3 !'
end
;
EXECUTE sp_sampleproc1;
--------------------------------------------

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )
;

SELECT * FROM ORDER_TBL;

CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )
;

CREATE PROCEDURE sp_sum_order 
AS

BEGIN
	SELECT COUNT(*) AS TOTAL_ORDER
	FROM ORDER_TBL

END
;

EXECUTE sp_sum_order;


CREATE PROCEDURE sp_wantedday_order
	(
	@DAY DATE
	)
AS
BEGIN
	SELECT	COUNT(*) AS TOTAL_ORDER
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @DAY
END
;

EXECUTE sp_wantedday_order '2022-06-22' ;

DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT
SET @p1 = 5
SELECT @p1

;

DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT
SET @p1 = 5
SELECT *
from ORDER_TBL
where order_id = @p1
;

DECLARE
	@order_id INT,
	@customer_name nvarchar(100)
SET @order_id = 5
SELECT @customer_name = customer_name
from ORDER_TBL
where order_id = @order_id 
select @customer_name
;
CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END
;

SELECT dbo.fnc_uppertext('hello world');

-- Müşteri adını parametre olarak alıp o müşterinin alışverişlerini döndüren bir fonksiyon yazınız.
CREATE FUNCTION fnc_getordersbycustomer
( @CUSTOMER_NAME NVARCHAR (100)
)
RETURNS TABLE
AS 
	RETURN
		SELECT *
		FROM ORDER_TBL
		WHERE CUSTOMER_NAME = @CUSTOMER_NAME


SELECT * FROM dbo.fnc_getordersbycustomer('Owen')

--IF/ELSE--

-- Bir fonksiyon yaziniz. Bu fonksiyon aldığı rakamsal değeri çift ise Çift, tek ise Tek döndürsün. Eğer 0 ise Sıfır döndürsün.
DECLARE
		@input int,
		@modulus int
SET @input = 5   --buradaki sayiyi degistirip deneyebiliriz.

SELECT @modulus = @input % 2

IF @input = 0
	BEGIN
	print 'Sifir'
	END
ELSE IF @modulus = 0
	BEGIN
	print 'Cift'
	END
ELSE
	print 'Tek'

print @modulus


create FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE
		-- @input int,
		@modulus int,
		@return nvarchar(max)
	-- SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 set @return = 'Sıfır'
		END
	ELSE IF @modulus = 0
		BEGIN
		 set @return = 'Çift'
		END
	ELSE set @return = 'Tek'
	return @return
	
END
;

SELECT dbo.fnc_tekcift(100) A, dbo.fnc_tekcift(9) B, dbo.fnc_tekcift(0) C;

--WHILE--------
DECLARE
	@counter int,
	@total int
set @counter = 1
set @total = 50
while @counter < @total
	begin
		PRINT @counter
		set @counter = @counter + 1
	end
;


--Siparişleri, tahmini teslim tarihleri ve gerçekleşen teslim tarihlerini kıyaslayarak
--'Late','Early' veya 'On Time' olarak sınıflandırmak istiyorum.
--Eğer siparişin ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (gerçekleşen teslimat tarihi) küçükse
--Bu siparişi 'LATE' olarak etiketlemek,
--Eğer EST_DELIVERY_DATE>DELIVERY_DATE ise Bu siparişi 'EARLY' olarak etiketlemek,
--Eğer iki tarih birbirine eşitse de bu siparişi 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan siparişleri, sahip oldukları etiketlere göre farklı işlemlere tabi tutmak istiyorum.

--istenilen bir order' ın status' unu tanımlamak için bir scalar valued function oluşturacağız.
--çünkü girdimiz order_id, çıktımız ise bir string değer olan statu olmasını bekliyoruz.

create FUNCTION dbo.fnc_orderstatus
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare
		@result nvarchar(100)
	-- set @input = 1
	select	@result =
				case
					when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						then 'EARLY'
					when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						then 'LATE'
					when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						then 'ON TIME'
				else NULL end
	from	ORDER_TBL A, ORDER_DELIVERY B
	where	A.order_id = B.order_id AND
			A.order_id = @input
	;
	return @result
end
;
select	dbo.fnc_orderstatus(3)
;
select	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
from	ORDER_TBL
;