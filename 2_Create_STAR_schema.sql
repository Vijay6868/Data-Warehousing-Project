use dw_salemodels

-- creating dimproducts table


CREATE TABLE dimProducts(
ProductKey		int			IDENTITY(1,1)		PRIMARY KEY,
ProductCode		varchar(15)								NOT NULL,
ProductName		varchar(70)					NOT NULL,
ProductScale    varchar(10)                 NOT NULL,
MSRP			decimal(10,2)				NOT NULL,
BuyPrice		decimal(10,2)				Not	NULL,
QuantityInStock	smallInt					Not NULL,
ProductVendor   varchar(50)                 Not Null,
ProductDescription		text				    NOT NULL,
ProductLine   	varchar(50)					Not NULL,
textDescription  varchar(4000)					Null,
htmlDescription text							Null,
Pimage			image							NULL

);

select*from dimProducts

--creating table dimcustomers



CREATE TABLE dimCustomers(
CustomerKey		int			IDENTITY(1,1)		PRIMARY KEY,
  customerNumber int NOT NULL,
  customerName varchar(50) NOT NULL,
  contactLastName varchar(50) NOT NULL,
  contactFirstName varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  city varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  postalCode varchar(15) DEFAULT NULL,
  country varchar(50) NOT NULL,
  salesRepEmployeeNumber int DEFAULT NULL,
  creditLimit decimal(10,2) DEFAULT NULL,
);

-- creating table dimEmployee

CREATE TABLE dimEmployee (
EmployeeKey		int			IDENTITY(1,1)		PRIMARY KEY,
  employeeNumber int NOT NULL,
  lastName varchar(50) NOT NULL,
  firstName varchar(50) NOT NULL,
  extension varchar(10) NOT NULL,
  email varchar(100) NOT NULL, 
  reportsTo int DEFAULT NULL,
  jobTitle varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
  phone varchar(50) NOT NULL,  
  addressLine1 varchar(50) NOT NULL,
  addressLine2 varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  country varchar(50) NOT NULL,
  postalCode varchar(15) NOT NULL,
  territory varchar(10) NOT NULL,
  );

 select*from dimEmployee

  -- create table dimPayment

  create table dimPayment(
  PaymentKey int			IDENTITY(1,1)		PRIMARY KEY,
  customerNumber int NOT NULL,
  checkNumber varchar(50) NOT NULL,
  paymentDate date NULL, --- payment date changed to Null
  amount decimal(10,2) NOT NULL,
  );

  CREATE TABLE Numbers_Small (Number INT);
INSERT INTO Numbers_Small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

CREATE TABLE Numbers_Big (Number_Big BIGINT);
INSERT INTO Numbers_Big ( Number_Big )
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number as number_big
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones;

CREATE TABLE dimTime(
[TimeKey] [int] NOT NULL PRIMARY KEY,
[Date] [datetime] NULL,
[Day] [char](10) NULL,
[DayOfWeek] [smallint] NULL,
[DayOfMonth] [smallint] NULL,
[DayOfYear] [smallint] NULL,
[WeekOfYear] [smallint] NULL,
[Month] [char](10) NULL,
[MonthOfYear] [smallint] NULL,
[QuarterOfYear] [smallint] NULL,
[Year] [int] NULL
);
INSERT INTO dimTime(TimeKey, Date) values(-1,'9999-12-31'); -- Create dummy for a "null" date/time
INSERT INTO dimTime (TimeKey, Date)
SELECT number_big, DATEADD(day, number_big,  '2013-01-01') as Date
FROM numbers_big
WHERE DATEADD(day, number_big,  '2013-01-01') BETWEEN '2013-01-01' AND '2016-12-31'
ORDER BY number_big;

/*
INSERT INTO dimTime (TimeKey, Date)
SELECT CONVERT(INT, CONVERT(CHAR(10),DATEADD(day, number_big,  '1996-01-01'), 112)) as DateKey,
CONVERT(DATE,DATEADD(day, number_big,  '1996-01-01')) as Date
FROM numbers_big
WHERE DATEADD(day, number_big,  '1996-01-01') BETWEEN '1996-01-01' AND '1998-12-31'
ORDER BY 1;
*/

UPDATE dimTime
SET Day = DATENAME(DW, Date),
DayOfWeek = DATEPART(WEEKDAY, Date),
DayOfMonth = DAY(Date),
DayOfYear = DATEPART(DY,Date),
WeekOfYear = DATEPART(WK,Date),
Month = DATENAME(MONTH,Date),
MonthOfYear = MONTH(Date),
QuarterOfYear = DATEPART(Q, Date),
Year = YEAR(Date);
drop table Numbers_Small;
drop table Numbers_Big;

Go


  
--select*from dimTime
--drop table factOrders
CREATE TABLE factOrders(
ProductKey		int			FOREIGN KEY REFERENCES dimProducts(ProductKey),
CustomerKey		int			FOREIGN KEY REFERENCES dimCustomers(CustomerKey),
OrderDateKey	int			FOREIGN KEY REFERENCES dimTime(TimeKey),
RequiredDateKey int         FOREIGN KEY REFERENCES dimTime(TimeKey),
shippedDate     int         FOREIGN KEY REFERENCES dimTime(TimeKey),
EmployeeKey 	int			FOREIGN KEY REFERENCES dimEmployee(EmployeeKey),
PaymentKey		int			FOREIGN KEY REFERENCES dimPayment(PaymentKey),
OrderNumber		int			        NOT NULL,
priceEach		decimal(10,2)		NOT NULL,
QtyOrdered		int	                NOT NULL,

TotalProfit         decimal(10,2)  not null,
TotalPossibleProfit decimal(10,2)  not null,
TotalPrice		    decimal(10,2)  NOT NULL
PRIMARY KEY(CustomerKey, ProductKey, OrderDateKey,EmployeeKey,PaymentKey)
);

--select * from dimCustomers