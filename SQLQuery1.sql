select productkey, customerkey,employeekey,paymentkey, dt1.timekey as [orderdatekey], dt2.timekey as [requiredDateKey],
				dt3.timekey as [shippedDate],od.quantityOrdered as [qtyOrdered], o.orderNumber as [orderNumber], od.priceEach as [priceEach],
				od.quantityordered*od.priceEach as [Totalprice],(od.quantityOrdered*(od.priceEach-p.buyPrice)) as [TotalProfit],
				(od.quantityOrdered*(p.MSRP-p.buyPrice))as [TotalPossibleProfit]
		from sales_au_nz.dbo.customer c,sales_au_nz.dbo.payment pm,sales_au_nz.dbo.orderDetail od, sales_au_nz.dbo.product p,
		sales_au_nz.dbo.productorder o, dimcustomers dc, dimproducts dp, dimEmployee de,
		dimPayment dpay,dimtime dt1, dimtime dt2, dimtime dt3
		where od.ordernumber = o.orderNumber and p.productCode = od.productCode and o.customerNumber=c.customerNumber and c.customerNumber = pm.customerNumber
				
				and o.customerNumber = dc.customerNumber
				and dp.productCode= od.productCode
				and dpay.customerNumber = o.customerNumber
				and de.EmployeeNumber = dc.salesRepEmployeeNumber

				and dt1.date= o.orderdate
				and dt2.date= o.requiredDate
				and dt3.date= o.shippedDate

				order by TotalProfit


				select * from salemodels.orderDetail od,salemodels.productOrder po,customer c,payment p
				where od.orderNumber = po.orderNumber and po.customerNumber=c.customerNumber and c.customerNumber = p.customerNumber

				select*from factOrders