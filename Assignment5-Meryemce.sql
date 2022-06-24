---ASSIGNMENT 5--------
--Create a scalar-valued function that returns the factorial of a number you gave it.

CREATE FUNCTION dbo.Factorial(@iNum int)
RETURNS INT
AS
BEGIN
DECLARE @i int

    IF @iNum <= 1
        SET @i = 1
    ELSE
        SET @i = @iNum * dbo.Factorial(@iNum - 1)
RETURN (@i)
END;
--DROP FUNCTION IF EXISTS dbo.Factorial
SELECT dbo.Factorial(5) AS Factorial;

SELECT dbo.Factorial(6) AS Factorial;

SELECT dbo.Factorial(8) AS Factorial;

SELECT dbo.Factorial(0) AS Factorial;
SELECT dbo.Factorial(-2) AS Factorial;