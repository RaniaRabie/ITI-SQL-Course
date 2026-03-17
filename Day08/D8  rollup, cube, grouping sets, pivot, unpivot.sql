--rollup , cube  , grouping sets,  pivot,  unpivot

use test

			------------------ >>> rollup <<< ------------------

create table sales
(
ProductID int,
SalesmanName varchar(10),
Quantity int
)
truncate table sales

insert into sales
values  (1,'ahmed',10),
		(1,'khalid',20),
		(1,'ali',45),
		(2,'ahmed',15),
		(2,'khalid',30),
		(2,'ali',20),
		(3,'ahmed',30),
		(4,'ali',80),
		(1,'ahmed',25),
		(1,'khalid',10),
		(1,'ali',100),
		(2,'ahmed',55),
		(2,'khalid',40),
		(2,'ali',70),
		(3,'ahmed',30),
		(4,'ali',90),
		(3,'khalid',30),
		(4,'khalid',90)
		
select ProductID,SalesmanName,quantity
from sales

-- product ده هيجيبلي مجموع المبيعات لكل 
select ProductID as X,sum(quantity) as "quantities"
from sales
group by ProductID

-- كمان فيه مجموع المبيعات كلها row طب افرض عايزة ازود
-- union ممكن ب 
select ProductID as X,sum(quantity) as "quantities"
from sales
group by ProductID
union all
select 0,sum(quantity)
from sales

-- subquery او 
select sum("quantities") from
	(select ProductID as X,sum(quantity) as "quantities"
	from sales
	group by ProductID) as newTable
	
-- rollup او نعمل
-- sum زيادة فيه row  هتعمل 
-- تاني query اللي موجودة ف fun وتنفذ عليه نفس ال query هيا بتعمل اي بقي >> بتاخد الناتج بتاع
select ProductID as X,sum(quantity) as "quantities"
from sales
group by rollup(ProductID)


-- لكل الموظفين total qty فيه row لكل موظف وبعدين total qty دي مثلا تجيب ال
select SalesmanName as Name,sum(quantity) as Qty
from sales
group by rollup(SalesmanName)


Select isnull(Name,'Total'),Qty
from ( 
select SalesmanName as Name,sum(quantity) as Qty
from sales
group by rollup(SalesmanName)
) as t

select SalesmanName as Name,sum(quantity) as Qty
from sales
group by rollup(SalesmanName)
		

select SalesmanName as Name,Count(quantity) as Qty
from sales
group by rollup(SalesmanName)
		

--order by ProductID,SalesmanName
select ProductID,sum(quantity) as "Quantities"
from sales
group by rollup(ProductID)

-- مع كل موظف product لكل quantities هيجيب مجموع
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by ProductID,SalesmanName

-- هتعمل اي؟ << rollup(ProductID,SalesmanName) لو عملت
-- total sum فيه row هيرجعلي 
-- ProductID << الاول بس column علي fun وتنفذ نفس ال
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by rollup(ProductID,SalesmanName)

-- rollup(SalesmanName,ProductID) لو غيرت الترتيب
-- لكل موظف لوحده sum لانه هيطلع 
select SalesmanName,ProductID,sum(quantity) as "Quantities"
from sales
group by rollup(SalesmanName,ProductID)

--------------------------------------------------------------------------------------------

			------------------ >>> cube <<< ------------------

 -- cube => علي الاثنين rollup  لو عايزاه يعمل 

 --order by ProductID,SalesmanName
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(ProductID,SalesmanName)

 --order by SalesmanName, ProductID
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(SalesmanName,ProductID)


--------------------------------------------------------------------------------------------

			------------------ >>> grouping sets <<< ------------------

-- بس rollup العادية يتبقي اي؟ نواتجgroup by من cube لو طرحنا ناتج ال
-- grouping sets => الثاني col علي rollup الاول و col علي roll up بتعمل group by بتلغي ال
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by grouping sets(ProductID,SalesmanName)

--------------------------------------------------------------------------------------------

			------------------ >>> Pivot and Unpivot OLAP <<< ------------------

--if u have the result of the previouse query
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by SalesmanName,ProductID
-- matrix عايز يطلع الناتج ك client اللي فوق دي سليم بس ال query تمام هو ناتج

/*
	pid		ahmed	ali		khalid	
	1		35		145		30
	2		70		90		70	
	3		60		NULL	30	
	4		NULL	170		90
*/ 
-- columns بقت  rows كانك قلبت
-- Pivot => grop by + rotation for table
SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid],[ali])) as PVT

SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid])) as PVT

SELECT *
FROM sales 
PIVOT (SUM(Quantity) FOR productid IN ([1],[2],[3],[4])) as PVT

Select * from newpivot


select * from newtable


--how to get the table
SELECT * FROM newtable 
UNPIVOT (qty FOR salesname IN ([Ahmed],[Khalid],[Ali])) UNPVT


execute('SELECT * FROM sales 
PIVOT(SUM(Quantity) FOR SalesmanName IN (p1))')

PVT

alter proc p1
as
select distinct(salesmanname)
from sales

p1

