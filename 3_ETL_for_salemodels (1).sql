Merge Into dimProducts dp -- populate dimproducts

using(

    select ProductCode,ProductName,Productscale,MSRP,BuyPrice,
		   QuantityInStock,ProductVendor,ProductDescription,
		   l1.productLine,image,htmlDescription,textDescription
	from   salemodels.dbo.[salemodels.Products] p1
	inner join salemodels.dbo.[salemodels.ProductLines] l1
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
		   pl.productLine,pl.Pimage,pl.htmlDescription,pl.textDescription);

		   select * from dimProducts;

delete  from dimProducts;


-- populating dimcustomers


merge into dimCustomers dc

using(
		select * from sales_au_nz.dbo.customer  ) c on (dc.customerNumber= c.customerNumber) 
		when matched then
		update set dc.CustomerName= c.customerName
		when not matched then

		insert(customerNumber, customerName, contactLastName, contactFirstName,
		phone,addressLine1,addressLine2,city,state,postalCode,country,salesRepEmployeeNumber,creditLimit)
		values(c.customerNumber, c.customerName, c.contactLastName, c.contactFirstName,
		c.phone,c.addressLine1,c.addressLine2,c.city,c.state,c.postalCode,c.country,c.salesRepEmployeeNumber,c.creditLimit);

		select * from dimcustomers


merge into dimPayment pay

using(
		select * from sales_au_nz.dbo.payment ) pm on (pay.customerNumber = pm.customerNumber)
		when matched then 
						update set pay.amount=pm.amount
		when not matched then
		insert(customerNumber,checkNumber,paymentDate,amount)
		values(pm.customerNumber,pm.checkNumber,pm.paymentDate,pm.amount);

		
		select * from dimPayment where paymentDate = null
		delete from dimpayment
		   
merge into dimEmployee de

using( select employeeNumber, lastname, firstname,extension,email,reportsTo,jobTitle,city,phone,
		addressLine1, addressLine2,state,country,postalcode,territory from sales_au_nz.dbo.Employee e1
		inner join sales_au_nz.dbo.office of1
		on e1.officeCode = of1.officeCode) eo on (de.employeeNumber = eo.employeeNumber)
		when matched then
							update set de.email = eo.email
		when not matched then
		insert(employeeNumber, lastname, firstname,extension,email,reportsTo,jobTitle,city,phone,
		addressLine1, addressLine2,state,country,postalcode,territory)
		values(eo.employeeNumber, eo.lastname, eo.firstname,eo.extension,eo.email,eo.reportsTo,eo.jobTitle,
		eo.city,eo.phone,eo.addressLine1, eo.addressLine2,eo.state,eo.country,eo.postalcode,eo.territory);
		

		select * from dimEmployee

		--select * from factOrders


merge into factOrders fo
using 
     ( select productkey, customerkey,employeekey,paymentkey, dt1.timekey as [orderdatekey], dt2.timekey as [requiredDateKey],
				dt3.timekey as [shippedDate],od.quantityOrdered as [qtyOrdered], o.orderNumber as [orderNumber], od.priceEach as [priceEach],
				od.quantityordered*od.priceEach as [Totalprice],(od.quantityOrdered*(od.priceEach-p.buyPrice)) as [TotalProfit],
				(od.quantityOrdered*(p.MSRP-p.buyPrice))as [TotalPossibleProfit]
		from sales_au_nz.dbo.orderDetail od, sales_au_nz.dbo.product p,
		sales_au_nz.dbo.productorder o, dimcustomers dc, dimproducts dp, dimEmployee de,
		dimPayment dpay,dimtime dt1, dimtime dt2, dimtime dt3
		where od.ordernumber = o.orderNumber and p.productCode = od.productCode
				and o.customerNumber = dc.customerNumber
				and dp.productCode= od.productCode
				
				                                               
				) 

			