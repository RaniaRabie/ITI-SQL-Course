use ITI

-- top() => query بتشتغل علي الناتج بتاع 
select top(3) * 
from Student

select top(2) St_Fname
from Student

-- 2 salaries هنجيب اعلي 
select top(2) Salary
from Instructor
order by Salary desc

/*
	top() with ties: order by لازم معاها
					 top => العادية top تشتغل زي 
					 with ties => بتجيب الديل معايا	
 				 	  
*/
-- ورجعت 4 صفوف ليه؟ top(3) with ties يعني هنا مثلا عاملين
-- لو ليه ناس هتجيبهم معاها age رجعت بصت علي اخر three rows ف بعد ما جابت اول order by age احنا عاملين
select top(3) with ties * 
from Student
order by St_Age

select NEWID() -- return Global Universal ID (GUID) ==> علي مستوي السيرفر unique id

-- return student data and a GUID with each row
select * , NEWID() as GUID
from Student

-- NEWID() الصفوف بتاخد run الداتا هتظهر بترتيب مختلف لان مع كل run مع كل
select *
from student
order by NEWID()

-- مختلفة three rows هيظهر  run مع كل  top(3) فلو جيت عملت
-- select three random students كأني ب
select top(3)*
from student
order by NEWID()

-------------------------------------------------------------------------

-- ده هيتنفذ عادي
select St_Fname + ' ' + St_Lname as fullName -- 2
from Student -- 1
order by fullName -- 3

-- ده لا
select St_Fname + ' ' + St_Lname as fullName -- 3
from Student -- 1
where fullName = 'Ahmed Mohamed' -- 2

-- مين بيتنفذ قبل مين Execution Order السبب يرجع لحاجة اسمها
-- 1.  from
-- 2.  join
-- 3.  on
-- 5.  where
-- 6.  group
-- 7.  having [agg]
-- 8.  select [distinct, agg]
-- 9.  order by
-- 10. top

-- الحل
-- table الاساسية في columns اما نتعامل مع 
select St_Fname + ' ' + St_Lname as fullName
from Student
where St_Fname + ' ' + St_Lname = 'Ahmed Mohamed'

-- subquery او نعمل
select * 
from	(select St_Fname + ' ' + St_Lname as fullName
		 from Student) as Newtable
where fullName = 'Ahmed Mohamed'

-------------------------------------------------------------------------
-- return server name
SELECT @@SERVERNAME

-- DB Objects[table, view, function, SP, Rule]
/*
	المفروض تعدي عليه defualt path عشان توصله ليه DB Object اي
	path => [Server Name]. [DataBase Name]. [Schema Name].[Object Name]
*/

-- كده علي طول student في العادي بنكتب
select *
from student

-- full path انما المفروض تبقي كده بال
-- اما اشتغلت ازاي؟
/*
	علي السيرفر ف عرف اسمه connect بمعني انا عاملة  by defualt قالك انه خد الحجات 
	موجود جواها table ده student و use iti وكمان انا عاملة 
	defualt schema هو dbo و 
*/ 
select *
from [rania].iti.dbo.student

-- تانية database موجود في Project فلو جيت اشغل حاجة زي كده مش هتشتغل ليه؟ لان
select *
from Project

-- تانية database ل use وانا عاملة database في table عشان اجيب داتا من full path فممكن ساعتها استخدم
select *
from [rania].Company_SD.dbo.Project

-- مع داتا موجودة في داتا بيز تانية join, union ده كمان ممكن اعمل
-- sql server التاني لازم يكون server يبقي ال sql sever اكيد بما اني بستخدم server او حتي 
select Dname
from Company_SD.dbo.Departments
union all
select Dept_Name
from Department

-- مع بعض two columns فبتختار اي PK, FK  ساعتها مفيش join لو حبيت تعمل
-- vales matched in two columns you choose بس طبعا نتأكد ان في


------------------------------------------------------------------------------------


-- select into >> ddl query => تاني table بدلالة table لانه هنا كريت 
--			    copy student into table2
select * into newStud
from Student

-- student اسمه table مش هتنفع تشتغل لان الداتا بيز فيها اوريدي 
select * into student
from Student

-- تاني لو عايز sever تاني او حتي database في student اسمه create table انما كده يشتغل عادي لاني ب 
-- بنفس الاسم table المهم ميكونش فيها
select * into SD.dbo.student
from Student

-- العادية بتاعتنا queries  كله لا عادي ممكن نعمل table مش لازم تاخد
select St_Id, St_Fname into newtable
from Student
where St_Address = 'Alex'

-- تاني table عملت بيه stucture وخدت stucture فصلت الداتا عن
-- copy stucture بدل ما اعمله من الاول اعمل كده وابقي عملت stucture بنفس table ممكن يفيديني اني لو عايزة اكريت 
select * into table2
from Student
where 1 = 2 -- فاضي table مبيتحققش ف بيكريت condition عن طريق اني عملت
/*
   another way => structure بنفس table فترنه فيعملك table هتجيبلك الكود اللي اتعمل بيه ال
   لو انت عامل يعني constraints ساعات الطريقة دي بتكون احسن لان بيكون فيها
   right click on the table >> script table as >> create to >> new query editor window
*/

