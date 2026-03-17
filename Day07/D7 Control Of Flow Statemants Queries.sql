use ITI


---------------------------- >>> Control Of Flow Statements <<< ----------------------------
-- if, if else => select مقدرش استخدمها مع
declare @x int
update Student
set St_Age +=1

select @x = @@ROWCOUNT
if @x > 0
	select 'Multiple Rows Affected'
else 
	select 'No rows Affected'

	-- عادي جدا and, or  ممكن اعمل  
	-- برضو عادي if else  ممكن كمان اعمل
	-- {} زي البروجرامنج عندنا begin, end بنحط if تحت line لو عندي اكتر من

DECLARE @Salary INT = 5000;
DECLARE @Position VARCHAR(20) = 'Manager';

if (@Salary > 4000 AND @Position = 'Manager')
	BEGIN
		select 'High salary manager';
		select 'You can approve budgets';
	END
else
    select 'Normal employee';


-- iif => كويسة جدا performance  بنستخدمها لما يقي عندنا حالتين فقط وهيا ك 
		  -- column فبالتالي النتيجة تظهر ك select بقدر استخدم مع
select St_Id, Crs_Id, iif(grade >= 50 , 'Pass', 'Fail') as status
from Stud_Course

-- case => select مع column وعايزة اظهر النتيجة ك condition لو عندنا اكتر من
select Ins_Name, Salary, 
case
	when Salary >= 10000 then 'Senior - No raise Needed'
	when Salary >= 7000 then 'Mid-Level  - 10% raised'
	when Salary >= 5000 then 'Senior - 15% raised'
	else
	'Entry level - 20% raised'
end

from Instructor

-- update مع case ممكن كمان استخدم
-- if else كامل زي  condition بيها مش update بنحط جواها القيم اللي هن
/*
	update Student
	set St_Age +=1 XXXXX
*/
update Instructor
set Salary = Salary *
	case Ins_Degree
	when 'PHD' then 1.20
	when 'Master' then 1.10
	else 1.05
end

-- if exists if not exists

-- app ده بيضرب في error المشكلة ان ال error زي كده في احتمال انها تشتغل او تضرب query لو انا بعمل
--   بالاسم ده ولا لا؟ table طب هو مفيش طريقة تعرفني هل عندنا
-- run query قبل ما check بالاسم ده ولا لا عايزة اعمل table اسألها عندنا metadata بطريقة تانية عايزة اكلم
create table Student(
id int,
name varchar(50)
)

-- sys schema => contains a collection of system catalog views, functions, and procedures
--	     		 that provide metadata about the database and its objects.
-- sys (system schema) => databse بتاع  metadata فيها ال tables, views فيها sys عندها database كل  


-- اللي عندنا tables يعني هنا مثلا بنرجع كل اسامي
select name from sys.tables 

-- ومش هيرجع حاجة لو معندناش student table لو عندنا student ده هيرجع query نرجع للي كنا فيه ال
-- false لا يبقي true بس انا مش مهتمة باللي هيرجه انا بس عايزة اعرف هيرجع حاجة ولا لا لو رجع حاجة يبقي 
select name from sys.tables where name = 'student'

-- عليها نعرف هيا موجودة ولا لا check هنحط جواها الحاجة اللي عايزين ن if exists() عشان كده يجي دور
-- وبناء عليه هننفذ حاجة معينة
if exists (select name from sys.tables where name = 'Student')
	select 'Table with the same Name already exists' 
else
	create table Student(
	id int,
	name varchar(50)
	)
/*
	زي كده ممكن ميشتغلش ليه؟؟  query غالبا برضو 
	instructor,student table مع relationship عنده Department table لان
	app ل error وانا مش عايزة برضو اطلع
*/
delete from Department where Dept_Id = 20

-- الحل؟؟
/*
	relationship ليه معاهم Department اللي tables اللي عايزه امسحه ده موجود في ال dept_id لو check بعمل 
	وعليه بقرر هنعمل اي
*/
if not exists( select Dept_Id from Student where Dept_Id = 20 )
and not exists (select Dept_Id from Instructor where Dept_Id = 20 )
	delete from Department where Dept_Id = 20
else
	select 'Table has relationship'

-- عندنا حل كمان اسهل
-- try, catch => هيجي منين error لو مش واضح معايا اوي ال
begin try
	delete from Department where Dept_Id = 20
end try
begin catch
	select 'error'
	-- لو عايزة اعرض شوية معلومات عن الايرور اللي حصل
	select ERROR_LINE(), ERROR_NUMBER(), ERROR_MESSAGE()
end catch

-------------------------------------------------------------------------------------------
-- ** loops
--		 while
declare @x int = 10
while @x <= 20
	begin 
		set @x += 1
		if @x = 14
			continue
		if @x = 16
			break
		select @x
	end


-- wait for

-- Delay

-- choose


---------------------------------------------------------------------------------------------
-- transaction
------explicit tranaction
create table parent(id int primary key)
create table child (cid int foreign key references parent(id))

-- from 124 - 127 => for now run as batch
insert into parent values(1)
insert into parent values(2)
insert into parent values(3)
insert into parent values(4)

-- from 130 - 132 => for now run as batch
insert into child values(1) -- 1 row affected
insert into child values(5) -- error
insert into child values(3) -- 1 row affected

-- هنلاقي القيم اللي دخلت 1و3 عادي ومفيش تأثير بالايرور
select * from child

truncate table child

-- from 10 - 12 => now run as tranaction
begin transaction
	insert into child values(1) -- 1 row affected
	insert into child values(2) -- 1 row affected
	insert into child values(3) -- 1 row affected
rollback -- فاضي وده منطقي ما انت اللي قولتلهtable علي الرغم من ان كل القيم صح هتلاقي rollback لو حطيت 

select * from child

begin transaction
	insert into child values(1) -- 1 row affected
	insert into child values(5) -- error
	insert into child values(3) -- 1 row affected
commit -- ما انت اللي قولتله برضو table علي الرغم من ان حصل ايرور الا انه دخل البيانات ال commit لو حطيت 

/*
	صح commit, rollback يبقي السؤال المهم ازاي احط 
	commit احنا عايزين لما الدنيا تبقي تمام نحط
	rollback لو حصل مشكلة تبقي
الحل؟؟				
	try catch نعمل
*/

begin try
	begin transaction
		insert into child values(1) 
		insert into child values(2)
		insert into child values(3) 
	commit
end try
begin catch
	rollback
end catch


select * from child
