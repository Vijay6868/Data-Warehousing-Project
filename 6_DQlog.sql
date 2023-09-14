CREATE TABLE DQLog
(
LogID int PRIMARY KEY IDENTITY,
RowID varbinary(32), 
DBName nchar(20),
TableName nchar(40),
RuleNo smallint,
Action nchar(6) CHECK (action IN ('allow','fix','reject')) -- Action can be ONLY 'allow','fix','reject'
);
-- Rule No.1

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','Product',1,'reject'
--select * 
FROM sales_AU_NZ.dbo.Product
WHERE buyPrice=0 or buyPrice is null;


INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','Product',1,'fix'
--select * 
FROM sales_AU_NZ.dbo.Product
WHERE buyPrice<0 ;


-- Rule No. 2
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','orderDetail',2,'reject'
--SELECT *
FROM sales_AU_NZ.dbo.orderdetail
WHERE priceEach = 0 or priceEach is null;

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','orderDetail',2,'fix'
--SELECT *
FROM sales_AU_NZ.dbo.orderdetail
WHERE priceEach<0;

-- Rule No.3
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','orderDetail',3,'reject'
--SELECT *
FROM sales_AU_NZ.dbo.orderdetail
WHERE quantityOrdered = 0 or quantityOrdered is null;

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','orderDetail',3,'fix'
--SELECT *
FROM sales_AU_NZ.dbo.orderdetail
WHERE quantityOrdered < 0;

--Rule No. 4
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','Product',4,'reject'
--select * 
FROM sales_AU_NZ.dbo.Product
WHERE MSRP < buyPrice

--Rule no.5

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'Customer', 5, 'fix'
--select *
FROM sales_AU_NZ.dbo.customer
WHERE Country in ('Australia', 'australia', 'New Zealand','new zealand');

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_AU_NZ', 'office', 5, 'fix'
--select *
FROM sales_AU_NZ.dbo.office
WHERE Country in ('Australia', 'australia', 'New Zealand','new zealand');
--Rule no. 6
INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','orderDetails',6,'reject'
--select * 
FROM sales_AU_NZ.dbo.Product
WHERE [productCode] is null;

--Rule no.7

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','customer',7,'reject'
--select * 
FROM sales_AU_NZ.dbo.customer
WHERE (customerNumber is null) and (addressLine1 is null or addressLine2 is null or city is null);

SELECT * from DQLog




--########## dqlog for salemodels##############################################################

use salemodels 


SELECT * from dw_salemodels.dbo.DQLog;
-- Rule No.1

INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.Product',1,'reject'
--select * 
FROM salemodels.product
WHERE buyPrice=0 or buyPrice is null;


INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.Product',1,'fix'
--select * 
FROM salemodels.product
WHERE buyPrice<0;


-- Rule No. 2
INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.orderdetails',2,'reject'
--select * 
FROM salemodels.orderdetails
WHERE productCode is null or productCode= 0;


INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.orderDetails',2,'fix'
--select * 
FROM salemodels.orderdetails
WHERE priceEach<0;

-- Rule No.3
INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.orderdetails',3,'reject'
--select * 
FROM salemodels.orderdetails
WHERE quantityOrdered = 0 or quantityOrdered is null;;

INSERT INTO dw_salemodels.dbo.DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salesmodels.orderDetails',3,'fix'
--SELECT *
FROM salemodels.orderdetails
WHERE quantityOrdered < 0;

--Rule No. 4
INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.Product',4,'reject'
--select * 
FROM salemodels.product
WHERE MSRP<buyPrice;


--Rule No. 5
INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.customers',5,'fix'

FROM salemodels.Customers
WHERE Country in ('France', 'Norway', 'Poland','Germany','Spain','Sweden','Denmark','Singapore','Portugal',
					'Japan','Irealnd','Canada','Hong Kong','Switzerland','Italy','Finland','Belgium','Austria',
					'germany','Philippines','Russia','Israel','Netherlands','South Africa','UNITED STATES','US','Norway');


INSERT INTO dw_salemodels.dbo.dqlog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salemodels.offices',5,'fix'
--select*
FROM salemodels.offices
WHERE Country in ('France', 'Norway', 'Poland','Germany','Spain','Sweden','Denmark','Singapore','Portugal',
					'Japan','Irealnd','Canada','Hong Kong','Switzerland','Italy','Finland','Belgium','Austria',
					'germany','Philippines','Russia','Israel','Netherlands','South Africa','UNITED STATES','US','Norway');

--Rule no. 6

INSERT INTO dw_salemodels.dbo.DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salesmodels.orderDetails',6,'reject'
FROM salemodels.orderdetails
WHERE productCode is null ;

--Rule no. 7

INSERT INTO dw_salemodels.dbo.DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salesmodels.customers',7,'reject'
SELECT *
FROM salemodels.customers
WHERE (customerNumber is null) and (addressLine1 is null or addressLine2 is null or city is null);


-- #######################################################################################################


-- Addition to DQ Log

-- Rule no. 8 # requiredDate, shippedDate checking in Orders, 

--if orderDate greater than requiredDate, 
--Fix  if requiredDate null replace orderDate+7


-- OLTP salemodels
use salemodels

INSERT INTO dw_salemodels.dbo.DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salesmodels.orders',8,'fix'
--SELECT *
FROM salemodels.orders
WHERE  requiredDate is null and salemodels.orders.orderDate>salemodels.orders.requiredDate;

---Fix 

update salemodels.orders
set requiredDate = DATEADD(DAY,7,salemodels.orders.orderDate)
where requiredDate is null and salemodels.orders.orderDate>salemodels.orders.requiredDate;

--OLTP sales_AU_NZ

use dw_salemodels

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','productPrder',8,'fix'
--SELECT *
FROM sales_AU_NZ.dbo.productorder
WHERE requiredDate is null and orderDate>requiredDate;

-- fix
use sales_AU_NZ
update productorder
set requiredDate = DATEADD(DAY,7,productorder.orderDate)
where requiredDate is null and orderDate>requiredDate;

--#######################################################

-- Rule 8 if orderDate greater than shippedDate
--Fix  if shippedDate null replace orderDate+2, if status is ='Shipped'


use salemodels

INSERT INTO dw_salemodels.dbo.DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'salemodels','salesmodels.orders',8,'fix'
--SELECT *
FROM salemodels.orders
WHERE  requiredDate is null and salemodels.orders.orderDate>salemodels.orders.requiredDate;

---Fix 

update salemodels.orders
set requiredDate = DATEADD(DAY,7,salemodels.orders.orderDate)
where requiredDate is null and salemodels.orders.orderDate>salemodels.orders.requiredDate;

--OLTP sales_AU_NZ

use dw_salemodels

INSERT INTO DQLog(RowID, DBName, TableName, RuleNo, Action)
SELECT %%physloc%%, 'sales_au_nz','productPrder',8,'fix'
--SELECT *
FROM sales_AU_NZ.dbo.productorder
WHERE shippedDate is null and status = 'Shipped' and orderDate>shippedDate;

-- fix
use sales_AU_NZ
update productorder
set shippedDate = DATEADD(DAY,2,productorder.orderDate)
where shippedDate is null and status = 'Shipped' and orderDate>shippedDate;