----------------------------------------------------------------------------------------------

-- تاني table ل tableانقل) لداتا من) insert  طب ازاي اعمل 
-- two tables have the same structure طبعا عشان اقدر اعمل كده لازم

-- insert based on select
insert into table2
select  * from Student

-------------------------------------------------------------------------------------------------

-- ؟ group by من غير having دي هينفع ترن عادي بس ازاي query ال
-- special case => having ب condition فممكن اعمل columns بس من غير agg fun فيها select  لو كانت 
-- agg fun لانها مبتجيش مع where لاني مقدرش اعملها
-- 100 لما يكون عدد الموظفين اكبر من salary هات مجموع query فمعني ال
select sum(Salary)
from Instructor
having count(Ins_Id) > 100

select sum(Salary)
from Instructor
having count(Ins_Id) > 100

-----------------------------------------------------------------------------------------------

-- Ranking functions

/*
	ROW_NUMBER(): Assigns a unique, sequential integer to each row within its partition,
				   starting from 1. If rows have identical values in the ordering column(s), 
				   they still receive distinct row numbers.
*/
select * , ROW_NUMBER() over(order by st_age desc) as RN
from Student


-- RANK() => 
select * , RANK() over(order by st_age desc) as R
from Student

-- DENSE_RANK() => 
select * , DENSE_RANK() over(order by st_age desc) as DR
from Student

/*
	NTILE(#numOfGroups) => Divides the rows in a partition into a specified number of groups (n)
						   and assigns a rank representing the group number to each row. 
						   The number of rows in each group is as equal as possible.
*/
select * , NTILE(3) over(order by st_age desc) as G
from Student

-- this query work as top(1)
-- عندي age هتجيب بيانات اعلي
select * 
from (
	   select * , ROW_NUMBER() over(order by st_age desc) as RN
	   from Student) as newtable
where RN = 1 

-- عندي مع التكرار age هتجيب بيانات اعلي
select * 
from (
	   select * , DENSE_RANK() over(order by st_age desc) as DR
	   from Student) as newtable
where DR = 1 

--
select * 
from (
	   select * , ROW_NUMBER() over(partition by dept_id order by st_age desc) as RN
	   from Student) as newtable
where RN = 1 

--
select * 
from (
	   select * , DENSE_RANK() over(partition by dept_id order by st_age desc) as DR
	   from Student) as newtable
where DR = 1 

----------------------------------------------------------------------------------------

-- case => if زي 
--		   select, update تستخدم مع
select Ins_Name, Salary,
		case 
		when Salary >= 3000 then 'high salary'
		when Salary < 3000 then 'low salary'
		else 'No Value'
		end as newSal
from Instructor

update Instructor
	set Salary =
		case 
		when Salary > 3000 then Salary * 1.10
		else Salary * 1.20
		end	
	
	
-- if condition if else only => iif statement iif(condition, ifTrue, ifFalse) >> function
-- programming في ternary operator نفس فكرة 
select Ins_Name,salary, IIF(Salary >= 300, 'high' , 'low') as newSal
from Instructor

------------------------------------------------------------------------------------------

-- convert date to string
select CONVERT(varchar(20), GETDATE())
select CAST(GETDATE() as varchar(20))

-- اي الفرق؟
-- convert id the best choice why?
-- عايزه ازاي date تالت كده بيعبر عن شكل  parameter لانها بتاخد
-- كل رقم بيعبر عن شكل معين للتاريخ هيكون ازاي
select CONVERT(varchar(20), GETDATE(),102)
select CONVERT(varchar(20), GETDATE(),103)
select CONVERT(varchar(20), GETDATE(),104)
select CONVERT(varchar(20), GETDATE(), 105)

-- format ولأن الموضوع صعب يتحفط واعرف كل رقم  بيعبر عن اي 
-- format => من الاخر تكتب الشكل اللي انت عايزه string لو اديتها التاريخ تقدر تديها الفورمات بتاع التاريخ ك
select FORMAT(GETDATE(), 'dd-MM-yyyy')
select FORMAT(GETDATE(), 'dddd MMMM yyyy')
select FORMAT(GETDATE(), 'ddd MMM yy')
select FORMAT(GETDATE(), 'dddd')
select FORMAT(GETDATE(), 'MMMM')
select FORMAT(GETDATE(), 'hh:mm:ss tt')
select FORMAT(GETDATE(), 'HH')
select FORMAT(GETDATE(), 'hh tt')
select FORMAT(GETDATE(), 'dd-MM-yyyy hh:mm:ss tt')


-- return data type بيعملو نفس الحاجة الفرق في ال
select FORMAT(GETDATE(), 'dd')  -- return string
select DAY(GETDATE())           -- return int


-- eomonth => date وترجع date بتاخد
-- بترجع اخر يوم في الشهر اللي مديهولها
select EOMONTH(GETDATE())
select format(EOMONTH(GETDATE()), 'dddd')
select format(EOMONTH(GETDATE()), 'dd')
select EOMONTH('1/1/2000')


