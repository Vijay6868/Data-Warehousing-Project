select od.quantityOrdered as [qtyOrdered], o.orderNumber as [orderNumber], od.priceEach as [priceEach],
				od.quantityordered*od.priceEach as [Totalprice],(od.quantityOrdered*(od.priceEach-p.buyPrice)) as [TotalProfit],
				(od.quantityOrdered*(p.MSRP-p.buyPrice))as [TotalPossibleProfit]
		from orderDetail od,product p, productorder o
		where od.ordernumber = o.orderNumber and p.productCode = od.productCode

		select * from productorder p, payment pay
		where p.customerNumber=pay.customerNumber

		select * from productorder p, customer c,payment pay,orderdetail od,product pr,employee e
		where p.customerNumber=c.customerNumber and pay.customerNumber = c.customerNumber  and od.orderNumber=p.orderNumber
		and pr.productCode = od.productCode and e.employeeNumber=c.salesRepEmployeeNumber

		use DW_northwind
		select*from factOrders

		o.customerNumber=dc.customerNumber and 
		dpay.customerNumber = dc.customerNumber  and 
		od.orderNumber=o.orderNumber and 
		dp.productCode = od.productCode and 
		de.employeeNumber=dc.salesRepEmployeeNumber