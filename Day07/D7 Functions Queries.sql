use ITI
-------------------------- >>> Functions <<< --------------------------
-- Bulit in functions
select GETDATE()

select ISNULL(St_Fname, ' ') -- One Replacement
from Student

select coalesce(St_Fname,St_Lname, ' ') -- More Than One Replacement
from Student
 
select UPPER(St_Fname), LOWER(St_Lname)
from Student

select LEN(St_Fname), St_Lname
from Student

select MAX(St_Fname) -- Max ASCII
from Student

-- عايزة اعرض اطول اسم عندي
select top(1) St_Fname
from Student
order by len(St_Fname) desc

select POWER(Salary, 2)
from Instructor

select convert(varchar(20),getdate(), 101)
select format(GETDATE(), 'dd-MM-yyyy')

select DB_NAME()
select SUSER_NAME()

-- Windowing Functions

select s.St_Id as sid, St_Fname as sname, Grade, Crs_Name as Cname 
into grade
from Student s, Stud_Course sc, Course c
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id

select * from grade

/*
	LAG(): Accesses data from row اللي قبلي.
	LEAD(): Accesses data from row اللي بعدي.
*/

-- وجبت درجة اللي قبلي واللي بعد grade ب order عملت 
select sname, grade,
	LAG(grade) over(order by grade) as prev,
	LEAD(grade) over(order by grade) as next
from grade

-- وجبت اسم اللي قبلي واللي بعد grade ب order عملت 
select sname, grade,
	LAG(sname) over(order by grade) as prev,
	LEAD(sname) over(order by grade) as next
from grade

-- نفس اللي فوق بس جبتها لشخص معين
select * from(
select sname, grade,
	LAG(sname) over(order by grade) as prev,
	LEAD(sname) over(order by grade) as next
from grade) as newTable
where sname = 'Saly'

-- اللي فوق كان بيجيب اسم او درجة اللي قبلي واللي بعدي queries  عندنا مشكلة ان في ال
-- حتي لو مش نفس المادة... طب لا انا عايزة درجات اللي قبلي واللي بعدي لنفس المادة

select sname, grade, Cname,
	LAG(grade) over(partition by Cname order by grade) as prev,
	LEAD(grade) over(partition by Cname order by grade) as next
from grade


/*
	FIRST_VALUE(): Returns the first value in the window frame.
	LAST_VALUE(): Returns the last value in the window frame.
*/
select sname, grade,Cname,
	FIRST_VALUE(grade) over(order by grade),
	LAST_VALUE(grade) over(order by grade Rows BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from grade

-- with partition
select sname, grade,Cname,
	FIRST_VALUE(grade) over(partition by Cname order by grade),
	LAST_VALUE(grade) over(partition by Cname order by grade Rows BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from grade


--------------------------------------------------------------------------------
-- User Defined Functions
--	1. Scalar functions
		-- ex1: بتاع الطالب ترجع اسمه id ابعتلها function عايزة اعمل

-- declaration
-- programmability >> Functions بلاقيها في
-- schemaName.funName	<<	معينة schema  احطها جوه create fun ممكن وانا 
create function getName(@id int)
returns varchar(20)

-- body
begin
	declare @name varchar(20)
	select @name = St_Fname from Student where St_Id = @id
	return @name
end

-- call function
-- bulit in functions عشام ميفكرهاش واحدة من dbo لازم اكتب
select dbo.getName(1)

-------------------------------------------------------------------------------------------

--	2. Inline Table functions
	-- ex2: اللي جوه القسم بالمرتب السنوي بتاعهم instructors ترجع اسامي dept بتاخد رقم fun عايز اعمل 
create function getInstructor(@did int)
returns table 
as 
return
(
	select Ins_Name, Salary*12 as totalSalary
	from Instructor
	where Dept_Id = @did
)

-- call => because it return a table
select * from getInstructor(10)
-- عادي فممكن اعمل كده table اتعامل معاها ك
select Ins_Name from getInstructor(10)
-- او كده او اللي عايزه
select sum(totalSalary) from getInstructor(10)

--------------------------------------------------------------------------------------------

--	3. Multi Statements Table Valued functions
/*
	   ex3: fname ترجعلي ليست ب ارقام الطلبة و fname ابعتلها fun عايزة اعمل
			lname ترجعلي ليست ب ارقام الطلبة و lname ابعتلها  
			fullName ترجعلي ليست ب ارقام الطلبة و fullName ابعتلها
			وبناء عليه ينفذ حاجة معينة if statement معينة يعمل عليها keyword يعني من الاخر انا ببعت 
*/

create function getStuds(@format varchar(50))
returns @t table (
	id int,
	name varchar(50)
)
as 
begin
	if @format = 'first'
		insert into @t
		select St_Id, St_Fname from Student

	else if @format = 'last'
		insert into @t
		select St_Id, St_Lname from Student

	else if @format = 'full'
		insert into @t
		select St_Id, St_Fname + ' ' + St_Lname from Student
	return
end

select * from getStuds('full')


-- Noteee: run time اللي جواها في query لاننا بنعرف ال functions جوه execute مينفعش اكتب 
--		   بس select بيبقي جواها fun وال insert or update or delete فممكن يبقي جواها


---------------------------------------------------------------------------------------------