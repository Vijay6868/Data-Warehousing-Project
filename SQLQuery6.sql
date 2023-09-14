use sales_AU_NZ

select * from product

select * from orderdetail
where orderNumber = 510120
order by orderLineNumber

use DW_northwind
MERGE INTO   	factOrders fo 
USING  	 	 	 	 
( 
 	SELECT 	    ProductKey, CustomerKey, 
  	 	 	    dt1.TimeKey as [OrderDatekey], 	 	-- from dimTime 
		        dt2.TimeKey as [RequiredDatekey],  	-- from dimTime   	      
                  Quantity as [Qty], 
      o.OrderID as [OrderID],Discount,od.UnitPrice as [UnitPrice], 
      od.UnitPrice*od.Quantity as [TotalPrice] -- Calculation! 
  		FROM  	    northwind1.dbo.Orders o, northwind1.dbo.[Order Details] od, dimCustomers dc, dimProducts dp, dimTime dt1, dimTime dt2
         WHERE od.OrderID=o.OrderID
  	        AND o.CustomerID=dc.CustomerID  
         AND dp.ProductID=od.ProductID   
              AND dt1.Date=o.OrderDate
      AND dt2.Date=o.RequiredDate  -- Two dimTime tables!! 
  	 
) o ON (o.ProductKey = fo.ProductKey 	-- Assume All Keys are unique  	AND o.CustomerKey=fo.CustomerKey  
	 	 		AND o.OrderDateKey=fo.OrderDateKey)  	 
  	 	 	 	-- if they matched, do nothing  	UPDATE SET fo.OrderID = o.OrderID -- Dummy update 
	WHEN NOT MATCHED THEN  	 	 	-- Otherwise, insert a new row 	 
INSERT(ProductKey, CustomerKey, OrderDateKey, RequiredDateKey, 
OrderID, UnitPrice, Qty, Discount, TotalPrice)  VALUES(o.ProductKey,o.CustomerKey,o.OrderDateKey,o.RequiredDateKey,o.
OrderID,o.UnitPrice,o.Qty,o.Discount, o.TotalPrice); 

select * from factOrders
where OrderID = 11006

use salemodels
select * from salemodels.orderdetails
where quantityOrdered = null;