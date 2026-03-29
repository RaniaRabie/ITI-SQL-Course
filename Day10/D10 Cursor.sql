use ITI

-- one block ك rows فيها شوية result set دي هيرجعلنا query الطبيعي عادي اننا لما نرن
select St_Id, St_Fname
from Academic.Student
where St_Address = 'cairo'


-- row by row انا عايز ابدا اتعامل مع الناتج ده
-- cursor اذن يبقي لازم نعمل 

--     >>>>> Steps <<<<< 
-- 1. declare a cursor
declare c1 cursor
for  -- cursor اللي عايزين نطبق عليها query(select statement) بيجي بعدها ال
	select St_id, St_Fname
	from Academic.Student
	where St_Address = 'cairo'
for read only -- cursor بتاع behaviour اللي بيحددو ال read only or update بيجي بعدها 
/*
	read only => rows واعرض loop هنا مثلا يعني مجرد هعمل
	update => update, delete, insert الاصلي سواء بقي table = وابدأ اعدل ال loop او اني اعمل
	  table ولكن اني اعدل علي run update query هنا مش معناها  update يعني حد بالك ان 
*/

-- 2. declare variables (الا لو احتاجت اكتر select statment اللي راجعة من columns بعدد)
declare @id int, @name varchar(20)

-- 3. open cursor (place pointer at first row)
open c1

-- 4. fetch row
-- @id, @name حطهم في id = 1, St_Fname = ahmed اللي فيه row كاني بقوله خد اول 
fetch c1 into @id, @name

-- check @@FETCH_STATUS = 0
-- صح fetch اني عملت  check عشان اعمل
while @@FETCH_STATUS = 0
begin
	select @id, @name
	fetch c1 into @id, @name -- اللي بعده row عشان تنقل لل counter++ فهي بتعمل كأنها infinte loop عشان مدخلش في
end

-- 5. close Cursor
close c1

-- 6. deallocate Cursor
deallocate c1

-- عايزين بقي نعرف ازاي نستفيد منه cursor كده احنا طبقنا مثال ازاي نعمل

/* ----------------------------------------------------- */

-- ب اسماء الطللابarray ده عادي بيرجعلنا زيquery لما بنرن ال
select st_fname
from Academic.Student
where St_Fname is not null

/*
	ahmed, ali, heba, ... ويبقي كده مثلا as a one cell احنا عايزين يرجعلنا الناتج 
	we want to get a list of names of students separated by cooma

	الفكرة ازاي؟
	one variable في concat احنا عايزين نلف علي الاسماء واحد واحد ونعملهم
*/

declare c1 cursor
for
	select st_fname
	from Academic.Student
	where St_Fname is not null
for read only

-- two variable ل declare  ليه عملنا 
-- اللي واقفين عليه والتاني شايل كل الاسماء row واحد هيبقي شايل الاسم اللي راجع من
declare @name varchar(20), @all_names varchar(300) = ''
open c1
fetch c1 into @name
while @@FETCH_STATUS = 0
begin
	set @all_names = CONCAT(@all_names, ', ', @name)
	fetch c1 into @name 
end
select @all_names as AllNames
close c1
deallocate c1

/* ------------------------------------------------- */

/*
	update اعمل cursor في loop اللي هو ممكن وانا بعمل cursor for update المثال ده بقي عايزين نعمل
	10% <= 3000 بمرتبات الموظفين عايزين نزود الناس اللي اقل من list عندنا مثلا
	20% <= للناس اللي مرتباتها اكبر من 3000 update نعمل

	الفكرة ازاي؟
	update or delete وعلي اساسه هنبدا نحدد هنعمل اي row by row تمسك المرتب  loop عايزين نعمل
*/

declare c1 cursor
for
	select Salary
	from Instructor
for update

declare @salary int
open c1
fetch c1 into @salary
while @@FETCH_STATUS = 0
begin
	if @salary >= 3000
		update Instructor
		set salary = @salary * 1.20
		where current of c1 -- كلها مرة واحدة rows لل update الحالي لان من غيرها هيعملrow ال update كاني بقوله انت بت
	else
		update Instructor
		set salary = @salary * 1.10
		where current of c1

	fetch c1 into @salary 
end
close c1
deallocate c1

/* ----------------------------------- */

/*
	 عنده باترن معين كده بيتكرر ان ممكن نلاقي عمرو بعد احمد student table في
	 يقولنا كام مرة عمرو ظهر بعد احمدcursor عايزين نعمل
*/


declare c1 cursor
for
	select St_Fname
	from Academic.Student
	order by St_Id
for read only

declare @count int = 0, @current varchar(20), @next varchar(20)

open c1

fetch next from c1 into @current
fetch next from c1 into @next

while @@FETCH_STATUS = 0
begin

	if @current = 'Ahmed' and @next = 'Amr'
		set @count = @count + 1

	set @current = @next
	fetch next from c1 into @next
end

select @count as count

close c1
deallocate c1


