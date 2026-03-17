use ITI

------------------------------------------------------------------------------------------

								-- >>> Index <<< --

-- مش هيشتغل ليه؟
-- clustered index اتكريتله automatically فبالتالي table علي PK لان اوريدي عندنا 
create clustered index myIndex
on Student(St_Fname)

-- 
create nonclustered index myIndex
on Student(St_Fname)

-- PK		=>	Constraint	>>	 clustered Index
-- unique	=>	Constraint	>>	 nonclustered Index

-- 2 index ده table هينتج عن 
-- clustered => PK(id), nonclustered => unique (age)
create table test222
(
id int primary key,
name varchar(50),
age int unique
)

-- unique index => nonclustered index
-- unique constraint او عليه unique تكون قيمه  unique index اللي هكريت عليه column لازم ال
-- والا هيطلع ايرور زي كده لانه بيتطبق علي الداتا القيدمة والجديدة
create unique index index4
on Student(st_age)

/*
	 ؟index اللي المفروض اكريت عليها columns مين ال   
	 index اللي هيعملو بيها سيرش كتير وتبدأ تعمل عليها columns من كلام الناس مين ال detect من الاول بتبقي عارف بتبدأ تanalysis في
	 index هتساعدني اعرف الناس بتسيرش ب اي كتير ف ابدأ عليهم  tools
	 - SQL Server Profilier
	 - SQL Server Tuning Advisor
*/ 

select * from student

------------------------------------------------------------------------------------------
					
							-- >>> Table Types <<< --
-- physical table
create table exam(
	eid int,
	edate date,
	numberOfQ int
)
-- drop لو عملتله DB امتي يتشال من 
drop table exam

			--------------- ********************** ---------------

/*
	Local table => session based tables
	note => session اسمها new query كل 
	اللي واقف عليها session علي مستوي local بيكون tempdb ده هيتكريت جوه table ال 
	تاني user مش هيقدر يشوفه لان ده بالنسبالنا select * from #exam وكتبت new query يعني لو عملت
	ID طب السيرفر هيفرق بينهم وبين بعض ازاي؟ هيدي لكل واحد #exam اسمه table وممكن هو كمان يعمل 
*/

create table #exam(
	eid int,
	edate date,
	numberOfQ int
)
/*
	 ؟DB امتي يتشال من 
		 >> drop لو عملتله
		 >> sesstion قفلت 
*/

			--------------- ********************** ---------------

-- Global table => shared tables

/*
	- tempdb بيتكريت جوه
	- واحد بيكريته واي حد بيتدخل والشخص اللي مكريته موجود يقدر يتعامل معاه
*/
create table ##exam(
	eid int,
	edate date,
	numberOfQ int
)

/*
	 ؟DB امتي يتشال من 
		 >> سواء اللي مكريته او اللي بيشتغل عليه disconnect لما كل الناس الموجودة علي السيرفر تعمل  
		 >> drop
*/


			--------------- ********************** ---------------

-- Variable table 
/*
	اللي بيرن جواها batch علي مستوي local 
*/

declare @t table(id int)

------------------------------------------------------------------------------------------