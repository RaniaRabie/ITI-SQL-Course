use ITI	

				-------------------- >>> Views <<< --------------------

-- Student اسمه table مش هيبقي عارف ان في  view لان اللي هيتعامل هيتعامل مع metadata كده انا خفيت
create view Vstuds
as 
	select * from Student

select * from Vstuds

-- ممكن اعمل كده table ومش لازم اجيب الداتا اللي جوه
create view Vcairo
as 
	select St_Id, St_Fname, St_Address
	from Student
	where St_Address = 'cairo'

select * from Vcairo

-- ومش لازم اجيب كل الداتا برضو عادي 
select St_Fname
from Vcairo

-- alias name اني اعملها cols ممكن كمان اخفي اسامي 
create view VcairoAlias(sid, sname, sadd)
as 
	select St_Id, St_Fname, St_Address
	from Student
	where St_Address = 'cairo'

select sname 
from VcairoAlias

-- وزي ما انا عايزة alex ممكن اعمل للناس بتوع cairo للناس بتوع view وزي ما عملت 
create view Valex(sid, sname, sadd)
as 
	select St_Id, St_Fname, St_Address
	from Student
	where St_Address = 'alex'

select * from Valex

-- مع بعض cairo, alex لو حد بيتعامل مع 
select * from VcairoAlias
union all
select * from Valex

-- view وكمان بدل ما بكتب بايده احطهم في
create view VcairoAlex
as
	select * from VcairoAlias
	union all
	select * from Valex

select * from VcairoAlex


-- اكبر وهكذا views ده مع بعض عشان اعملviews صغيرة واركب views بالتالي ممكن احول الداتا بيز لشوية


-- علي طول view لل call اوعمل view بستخدمها كتير ممكن احطها في join statement لو عندي
create view Vjoin
as
	select St_Id, St_Fname, D.Dept_Id, Dept_Name
	from Student S inner join Department D
	on D.Dept_Id = S.Dept_Id

alter view Vjoin(sid, sname, did, dname)
as
	select St_Id, St_Fname, D.Dept_Id, Dept_Name
	from Student S inner join Department D
	on D.Dept_Id = S.Dept_Id

select * from Vjoin 

-- Vjoin view في join وانا مش عاملاله stud_course table لانها في grade طبيعي يعترض لما ابقي عايزة اعرض
select sid, sname, grade, did, dname
from Vjoin

-- stud_course table, Vjoin view بين join خلاص اعمل grade طب لو عايزة اعرض 
select sname, dname, grade
from Vjoin v inner join Stud_Course SC
on v.sid = sc.St_Id

-- view وممكن كمان احطهم في 
create view vGrade
as 
	select sname, dname, grade
	from Vjoin v inner join Stud_Course SC
	on v.sid = sc.St_Id

select * from vGrade

-- لو انت هاكر شاطر شوية ممكن تكتب
sp_helptext 'Vjoin'
-- اللي كنا عايزين نخفيها عنك metadate فتقدر تشوف ال  view هيجيبلك الكود اللي اتكتب بيه ال

-- الحل؟؟
-- view وانت بتكريت with encryption تكتب 
-- للكود مش للداتا encryption وده
-- script ومش هيقدر يعملها vGrade مثلا هيضرب معاك هيجي عند views للداتا بيز وحددت generate script انت حتي لو حبيت ت
alter view vGrade
with encryption
as 
	select sname, dname, grade
	from Vjoin v inner join Stud_Course SC
	on v.sid = sc.St_Id

sp_helptext 'vGrade'

---------------------------------------------------------------------------------------------------------------

-- DML
	-- ؟view بتاع body جوه DML هل ينفع اكتب 
		-- لا مقدرش

	-- table كأنه view علي  DML هل ينفع اعمل
		--  اه اقدر بس بشروط
			-- 1. one table من data جايب view هل ال 
			-- 2. multi tables من data جايب view هل ال 

