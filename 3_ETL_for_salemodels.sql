use salemodels
Merge Into dw_salemodels.dbo.dimProducts dp -- populate dimproducts

using(

  select ProductCode,ProductName,Productscale,MSRP,BuyPrice,
		   QuantityInStock,ProductVendor,ProductDescription,
		   l1.productLine,image,htmlDescription,textDescription
	from   salemodels.product p1
	inner join salemodels.productlines l1
	on p1.productline = l1.productline
	) pl on (dp.ProductCode = pl.ProductCode)
	when matched then
		update set dp.productName = pl.productName
	when not matched then
		insert(ProductCode,ProductName,Productscale,MSRP,BuyPrice,
		   QuantityInStock,ProductVendor,ProductDescription,
		   productLine,Pimage,htmlDescription,textDescription)
		values(pl.ProductCode,pl.ProductName,pl.Productscale,pl.MSRP,pl.BuyPrice,
		   pl.QuantityInStock,pl.ProductVendor,pl.ProductDescription,
		   pl.productLine,pl.image,pl.htmlDescription,pl.textDescription);



-- populating dimcustomers


merge into dw_salemodels.dbo.dimCustomers dc

using(
		select * from salemodels.customers ) c on (dc.customerNumber= c.customerNumber) 
		when matched then
		update set dc.CustomerName= c.customerName
		when not matched then

		insert(customerNumber, customerName, contactLastName, contactFirstName,
		phone,addressLine1,addressLine2,city,state,postalCode,country,salesRepEmployeeNumber,creditLimit)
		values(c.customerNumber, c.customerName, c.contactLastName, c.contactFirstName,
		c.phone,c.addressLine1,c.addressLine2,c.city,c.state,c.postalCode,c.country,c.salesRepEmployeeNumber,c.creditLimit);

		


merge into dw_salemodels.dbo.dimPayment pay

using(
		select * from salemodels.payments ) pm on (pay.customerNumber = pm.customerNumber)
		when matched then 
						update set pay.amount=pm.amount
		when not matched then
		insert(customerNumber,checkNumber,paymentDate,amount)
		values(pm.customerNumber,pm.checkNumber,pm.paymentDate,pm.amount);

		
		
		   
merge into dw_salemodels.dbo.dimEmployee de

using( select employeeNumber, lastname, firstname,extension,email,reportsTo,jobTitle,city,phone,
		addressLine1, addressLine2,state,country,postalcode,territory from salemodels.Employees e1
		inner join salemodels.offices of1
		on e1.officeCode = of1.officeCode) eo on (de.employeeNumber = eo.employeeNumber)
		when matched then
							update set de.email = eo.email
		when not matched then
		insert(employeeNumber, lastname, firstname,extension,email,reportsTo,jobTitle,city,phone,
		addressLine1, addressLine2,state,country,postalcode,territory)
		values(eo.employeeNumber, eo.lastname, eo.firstname,eo.extension,eo.email,eo.reportsTo,eo.jobTitle,
		eo.city,eo.phone,eo.addressLine1, eo.addressLine2,eo.state,eo.country,eo.postalcode,eo.territory);
		

		select*from salemodels.orderdetails
		
		where quantityOrdered= null
		drop table salemodels.orderdetails

merge into dw_salemodels.dbo.factOrders fo
using 
     ( select productkey, customerkey,employeekey,paymentkey, dt1.timekey as [orderdatekey], dt2.timekey as [requiredDateKey],
				dt3.timekey as [shippedDate],od.quantityOrdered as [qtyOrdered], o.orderNumber as [orderNumber], od.priceEach as [priceEach],
				od.quantityordered*od.priceEach as [Totalprice],(od.quantityOrdered*(od.priceEach-p.buyPrice)) as [TotalProfit],
				(od.quantityOrdered*(p.MSRP-p.buyPrice))as [TotalPossibleProfit]
		from salemodels.orderDetails od, salemodels.product p,
		salemodels.orders o, dw_salemodels.dbo.dimcustomers dc, dw_salemodels.dbo.dimproducts dp, 
		dw_salemodels.dbo.dimEmployee de,
		dw_salemodels.dbo.dimPayment dpay,dw_salemodels.dbo.dimtime dt1, 
		dw_salemodels.dbo.dimtime dt2, dw_salemodels.dbo.dimtime dt3
		where od.ordernumber = o.orderNumber and p.productCode = od.productCode
				and o.customerNumber = dc.customerNumber
				and dp.productCode= od.productCode
				and dpay.customerNumber = o.customerNumber
				and de.EmployeeNumber = dc.salesRepEmployeeNumber

				and dt1.date= o.orderdate
				and dt2.date= o.requiredDate
				and dt3.date= o.shippedDate
				
				                                               
				) 
				po on(po.productkey = fo.productKey and po.orderdatekey = fo.orderDateKey )
		when matched then update set fo.orderNumber=po.orderNumber

		when not matched then

		insert(productKey,customerkey,orderDateKey,requiredDateKey,employeeKey,paymentkey,ordernumber
				,priceEach, qtyOrdered, totalProfit, totalPossibleProfit,totalPrice,shippedDate)
		values(po.productKey,po.customerkey,po.orderDateKey,po.requiredDateKey,po.employeeKey,po.paymentkey,po.ordernumber
				,po.priceEach, po.qtyOrdered, po.totalProfit, po.totalPossibleProfit,po.totalPrice,po.shippedDate);

			
			

