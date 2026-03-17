use ITI

-- موجودة فين؟ stored procedure 
----- programmability => stored procedures

--	3 types of stored procedures
/*
	1. built in SP
		ex: sp_bindrule, sp_unbindrule,
			sp_bindefault, sp_unbindefault,
			sp_help, sp_helptext, sp_helpconstraint, 
			sp_rename, sp_addtype
			sp_databases, ...
*/

------------------------------------------------------------------------

/*
	2. User Defined Stored Procedure
*/

-- before SP
select * 
from Student

-- create SP without parms
create proc GetSt
as 
	select *
	from Student

-- call SP
GetSt
execute GetSt -- هنشوفها بعد شوية execute احيانا لازم نكتب 


-- create SP with parms
create proc GetStbyAdd @add varchar(20)
as 
	select St_Id, St_Fname, St_Address
	from Student

-- call
GetStbyAdd 'Cairo'

-- DML inside SP without validation
create proc InstSt @id int, @name varchar(20)
as
	insert into Student(St_Id, St_Fname)
	values(@id, @name)

InstSt 44, 'ali' --- sec run error
-- عشان نخفيها SP اللي احنا اصلا كنا عاملين meta date وكمان الايرور في معلومات عن  user المشكلة ان الايرور هيضرب كمان عند 


-- DML inside SP with validation
create proc InstStWithValidaton @id int, @name varchar(20)
as
	begin try
		insert into Student(St_Id, St_Fname)
		values(@id, @name)
	end try
	begin catch
		select 'error'
	end catch

InstStWithValidaton 44, 'ali' 



-- SP بتاع call معلومات عن

create proc SumData @x int, @y int
as 
	select @x + @y

SumData 5, 10 -- Call parameter by position => 5 for x, 10 for y (الترتيب مهم)

SumData @y = 9 , @x = 4 -- call by name of the parameter (الترتيب مبقاش مهم)

-- default values تاخد SP ممكن 

create proc AddValues @x int, @y int = 0
as 
	select @x + @y

AddValues 3 -- def value فحط y مبعتناش
AddValues @y = 3  -- def value مبعتناش حاجة وكمان مكناش ادينالها x , y هنا هيطلع ايرور لاني حددتله ان القيمة لل   


-- واتعامل معاه ازاي؟ sp لو عايزة استقبل الناتج بتاع

create proc GetStByAge @age1 int , @age2 int
as
	select St_Id, St_Fname
	from Student
	where St_Age between @age1 and @age2


GetStByAge  20, 25 -- عايزة اخد الناتج ده واتعامل معاه

-- insert based on execute فبنعمل SP موجودة جوه select بس دلوقتي ال insert based on select كنا خدنا اننا ممكن نعمل
insert into tab4
execute GetStByAge  20, 25 -- SP بتاع call قبل execute وهنا دي واحدة من الحالات اللي لازم استخدم
-- وعايزاه يتنفذ الاول query لانه بقي جزء من

declare @t table(x int , y varchar(20))
insert into @t
execute GetStByAge  20, 25
select  * from @t


-- واحدة بس valu طب افرض اللي كان راجع 
-- شوية scalar fun ممكن نكتبها بطريقة شبه

create proc GetAge @id int
as 
	declare @age int
		select @age = St_Age
		from Student
		where St_Id = @id
	return @age

-- Noteee => int بيرجع حاجة واحدة بس ولازم تكون SP بتاع return ال
-- بالشكل ده هيرجع ايرور
declare @x int
set @x = execute GetAge 5
select @x

-- فلازم نخزنه مباشرة بالشكل ده
declare @x int
exec @x = GetAge 5
select @x


/*
	SP بتاع return طب اما اي لازمة ال
	بتاعه bahaviour  وبتعبر عن SP بيقعدوا مع بعض ويتفقو علي شوية ارقام اللي هيرجعهاDB Developer, App Programmer
	مثلا ممكن يتفقو ان لو رجعتلك
	  100 => SP OK
	  200 => PK في مشكلة في
	  300 => FK في مشكلة في 
	SP بتاع behaviour رقم بيعبر عن return ولكن عشان ت SP قيمة من return مش معمولة عشان ت SP بتاع return اذن ال     
	DB Developer, App Programmer والرقم ده محدش بيبقي فاهم المعني بتاعه غير 
*/

-- SP طب لو انا عايزة ارجع حاجة فعلا من
-- SP  عندنا فيparameter انواع
------ 1. retuen => اللي شرحناه فوق
------ 2. input parameter 
------ 3. output parameter => output keyword ويتغيروا التغيير يسمع بره بس بشرط نحط SP ال call بحيث لما ن variable القيم اللي راجعة بشوف انا عايزة منها اي وبمسكها في
--									C# في out زي
--							تاني SP في input ك  SP ممكن تفيديني او استخدمها لو عايزة استخدم الناتج بتاع
create proc GetData @id int, @age int output
as 
	select @age = St_Age
	from Student
	where St_Id = @id

declare @x int
exec GetData 5, @x output
select @x

alter proc GetData @id int, @age int output, @name varchar(20) output
as 
	select @age = St_Age, @name = St_Fname
	from Student
	where St_Id = @id

declare @x int, @y varchar(20)
exec GetData 5, @x output, @y output
select @x,@y

------ 4. input output parameter
-- @age => input output parameter
-- القيمة تتغير فهو يحس بالتغيير ده ويرجع القيمة الجديدة age ولما يجيب ال id ببعت معاه قيمة
-- قبل ما اغيره age فبستغل اني ابعت قيمة جوه from => where => select هتتنفذ كده query لان هنا ال
create proc GetMyData @age int output, @name varchar(20) output
as 
	select @age = St_Age, @name = St_Fname
	from Student
	where St_Id = @age -- St_Id = 5

declare @x int = 6, @y varchar(20)
exec GetMyData @x output, @y output
select @x,@y


create proc GetAllData @col varchar(20), @tab varchar(20)
as
	execute('select ' + @col + 'from ' + @tab)

	-- dynamic query كأننا عملنا 
GetAllData '*', 'student' -- performance, security بس لو عملنا كده ضيعنا كل الكلام اللي بنحكي عن بتاع
-- app developer انما معملهاش عشان اديها ل developer فممكن اعمل دي ليا ك

-- عشان محدش يقدر يوصل للكود encryption ب SP الاحسن كمان نكريت ال 
Alter proc GetMyData @age int output, @name varchar(20) output
with encryption
as 
	select @age = St_Age, @name = St_Fname
	from Student
	where St_Id = @age -- St_Id = 5
sp_helptext 'GetMyData'

declare @x int = 6, @y varchar(20)
exec GetMyData @x output, @y output
select @x,@y

------------------------------------------------------------------------