-- 1. One Table
	/*
		tables ممكن يبقي فيه او مفهوش كل view طبعا احنا متفقين ان 
		يحصل امتي؟ insert طب ال
		:اللي مش موجود دي تسمح بحاجة من الحاجات دي columns ال 
			1. allow null
			2. identity
			3. defualt value عليها
			4. driven
	*/
insert into Vcairo
values (321, 'ali', 'cairo')

-- عمره ما هيشوفه row ل insert بتاع حد تاني وكمان هو عمل view ده هيشتغل عادي  علي الرغم من انه بيعدل فيquery ال 
insert into Vcairo
values (322, 'omar', 'alex')

-- الحل؟؟
-- with check option => بس cairo اعمل كده للناس بتوع insert يعني لما تيجي تعمل view لل check constarin كأنك بتعمل
alter view Vcairo
as 
	select St_Id, St_Fname, St_Address
	from Student
	where St_Address = 'cairo'
	with check option -- check constarin كأنك بتعمل

insert into Vcairo
values (323, 'omar', 'alex') -- كده مش هتشتغل

insert into Vcairo(St_Id,St_Fname ,St_Address)
values (324,'amir', 'cairo')

		-- ؟update لو عايز اعمل	
			-- بس view اللي جوه columns لل update اقدر اعمل
UPDATE Vcairo
SET St_Fname = 'hossam'
WHERE st_id = 321;

		-- view من خلال table جوه rows ل delete اقدر اعمل 
Delete from Vcairo
where St_Id = 322


-- 1. Muli Tables
-- insert, update
	-- واحد بس table ينفع بس بشطرط انها تأثر في
-- insert for 2 rows in diff tables ده مش هيشتغل ليه؟؟ لاننا هنا عملنا
insert into Vjoin(sid, sname, did, dname)
values (21,'nada', 70, 'Cloud Computing')

insert into Vjoin(sid, sname)
values (21,'nada')

-- ليه مش شغالة؟ update محتاجة افهم طالما ينفع اعمل 
/*
	(Updatable)قابلة للتحديث view مش كل   
	:معمولة باستخدام view لو 
		JOIN
		GROUP BY
		DISTINCT
		agg fun(COUNT, SUM, …)

		:بيمنع التحديث لأنها مش مرتبطة بجدول واحد بشكل مباشر لأنه مش عارف هل SQL في الحالة دي 👈 
			؟Student يعدل في	
			؟Department ولا في
	:الخلاصة
		عليها UPDATE لا يمكن عمل JOIN مبنية على View 👈
		(INSTEAD OF TRIGGER) شوية advanced  الااااااااااا في حالة 
	     		
*/
UPDATE Vjoin(sid, sname)
SET sname = 'gamila'
WHERE sid = 21; 

-- Delete XXXXXXXXXXXXXXXXXXX
	-- ليه؟؟
	-- وده مستحيل delete 2 row from diff table بيبقي فيه بيانات طالب وقسم فكأني بقوله row لان ال
	-- one table بترن علي insert, update, delete لان


-----------------------------------------------------------------------------------------------------


-- Indexed View => فيه داتا لاسباب معينة view
	-- ودوري هنا شوية

-- هو حرفيا بياخد كوبي من الداتا Vdate view لما ارن ال
create view Vdata
with schemabinding -- create Indexed View لازم اكتبها لما ابقي عايزة 
as 
	select Ins_Name, Salary
	from dbo.Instructor
	where Dept_Id = 10

alter table instructor 
alter column ins_degree varchar(50) -- ins_degree مفيهاش Vdata ده هيشتغل عادي لان

-- Dept_Id = 10 واخدة كوبي للداتا بتاع الشخص اللي Vdata هيتعرض لان عندك
-- Ins_Name varchar(50) واخداها Vdata وال  Ins_Name varchar(100) ف انت ازاي عايز تخلي 
alter table instructor 
alter column Ins_Name varchar(100) 


------------------------------------------------------------------------------------------------------


-- table وانا بتعامل مع  dbo اي الحالات اللي لازم اكتب فيهم
	-- 1. scalar function
	-- 2. indexed view لو بعمل
	-- 3. تاني server تانية او DB وبجيب داتا من  DB لو واقف علي 