use dw_salemodels
select * from dimTime

use dw_salemodels
-- Task T1 OLAP Design

--Reports

-- 1)




select productLine, count(dp.ProductKey)as [No. of Products in ProducLine], 
		sum(QtyOrdered) as [Total number of sales],sum(TotalProfit) as [Total Profit/Loss]
from dimProducts dp, factOrders fo

where dp.productKey = fo.ProductKey
group by ProductLine
order by [Total Profit/Loss] desc


--2)


select firstName+' '+lastName as [employee Name], city,country, 
       count(CustomerKey) as [Number of customers supported],sum(TotalProfit) as [Profit generated] 
from  factOrders fo,dimEmployee de
where de.EmployeeKey = fo.EmployeeKey
group by firstName,lastName,city,country
order by [Profit generated] desc

--3) 

Select city,country,sum(fo.ProductKey) as [no. of product sold] , count(dp.ProductLine) as 
		[no. of produclines sold], count(dc.customerNumber) as [Total number of customers Living each city],
		qtyOrdered * priceEach as [Number of sales]
		from dimCustomers dc, factOrders fo, dimProducts dp
where dc.CustomerKey = fo.CustomerKey and fo.ProductKey = dp.ProductKey 
group by city,country



--4 

select customerName,  sum(TotalProfit) as [Total Profit/loss generated],count(ProductLine) as [Product Categories bought],
sum(qtyOrdered)as [Total Number of products bought] from dimCustomers dc, factOrders fo,dimProducts dp, dimTime dt
where dc.CustomerKey= fo.CustomerKey and dp.ProductKey = fo.ProductKey and fo.OrderDateKey=dt.Month
group by customerName, OrderDateKey
order by sum(TotalProfit) desc

--5


select productLine, count(dp.ProductKey)as [No. of Products in ProducLine], 
		sum(TotalProfit) as [Total-Proft],sum(TotalPossibleProfit) as
			[Total-Possible-Profit],(sum(TotalPossibleProfit)-sum(TotalProfit) ) as Difference
from dimProducts dp, factOrders fo

where dp.productKey = fo.ProductKey
group by ProductLine
Order by [Total-Proft] desc
